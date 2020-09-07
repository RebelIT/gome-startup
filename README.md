# gome-startup
GoLang Home Automation - RaspberryPi Setup and gome Installation

A simple run once to setup, build, and configure the gome application services with
docker compose.

This is not a how to use gome, only the compose setup. refer to other `gome-*` services for how to use it.  more documentation will be linked as it is written.

## raspberryPi Setup
i suggest you do the following, but not required.
* set timezone
* set hostname
* reset PW
* turn off wifi sleep
* add your ssh key

## How To Use This:
**NOTE** - i setup everything from the pi user's home dir, change paths if you want.
1. setup your raspberryPi per above suggestions
1. log into the pi
1. `git clone https://github.com/RebelIT/gome-startup.git`
1. `cd gome-startup`
1. edit the `startUp.sh` & change versions (skip this for default master/latest)
  * ex: GOME_CORE_VERSION=1.0.0
  * ex: GOME_SCHEDULE_VERSION=1.0.1
6. edit the `core-config.env` for any default app config overrides you wish
  * quickstart: leave default
7. edit the `schedule-config.env` for any default app config overrides you wish
  * **REQUIRED** : you need to add the rasspberryPi's IP for this to work.  it needs to talk to the core service.
  * ex: `SCHEDULE_CORE_URL="http://192.168.1.100"`
8. run `sudo ./startUp.sh`
9. run `systemctl start gome` - **NOTE** if this is the 1st time it builds the containers and may take a while.  watch the logs.
10. in a new terminal run `sudo journalctl -fu gome` to see the logs.

Setup is complete and working. Start making API calls and adding devices to manage.

Working example logs:
```
docker-compose[18229]: Starting compose_gome-schedule_1 ...
docker-compose[18229]: Starting compose_gome-core_1     ...
docker-compose[18229]: [167B blob data]
docker-compose[18229]: gome-core_1      | Running the program
docker-compose[18229]: gome-core_1      | 2020/09/07 00:00:14 INFO: I'm starting
docker-compose[18229]: gome-core_1      | 2020/09/07 00:00:14 INFO: loading runtime configuration
docker-compose[18229]: gome-schedule_1  | Running the program
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: I'm starting
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: loading runtime configuration
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: Initialize the databases
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: listening gome-schedule on http:6661
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: starting schedule runners
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: toggle schedules processing start
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 INFO: state schedules processing start
docker-compose[18229]: gome-core_1      | 2020/09/07 00:00:14 INFO: listening gome-core on http:6660
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 WARN: no state schedules to process, should there be?
docker-compose[18229]: gome-schedule_1  | 2020/09/07 00:00:14 WARN: no toggle schedules to process, should there be?
```

## Upgrade/downgrade gome:
1. edit the `startUp.sh` & change versions to what you want
  * ex: GOME_CORE_VERSION=1.4.8
  * ex: GOME_SCHEDULE_VERSION=1.2.0
2. run with upgrade param `sudo ./startUp.sh upgrade` - probably a better way to do this, but it works for now. 
