# pst2thunderbird
Convert Outlook email to a format readable in Thunderbird/on linux

# Requires:
readpst/libpst

# Usage:
Use outlook to save the PST file. Then on linux:
```
pst2thunderbird.sh [-v] file.pst [folder]
    -v      verbose
    folder  default output folder: output
```

Move the resultant files in the "folder" to your Thunderbird profile, likely to be something like: /home/$LOGNAME/.thunderbird/????????.default/Mail/localhost
