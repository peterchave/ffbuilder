#!/bin/bash
if [ "$#" -ne 3 ]
  then
    echo "Usage ./install.sh <URL to script> <URL of media> <Environment>"
    exit
fi

set -m

echo Script: $1
echo Media: $2
echo Environment: $3

# Add repos for ffmpeg, graphics and multimedia
sudo add-apt-repository -y ppa:savoury1/ffmpeg4
sudo add-apt-repository -y ppa:savoury1/graphics
sudo add-apt-repository -y ppa:savoury1/multimedia
sudo apt-get update -qq

# Install ffmpeg, npm and fonts-freefont-ttf
sudo apt-get -y install ffmpeg npm fonts-freefont-ttf

# Install PM2 (from npm)
npm install -g pm2

# Change directory to install location (default /root)
cd /root

# Download test file to be used by the script (specified as a 2nd parameter)
wget $2

# Download a script generated by ffmpeg
curl -s "https://$1" > script.sh
chmod +x script.sh

# Modify the script with user supplied environment variables (like stream id, event name, entrypoint, etc)
sed -i "1 a\ $3" script.sh

# Run the script within pm2, making it start on boot, restart on failure

# Install and setup log rotation
pm2 install pm2-logrotate
pm2 set pm2-logrotate:retain 10
# Start script.sh inside pm2
pm2 start -f script.sh
# Save running state of pm2
pm2 save
# Install systemd scripts to manage pm2
pm2 startup -u root
# Kill current pm2 daemon
pm2 kill
# Start daemon using systemd, so it will survive StackScript termination
systemctl start pm2-root

# Set a cron task to restart the encoder every night at 1am
crontab -l | { cat; echo "0 1 * * * /usr/bin/node /usr/local/bin/pm2 restart all"; } | crontab -
