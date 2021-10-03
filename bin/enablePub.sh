#!/bin/bash

# MAGICZ
SERVICE_FILES_DIRECTORY="/etc/systemd/system/"

# enable service
/usr/bin/sudo /bin/systemctl enable $SERVICE_FILES_DIRECTORY'dirpicpublisher.service'