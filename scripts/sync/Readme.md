# Sync container for land files

This should be run via [Rancher container-crontab](https://github.com/rancher/container-crontab).

## Variables

* `REMOTE_URL`: defaults to `https://localhost` [**required**]
* `TARGET_DIRECTORY`: where to put the files, defaults to `/downloads/landfiles/src/`

[`wget`](https://www.gnu.org/software/wget/) will run on startup, and sync zip files from `REMOTE_URL` into `TARGET_DIRECTORY`.
