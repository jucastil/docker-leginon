# A docker Leginon on CentOS 7
A leginon CentOS 7 docker to install a leginon webserver (myamiweb).  
To be running on Linux, Windows or Mac. Features:  
- CentOS 7 Docker Container , Apache 2.4 (w/ SSL), MariaDB 10.1
- PHP **5.6**, EXIM, ssh, phpMyAdmin, Git, Drush, NodeJS

# CentOS 7 Installation

We start with a clean CentOS 7 system:  
- Updated to the latest kernel (now 3.10.0-862.11.6.el7.x86_64) 
- With **selinux** deactivated (edit ``/etc/selinux/config``, choose disabled, reboot)  
- With two network interfaces (one for the **leginon** network)
- Docker not installed (we will install it here) 
 
**NOTE**: all the commands must be run by ROOT.   

Network configuration checks:     
- Write down your current network configuration : ``ifconfig -a`` .  
- Install the docker daemon:``yum install docker``      
- Start the docker daemon: ``systemctl start docker``  
- Check the network configuration again. You should have a new **bridge** to controls the dockers.   
 
Create a new VLAN interface for your docker.  
- Open the network manager (``nm-connection-editor``) and add a new connection    
- Select new (virtual) VLAN, choose as a Parent interface the one of your **leginon** network    
- Fill up the VLAN ID, give it a meaningful inteface name (for example, leg-em1) and connection name    
- Give it an IP **on the leginon network**. For example, 192.168.0.4      
- Make it up: ``ifup leg-em1``  
- Test you can ping the IP of your virtual interface. 

Initial docker-leginon install
- Choose a folder where the docker will lay  
- Download the docker: ``git clone https://github.com/jucastil/docker-leginon.git``  
- Go into the newly created folder **docker-leginon**, start the docker-leginon.    
``./start-sbleginon.sh dockername hostname DOCKER-IP``  
For example: ``./start-sbleginon.sh sbleginon sbleginon 192.168.0.4`` 

First checks on the container.    
- Check it's running ``docker ps -a`` should show **dockername** as running.
- Ssh in. Type ``ssh -Y root@DOCKER-IP -p 2222``. Default root password is **docker**. You can change it now or later on the installation.
- Check you have **internet access** from inside. This is needed by the installer.``ping www.google.com``  
- Check the web server. Visit [https://DOCKER-IP:8443](https://DOCKER-IP:8443) for SSL or [http://DOCKER-IP:8080](http://DOCKER-IP:8080) for no SSL.
- Check phpMyadmin : visit [https://DOCKER-IP:8080/phpmyadmin](https://DOCKER-IP:8080/phpmyadmin)
- Attach your shell to your container by running: ``docker exec -i -t dockername /bin/bash``

Configuration of leginon in the docker-leginon.    
- Configuration is done with the files inside the **install** folder. Check that you can "ls" from inside and outside the docker.
- Ssh to your container, cd to **install** and run ``./extra-config.sh``. Before running it, **you need to have a registration key**. 

What ``./extra-config.sh`` does, in this order   
  * Setup all the root **PASSWORDS**. 
  * Copy __config.inc.php.phpMyAdmin.docker__ to protect the phpmyadmin web interface
  * Copy __my.cnf.docker__ to setup the right cache limits 
  * Install missing packages via yum  
  * Run the php script __leginon-db-config.php__ to setup the database (it can fail)
  * Run the  __centos7AutoInstallation.py__  a wrap over the official[Autoinstaller CentOS](http://emg.nysbc.org/redmine/projects/leginon/wiki/Autoinstaller_for_CentOS) available on the [Complete Install](http://emg.nysbc.org/redmine/projects/leginon/wiki/Complete_Installation) page.
  * My answers the questions GroEL and EMAN, Xmipp, Spider and Protomo is **N**  
  * Copy __config.php.myamiweb.docker__ to initialize myamiweb (it will be configured later)

**Time for a coffee..** the installation can take like 30 minutes. 

Final checks and the Web Tools Setut Wizard
- Open the browser pointing to  [https://DOCKER-IP/myamiweb/setup](https://DOCKER-IP/myamiweb/setup)  
- User **usr_object**, password **DOCKERLEGINON**

# Mac OSX Installation

We start with a clean OSX 10.13.6 (High Sierra).  
We are not going to configure it so that it runs over a specific interface.  


