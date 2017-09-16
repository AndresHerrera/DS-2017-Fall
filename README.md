# DS-2017-Fall
Homeworks for DS-2017-Fall (Univalle)

<h2><b>Homework 1: Simple Bash scripting for Virtual Machines</b></h2>
<b>+ MS-DOS Version using VBoxManage</b>
<br>
* source: https://github.com/AndresHerrera/DS-2017-Fall/tree/master/HW1/wm-commander-dos.bat
<img src="HW1/snap1.png" width="400"/>
<b>+ LINUX Version using VBoxmanage</b><br>
* source: https://github.com/AndresHerrera/DS-2017-Fall/tree/master/HW1/vm-sandbox-unix.sh<br>
<a href="https://asciinema.org/a/CK8jAoCh3obyAugtv5CQSMeWH" target="_blank"><img src="https://asciinema.org/a/CK8jAoCh3obyAugtv5CQSMeWH.png" width="400"/></a>
<br>
<h2><b>Homework 2: Simple Vagrant - development environments</b></h2> 
<b>+ Single Ubuntu Machine + PostgreSQL </b>
<br>
* source: https://github.com/AndresHerrera/DS-2017-Fall/tree/master/HW2/SingleDBMachine
<br>
<a href="https://asciinema.org/a/3fT2Fy5xEwd4LdAEcpZj4rqdM" target="_blank"><img src="https://asciinema.org/a/3fT2Fy5xEwd4LdAEcpZj4rqdM.png" width="400" /></a>
<br> 
- vagrant up <br> 
* postgresql server guest port:5432 -> host forwarding port:5433 <br>
- psql -U vagrant -p 5433 -h localhost -d dbtest <br>
- ?password: vagrant <br>
<br>
<b> + Two environmets (web): Apache Server (db): PostgreSQL Server </b>
<br> 
<a href="https://asciinema.org/a/bHplww56WxWXnRHvYd80aV4sq" target="_blank"><img src="https://asciinema.org/a/bHplww56WxWXnRHvYd80aV4sq.png" width="400"/></a>
<br>
- vagrant up <br>
- vagrant ssh web <br> 
- vagrant ssh db <br>
* apache server guest port:80 -> host forwarding port:8080 <br>
- lynx http://localhost:8080 <br>
* postgresql server guest port:5432 -> host forwarding port:5433 <br>
- psql -U vagrant -p 5433 -h localhost -d dbtest <br>
- ?password: vagrant <br>
<br>

