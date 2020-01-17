# Version 0.1 -- see README.md


# Set local variables. Change the value in "" to reflect your environment.

:local hostname "MyRouterboard";
:local username "backup-user"
:local password "backup-password"
:local ftpserver "IP-address"
:local destpath "/backup/anotherdir"

# Set Filename variables. Do not change this unless you want to edit the format of the filename.

:local time [/system clock get time];
:local date ([:pick [/system clock get date] 0 3]  \
. [:pick [/system clock get date] 4 6] \
. [:pick [/system clock get date] 7 11]);
:local filename "$hostname-$date-$time";

# Create backup file and export the config.

export compact file="$filename"
/system backup save name="$filename"

:log info "Backup Created Successfully"

# Upload config file to FTP server.

/tool fetch address=$ftpserver src-path="$filename.rsc" \
user=$username mode=ftp password=$password \
dst-path="$destpath/$filename.rsc" upload=yes

# Upload backup file to FTP server.

/tool fetch address=$ftpserver src-path="$filename.backup" \
user=$username mode=ftp password=$password \
dst-path="$destpath/$filename.backup" upload=yes

:log info "Backup Uploaded Successfully"

# Delete created backup files once they have been uploaded in order to save RB space

/file remove "$filename.rsc"
/file remove "$filename.backup"

:log info "Local Backup Files Deleted Successfully"
