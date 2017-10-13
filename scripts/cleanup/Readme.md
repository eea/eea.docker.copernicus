# Cleanup container for land file downloads

This should be run via [Rancher container-crontab](https://github.com/rancher/container-crontab).

## Variables

* `TARGET_DIRECTORY`: defaults to `/downloads/landfiles/dst/`

`reaper.py` will run on startup, and look for expired files in `TARGET_DIRECTORY`.
