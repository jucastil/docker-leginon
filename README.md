# Docker Leginon : A CentOS 7 php 5.6 LAMP with a leginon webserver
A Leginon CentOS 7 Docker to install a leginon webserver (myamiweb) running on Linux, Windows or Mac.

# Features
- CentOS 7 Docker Container , Apache 2.4 (w/ SSL), MariaDB 10.1
- PHP **5.6**, EXIM, ssh, phpMyAdmin, Git, Drush, NodeJS

# Installation on CentOS 7 client incluing docker

**NOTE**: all the commands must be run by ROOT.   

Network configuration. 
- Check the network configuration : ``ifconfig -a`` . Make a note of it.  
- Install the docker daemon:``yum install docker``      
- Start the docker daemon: ``systemctl start docker``  
- Check the network configuration again. You should have a new **bridge**.   
 
Create a VLAN interface for your docker.  
- Open the network manager (nnm-connection-editor) and add a new connection    
- Select new (virtual) VLAN, choose a Parent interface  
- Fill up the VLAN ID, give it a meaningful inteface name (for example, em1) and connection name    
- Give it an IP **on your network**. For example, 192.168.0.4      
- Make it up: ``ifup docker-vlan-interface-name``  
- Test you can ping it  

Download the docker: ``git clone https://github.com/jucastil/docker-leginon.git``  
CD into the new folder docker-leginon, start the container.    
``./start-sbleginon.sh dockername hostname DOCKER-IP``  
For example: ``./start-sbleginon.sh sbleginon sbleginon 192.168.0.4`` 

Check it runs, ssh to it, check the services.     
- ``docker ps -a`` should show **dockername** as running.
- To ssh in, type ``ssh -Y root@DOCKER-IP``. Default root password is **docker**. Change it (passwd).
- To access the web server visit [https://localhost:8443](https://localhost:8443) for SSL or [http://localhost:8080](http://localhost:8080) for no SSL.
- To access phpMyadmin visit [https://localhost:8080/phpmyadmin](https://localhost:8080/phpmyadmin)
- Attach to the container by running: ``docker exec -i -t dockername /bin/bash``
- 

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
