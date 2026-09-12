# PAM Configuration for YubiKey and Conditional Lid-based Authentication

This document outlines the steps taken to configure PAM (Pluggable Authentication Modules) on EndeavourOS (Arch Linux) to achieve the following authentication flows:

1.  **`sudo` Authentication:**
    *   **Priority 1:** YubiKey (if plugged in and touched).
    *   **Priority 2 (if YubiKey not used/failed):**
        *   If laptop lid is **open**: Fingerprint authentication.
        *   If laptop lid is **closed**: Password authentication.
2.  **Desktop Session Login (GDM/GNOME):**
    *   **Priority 1:** YubiKey (if plugged in and touched).
    *   **Priority 2 (if YubiKey not used/failed):** Password authentication.

---

## 1. Prerequisites

*   A configured YubiKey (FIDO2/U2F capable).
*   A working fingerprint reader configured with `pam_fprintd.so`.
*   GNOME desktop environment (which typically uses GDM as the display manager).
*   Understanding of basic Linux command-line operations and `sudo`.

---

## 2. Packages Installed

The following packages were installed to enable YubiKey and U2F functionality:

*   `yubico-pam`: Provides the `pam_yubico.so` module for YubiKey authentication.
*   `pam-u2f`: Provides the `pam_u2f.so` module and the `pamu2fcfg` utility for U2F key file generation.

**Installation Command:**
```bash
sudo pacman -S yubico-pam pam-u2f
```

---

## 3. YubiKey Configuration (U2F Key File Generation)

A unique key file is needed to link your YubiKey to your user account.

1.  **Create configuration directory:**
    ```bash
    mkdir -p ~/.config/Yubico
    ```
2.  **Generate the U2F key file:**
    *   Execute the following command. **When prompted, please touch your YubiKey.**
    *   If using `nushell`, use `save` for redirection.
    ```bash
    pamu2fcfg | save ~/.config/Yubico/u2f_keys
    ```
    *   *(If using bash/zsh, the command would typically be `pamu2fcfg -u $(whoami) > ~/.config/Yubico/u2f_keys` or `pamu2fcfg > ~/.config/Yubico/u2f_keys` followed by manual editing for the username if necessary, but the `nushell` variant used above is generic enough.)*
    The generated file `~/.config/Yubico/u2f_keys` contains cryptographic information specific to your YubiKey for your user.

---

## 4. `check-lid.sh` Script

This script checks the laptop's lid state and is used by PAM to conditionally enable authentication methods.

1.  **Create the script file:** `~/check-lid.sh`
    ```bash
    #!/bin/bash
    # Exit with 0 if lid is closed, 1 if open.
    if grep -q "closed" /proc/acpi/button/lid/LID/state; then
      exit 0
    else
      exit 1
    fi
    ```
2.  **Make the script executable:**
    ```bash
    chmod +x ~/check-lid.sh
    ```

---

## 5. `sudo` PAM Configuration (`/etc/pam.d/sudo`)

This section details the changes made to `/etc/pam.d/sudo` to implement conditional authentication for `sudo` commands.

**Original Content (example, may vary slightly):**
```
#%PAM-1.0

auth            sufficient      pam_fprintd.so
auth            include         system-auth
account         include         system-auth
session         include         system-auth
```

**Modified Content:**
```
#%PAM-1.0

auth            sufficient      pam_u2f.so cue [cue_msg="Please touch your YubiKey"]
auth            [success=1 default=ignore] pam_exec.so quiet /home/achraf/check-lid.sh
auth            sufficient      pam_fprintd.so
auth            include         system-auth
account         include         system-auth
session         include         system-auth
```

**Explanation of Logic:**
*   **YubiKey First:** `pam_u2f.so` is tried first. If YubiKey is present and touched successfully, `sudo` access is granted.
*   **Lid State Check (if YubiKey fails):** If YubiKey authentication is not successful (not present, not touched, or fails), `pam_exec.so` runs `check-lid.sh`.
    *   If lid is **closed**, `check-lid.sh` exits 0, `pam_exec.so` succeeds, and `[success=1 default=ignore]` causes PAM to skip the next module (`pam_fprintd.so`), proceeding directly to `system-auth` (password).
    *   If lid is **open**, `check-lid.sh` exits 1, `pam_exec.so` fails, and `default=ignore` allows processing to continue to `pam_fprintd.so`.
