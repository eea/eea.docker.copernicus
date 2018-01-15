# Sync container for land files

This should be run via [Rancher container-crontab](https://github.com/rancher/container-crontab).

## Variables

* `SOURCE_DIRECTORY`: path relative to `RCLONE_CONFIG_REMOTE_URL`, defaults to `/`
* `TARGET_DIRECTORY`: where to put the files, defaults to `/downloads/landfiles/src/`
* `RCLONE_CONFIG_REMOTE_TYPE`: defaults to `http` [**optional**]
* `RCLONE_CONFIG_REMOTE_URL`: defaults to `https://localhost` [**required**]

[`rclone`](https://rclone.org/http/#usage-without-a-config-file) will run on startup, and sync remote files into `TARGET_DIRECTORY`.
