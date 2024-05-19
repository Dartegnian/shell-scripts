# *nix Shell Scripts
Shell scripts for Unix-based systems, mostly for (Arch) Linux.

## What's inside

### Restic backup script
`backup_restic.sh`

A script for backing up my local folders onto my own cloud storage. It needs to be run as root and have the proper directories set up.

### Backup script
`backup.sh`

State-of-the-art, high-performant, Excel-spreadsheet-driven script to backup all my precious dotfiles without the need for me to manually transfer the configuration scripts to The Cloud™.

Generally backs up configs that manually need to be copied (for now), like NPM packages, and system packages.

### Maim screenshot taker
Takes a screenshot with `maim` with `--screen`/`-s`, `--screen-temp`/`-t`, `--area`/`-a` as parameters.

### Microphone toggler
Toggles between muting and unmuting the default microphone source in PulseAudio and shows a desktop notification. Not sure if it works in PipeWire or even ALSA.

### MOTD updater
Configures the MOTD in my Linux system to mimic that of the startup messages in AT&T Unix System V because it looks cool.

### Restic file backup
Uploads configured folders and tags onto some cloud storage solution. Must be configured via `/etc/restic-env`.

### Update script
Thingamajig that updates your ((Arch)) Linux install and all the penguins inside. Written by me, for me, and probably only used by me. I'm trying my best to write a shell script, okay? Hmph.


## Deprecated


### GAME MODE™
GAME MODE `ON`/`OFF` turns on GAME MODE™ for my Linux system.
