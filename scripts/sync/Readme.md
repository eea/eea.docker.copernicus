# Sync container for land files

This should be run via [Rancher container-crontab](https://github.com/rancher/container-crontab).

## Variables

* `SOURCE_DIRECTORY`: path relative to `RCLONE_CONFIG_REMOTE_URL`, defaults to `/`
* `TARGET_DIRECTORY`: where to put the files, defaults to `/downloads/landfiles/src/`
* `RCLONE_CONFIG_REMOTE_TYPE`: defaults to `http` [**optional**]
* `RCLONE_CONFIG_REMOTE_URL`: defaults to `https://localhost` [**required**]

### Email configuration
* `POSTFIX_SERVER`: postfix server, default to `postfix`
* `FROM_ADDRESS`: from address, defaults to `noreply@eea.europa.eu`
* `TO_ADDRESS`: to address [**required**]
* `ALLWAYS_SEND_EMAIL`: receive summary on each run on email [**optional**]
* `HOURS_MAX_DURATION`: send warning email if duration of sync is more that number of hours, defaults to 6
* `HOURS_WITHOUT_RUN`: send error if no succesfull sync run was created in number of hours, defaults to 48

[`rclone`](https://rclone.org/http/#usage-without-a-config-file) will run on startup, and sync remote files into `TARGET_DIRECTORY`.
