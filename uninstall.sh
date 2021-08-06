### set magicz
APP_USER="dirpic"
APP_USER_PRIV_SUDOERS_STRING="dirpic"

SERVICE_FILES_DIRECTORY="/etc/systemd/system/"

### stop services
/usr/bin/sudo /bin/systemctl stop dirpicpublisher.service
/usr/bin/sudo /bin/systemctl stop dirpicsubscriber.service

### disable services
/usr/bin/sudo /bin/systemctl disable $SERVICE_FILES_DIRECTORY'dirpicpublisher.service'
/usr/bin/sudo /bin/systemctl disable $SERVICE_FILES_DIRECTORY'dirpicsubscriber.service'

### delete app user from system
sudo userdel $APP_USER

### remove app user's home directory and all downloaded/created files and directory
sudo rm -rf /home/$APP_USER

### delete binaries from systems /usr/bin folder
/usr/bin/sudo /bin/rm -f /usr/bin/dirpicsubscriber
/usr/bin/sudo /bin/rm -f /usr/bin/dirpicpublisher

### delete service files
/usr/bin/sudo /bin/rm -f $SERVICE_FILES_DIRECTORY'dirpicsubscriber.service'
/usr/bin/sudo /bin/rm -f $SERVICE_FILES_DIRECTORY'dirpicpublisher.service'

### delete user reference from sudoers file
#/usr/bin/sudo gawk -i inplace '!'$APP_USER_PRIV_SUDOERS_STRING /etc/sudoers
/usr/bin/sudo sed -i '/'$APP_USER_PRIV_SUDOERS_STRING'/d' /etc/sudoers
