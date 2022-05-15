#!/usr/bin/env bash

PREFERENCES_PATH=~/.config/BraveSoftware/Brave-Browser/Default/Preferences
SUBMODULE=preferences

suffix=$(date +%m%d%y_%H%M%S)
fileName=Preferences_${suffix}.json
backupFilePath=$SUBMODULE/$fileName
md5CheckSum=lastbackup
runType=check

copyPreferences() {
    cp $PREFERENCES_PATH $backupFilePath
}

validateCheckSum() {
    if [ -f "$md5CheckSum" ]; then
        md5sum -c $md5CheckSum > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            md5sum $PREFERENCES_PATH > $md5CheckSum
        else
            return 1
        fi
    else
        md5sum $PREFERENCES_PATH > $md5CheckSum
    fi

    return 0
}

checkLastBackup() {
    validateCheckSum
    if [ $? -ne 0 ]; then
        echo "exiting: no changes to 'Preferences' file."
        exit 1
    else
        echo "changes to 'Preferences' file detected. performing backup..."
        copyPreferences
    fi
}

pushBackup() {
    commitMessage="Backup: $(date "+%b %d, %Y")"

    cd $SUBMODULE
    git checkout main
    git add $fileName
    git commit -m "$commitMessage"
    git push
    cd ..
    git add $SUBMODULE
    git commit -m "$commitMessage"
    git push
}

usage() {
    echo "usage: backup [run-type]"
    echo "    run-type: force, check (default: check)"
}


if [ "$#" -gt 1 ]; then
    echo "error: to many peremeters"
    usage
    exit 1
fi


if [ -n "$1" ]; then
    runType=$1
fi


if [ $runType == "force" ]; then
    copyPreferences
elif [ $runType == "check" ]; then
    checkLastBackup
else
    echo "error: invalid run-type: $runType"
    usage
    exit 1
fi


pushBackup
