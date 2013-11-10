Vote for us here!
https://www.hackerleague.org/hackathons/music-hack-day-boston-2013/hacks/gearo-worship

Gearo Worship
=============

Artist Gear Database and Acquisition Service

![Mascot Skull](https://dl.dropboxusercontent.com/u/3767393/ajax_loader.gif)

So, you want to run this? I hope you have a debian-based Linux system

1. Copy config/reverb.yml.example to config/reverb.yml, get a Reverb.com API key, and stick the key in that file
2. sudo apt-get install mysql-server-5.5 mysql-client-5.5 libmysqlclient-dev libxml2-dev libxslt1-dev beanstalkd
3. rake db:create
4. rake db:migrate
5. bundle install
6. sudo vi /etc/default/beanstalkd and uncomment the last line
7. sudo service beanstalkd start
8. rake backburner:work
9. rails server
