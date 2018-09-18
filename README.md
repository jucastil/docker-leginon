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
- Ssh in. Type ``ssh -Y root@DOCKER-IP -p 2222``. Default root password is **docker**. 
- Logged in as root, change the root password by typing ``passwd``.
- Check you have internet access from inside. Logged in as root, ``ping www.google.com``  
- Check the web server. Visit [https://DOCKER-IP:8443](https://DOCKER-IP:8443) for SSL or [http://DOCKER-IP:8080](http://DOCKER-IP:8080) for no SSL.
- Check phpMyadmin : visit [https://DOCKER-IP:8080/phpmyadmin](https://DOCKER-IP:8080/phpmyadmin)
- Attach the sheel to your container by running: ``docker exec -i -t dockername /bin/bash``

Configuration of leginon in the docker-leginon.    
- Configuration is done with the files inside the install folder. The install folder is shared, so everything you put there will be available inside the container. Check that you can "ls" it on both.
- Ssh inside the container, run ``python centos7AutoInstallation.py``. This is a customized version of the (http://emg.nysbc.org/redmine/projects/leginon/wiki/Autoinstaller_for_CentOS)[Autoinstaller_CentOS] available on the (http://emg.nysbc.org/redmine/projects/leginon/wiki/Complete_Installation)[Complete_Install] official page. Don't forget to ask there for a *registration key*!   
- My answers the questions GroEL and EMAN, Xmipp, Spider and Protomo is *N*  

Time for a coffee...


# Example Usage with Data Outside of Docker

Create a project folder and database folder:
`mkdir -p project/database && mkdir -p project/html`

Move into the project folder:
`cd project`

Run the command to launch the docker and map project and database directory:
``docker run -d -p 8080:80 -p 8443:443 -p 8022:22 -v `pwd`/html:/var/www/html -v `pwd`/database:/var/lib/phpMyAdmin/upload -t otherdata/centos-docker-lamp:latest``

You can now move a copy of your Drupal or WordPress files into the html folder and move an .sql dump into the database folder, or upload it using phpMyAdmin. 

To access the web server visit [https://localhost:8443](https://localhost:8443) for SSL or [http://localhost:8080](http://localhost:8080) for no SSL.

To access phpMyadmin visit [https://localhost:8080/phpmyadmin](https://localhost:8080/phpmyadmin)
