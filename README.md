# A docker Leginon on CentOS 7
A leginon CentOS 7 docker with a leginon webserver (myamiweb).  
The webserver is connected to a subnet (the **leginon** network).  
The **leginon** network is in principle indepented of the working subnet, but it can be the same.  
If you want to know more about leginon, please refer to the [Leginon Project Page](http://emg.nysbc.org/redmine/projects/leginon/wiki/Leginon_Homepage)
To be running on Linux, Windows or Mac. Features:  
- CentOS 7 Docker Container , Apache 2.4 (w/ SSL), MariaDB 10.1
- PHP **5.6**, EXIM, ssh, phpMyAdmin, Git, Drush, NodeJS

# CentOS 7 Installation

We start with a clean CentOS 7 system,   
- Updated to the latest kernel (now 3.10.0-862.11.6.el7.x86_64) 
- With **selinux** deactivated (edit ``/etc/selinux/config``, choose disabled, reboot)  
- With two network interfaces if we are going to run **myamiweb** on a separate subnet.
- Docker not installed (we will install it here) 
 
**NOTE**: all the commands must be run by ROOT.   

## Creation of a VLAN interface for your docker     
- Write down your current network configuration : ``ifconfig -a`` .  
- Install the docker daemon:``yum install docker``      
- Start the docker daemon: ``systemctl start docker``  
- Check the network configuration again. You should have a new **bridge** to controls the dockers.   
- Open the network manager (``nm-connection-editor``) and add a new VLAN connection    
- Select new (virtual) VLAN, choose as a Parent interface the one of your **leginon** network    
- Fill up the VLAN ID, give it a meaningful inteface name (for example, leg-em1) and connection name    
- Give it an IP **on the leginon network**. For example, 192.168.0.4      
- Make it up: ``ifup leg-em1``  
- Test your virtual interface is active by pinging the IP ``ping 192.168.0.4``. 

## Donwload, install and first checks
- Choose a folder where the docker will lay  
- Download the docker: ``git clone https://github.com/jucastil/docker-leginon.git``  
- Go into the newly created folder **docker-leginon**, start the docker-leginon.  
    
``./start-sbleginon.sh dockername hostname DOCKER-IP``.  
For example: ``./start-sbleginon.sh sbleginon sbleginon 192.168.0.4``     

- Check "dockername" is running ``docker ps -a`` should show it as running.
- Ssh in. Type ``ssh -Y root@DOCKER-IP -p 2222``. Default root password is **docker**.   
For example ``ssh -Y root@192.168.0.4 -p 2222``.
- Check you have **internet access** from inside. This is needed by the installer.``ping www.google.com``  
- Check the web server. Visit [https://DOCKER-IP:8443](https://DOCKER-IP:8443) for SSL or [http://DOCKER-IP:8080](http://DOCKER-IP:8080) for no SSL.
- Check phpMyadmin : visit [https://DOCKER-IP:8080/phpmyadmin](https://DOCKER-IP:8080/phpmyadmin)
- Attach your shell to your container by running: ``docker exec -i -t dockername /bin/bash``

## Configuration of myamiweb    
- Configuration is done with the files inside the **/extra** folder. Check that you can ``ls /extra`` from inside the docker.
- Ssh to your container, cd to **extra** and run ``./extra-config.sh``. Before running it, **you need to have a registration key**. Follow the instructions. The installation **needs your imput**. 

#### What ``./extra-config.sh`` does, in this order   
  * Setup all the root **PASSWORDS**. 
  * Copy __config.inc.php.phpMyAdmin.docker__ to protect the phpmyadmin web interface
  * Copy __my.cnf.docker__ to setup the right cache limits 
  * Install missing packages via yum  
  * Run the php script __leginon-db-config.php__ to setup the database (it can fail)
  * Run the  __centos7AutoInstallation.py__, a wrap over the official[Autoinstaller CentOS](http://emg.nysbc.org/redmine/projects/leginon/wiki/Autoinstaller_for_CentOS) available on the [Complete Install](http://emg.nysbc.org/redmine/projects/leginon/wiki/Complete_Installation) page.
  * My answers the questions GroEL and EMAN, Xmipp, Spider and Protomo is **N**  
  * Copy __config.php.myamiweb.docker__ to initialize myamiweb (it will be configured later)

### You should have by now a fully functional Leginon docker.

## IMPORTANT remarks

- There is **no data share** mapped inside the container.   
If you want to do that, simply edit **start-sbleginon.sh** and start a new instance.
- Once these scripts are done, one needs to run the Web Tools Setup, by opening [https://DOCKER-IP/myamiweb/setup](https://DOCKER-IP/myamiweb/setup).  
NOTE that this is visible only in the same subnet. NOTE that not all the options were tested.
- Users and password are usually the main source of issues at installation time, if you ask me. Please be careful :-) 

# Mac OSX Installation

We start with a clean OSX 10.13.6 (High Sierra). 
To download docker for mac, you need to create a docker ID and [follow the instructions](https://docs.docker.com/docker-for-mac/install/).   

## Starting the docker and first checks

- Start the docker engine. Once it is running, open a terminal, download the zip of this repository, unzip it.
- Open a terminal and cd inside the unzipped folder.    
- Start the docker. Since (in principle) the docker is going to run only locally, you can use 127.0.0.1 as IP. Sample start:
 ``./start-sbleginon.sh sbleginon sbleginon 127.0.0.1``  
- Check the docker is running. ``docker ps -a``. Note that **127.0.0.1** is equivalent to **0.0.0.0**.
- Ssh in. Type ``ssh -Y root@DOCKER-IP -p 2222``. Default root password is **docker**. For example ``ssh -Y root@192.168.0.4 -p 2222``. 
- Check you have **internet access** from inside. This is needed by the installer.``ping www.google.com``  
- Check the web server. Visit [https://127.0.0.1](https://127.0.0.1:8443) for SSL or [http://127.0.0.1:8080](http://127.0.0.1:8080) for no SSL.
- Check phpMyadmin : visit [https://127.0.0.1:8080/phpmyadmin](https://127.0.0.1:8080/phpmyadmin)                 

## Configuration of myamiweb    
- Configuration is done with the files inside the **/extra** folder, as in CentOS 7.
- Ssh to your container, cd to **extra** and run ``./extra-config.sh``. Before running it, **you need to have a registration key**. Follow the instructions.  The installation **needs your imput**. Since we are running inside the docker, the script does the same than for the CentOS 7 install. Please refer to that explanation if you have doubts. 

### You should have by now a fully functional Leginon docker.

## IMPORTANT remarks

- There is **no data share** mapped inside the container.  
If you want to do that, simply edit **start-sbleginon.sh** and start a new instance.
- Once these scripts are done, one needs to run the Web Tools Setup, by opening [https://DOCKER-IP/myamiweb/setup](https://DOCKER-IP/myamiweb/setup).  
NOTE that this is visible only in the same subnet. NOTE that not all the options were tested.
- Users and password are usually the main source of issues at installation time, if you ask me. Please be careful :-) 

# Windows Installation

To be done... 
