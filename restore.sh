#!/bin/bash

PREFERENCES_PATH=~/.config/BraveSoftware/Brave-Browser/Default/Preferences
SUBMODULE=preferences

lastBackup=$(ls -s preferences | grep Preferences | tail -1 | awk -F ' ' '{print $2}')

cp -f $SUBMODULE/$lastBackup $PREFERENCES_PATH 
echo "copied $SUBMODULE/$lastBackup to $PREFERENCES_PATH"
