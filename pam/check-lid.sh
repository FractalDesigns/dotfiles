#!/bin/bash
# Exit with 0 if lid is closed, 1 if open.
if grep -q "closed" /proc/acpi/button/lid/LID/state; then
  exit 0
else
  exit 1
fi
