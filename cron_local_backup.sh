#!/bin/bash

log_file="/home/user/cronlogfile.log"

if rsync -avh --delete --checksum --exclude=".*" ~/ /tmp/backup >> "$log_file" 2>&1; then
	logger "Backup completed successfully at $(date)"
else
	logger "Backup completed with errors at! $(date)"
fi
