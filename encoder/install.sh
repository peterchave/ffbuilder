#!/bin/bash
if [ "$#" -ne 3 ]
  then
    echo "Usage ./install.sh <URL to script> <URL of media> <Environment>"
    exit
fi

# Add repos for ffmpeg, graphics and multimedia
sudo add-apt-repository -y ppa:savoury1/ffmpeg4
sudo add-apt-repository -y ppa:savoury1/graphics
sudo add-apt-repository -y ppa:savoury1/multimedia
sudo apt-get update -qq

# Install ffmpeg, npm and fonts-freefont-ttf
sudo apt-get -y install ffmpeg npm fonts-freefont-ttf

# Install PM2 (from npm)
npm install -g pm2

# Download test file to be used by the script (specified as a 2nd parameter)
wget $2

# Download a script generated by ffmpeg
curl -s $1 > script.sh
chmod +x script.sh

# Modify the script with user supplied environment variables (like stream id, event name, entrypoint, etc)
sed -i '1 a\$3' script.sh

# Run the script within pm2, making it start on boot, restart failure
pm2 start -f script.sh
pm2 save
pm2 startup | tail -n 1 > startup.sh
chmod +x startup.sh
./startup.sh
pm2 install pm2-logrotate
pm2 set pm2-logrotate:retain 10

# Set a cron task to restart the encoder every night at 1am