*   **Fingerprint (if YubiKey fails and lid open):** `pam_fprintd.so` is tried. If successful, `sudo` access is granted.
*   **Password Fallback:** If all preceding methods fail, `system-auth` handles password authentication.

**Backup File:** `/etc/pam.d/sudo.bak` was created before modification.

---

## 6. Desktop Session Login PAM Configuration (`/etc/pam.d/system-auth`)

This section details the changes made to `/etc/pam.d/system-auth` to implement YubiKey authentication for desktop session logins (e.g., GDM/GNOME login screen).

**Original Content (example, `auth` section may vary slightly):**
```
#%PAM-1.0

auth       required                    pam_faillock.so      preauth
# Optionally use requisite above if you do not want to prompt for the password
# on locked accounts.
-auth      [success=2 default=ignore]  pam_systemd_home.so
auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc
# ... (rest of the file)
```

**Modified Content (relevant `auth` section):**
```
#%PAM-1.0

auth       required                    pam_faillock.so      preauth
# Optionally use requisite above if you do not want to prompt for the password
# on locked accounts.
# Add YubiKey authentication here
auth       sufficient                  pam_u2f.so cue [cue_msg="Please touch your YubiKey"]
-auth      [success=2 default=ignore]  pam_systemd_home.so
auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc
# ... (rest of the file)
```

**Explanation of Logic:**
*   **YubiKey First:** `pam_u2f.so` is inserted as a `sufficient` module. If YubiKey authentication is successful, the user is logged in immediately.
*   **Password Fallback:** If YubiKey authentication fails (not present, not touched, or fails), the authentication flow continues to the subsequent modules in `system-auth`, which handle traditional password authentication (via `pam_unix.so`).

**Backup File:** `/etc/pam.d/system-auth.bak` was created before modification.

---

## 7. Testing Instructions

### For `sudo` Authentication:

1.  **With YubiKey plugged in (lid open or closed):**
    *   Run `sudo echo hello`. You should be prompted to touch your YubiKey. Touch it, and `sudo` access should be granted.
2.  **With YubiKey *not* plugged in and lid **closed**:**
    *   Run `sudo echo hello`. You should be prompted *only* for your password.
3.  **With YubiKey *not* plugged in and lid **open**:**
    *   Run `sudo echo hello`. You should be prompted for your fingerprint.
    *   If fingerprint authentication fails, you should then be prompted for your password.

### For Desktop Session Login (GDM/GNOME):

1.  **Log out of your current GNOME session.**
2.  **At the GDM login screen:**
    *   **With your YubiKey plugged in:**
        *   You should see a message (or implied prompt) to touch your YubiKey.
        *   Touch your YubiKey. If successful, you should log in to your desktop session.
    *   **With your YubiKey *not* plugged in:**
        *   You should be prompted for your password as usual. Enter your password to log in.

---

## 8. Reverting Changes

If you encounter any issues and need to revert these changes:

*   **For `sudo` PAM:**
    ```bash
    sudo mv /etc/pam.d/sudo.bak /etc/pam.d/sudo
    ```
*   **For Session Login PAM:**
    *   **WARNING:** If you are locked out of your session, you will need to access a root shell (e.g., via a live USB, recovery mode, or a pre-existing root TTY session) to run this command.
    ```bash
    sudo mv /etc/pam.d/system-auth.bak /etc/pam.d/system-auth
    ```
*   **Remove `check-lid.sh` and YubiKey key file (optional):**
    ```bash
    rm ~/check-lid.sh
    rm ~/.config/Yubico/u2f_keys
    ```
*   **Uninstall PAM packages (optional):**
    ```bash
    sudo pacman -R yubico-pam pam-u2f
    ```
