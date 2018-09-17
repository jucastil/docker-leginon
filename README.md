# Leginon CentOS Docker LAMP
A Leginon CentOS 7 Docker LAMP is meant to install a local leginon webserver (myamiweb) running on Linux, Windows or Mac as everything is in one container.

# Features
- Runs as a Docker Container
- CentOS 7
- Apache 2.4 (w/ SSL)
- MariaDB 10.1
- PHP 7.0 or 5.6
- EXIM
- SSH
- phpMyAdmin
- Git
- Drush
- NodeJS

# Installation on CentOS 7 client incluing docker

**NOTE**: all the commands must be run by ROOT.   

Be sure you can run docker on your client.  
``yum install docker docker-ce docker-ce-edge docker-ce-test``  

Start the docker daemon  
``systemctl start docker`` 
 
Create a VLAN interface for your docker.  
- Open the network manager (nnm-connection-editor) and add a new connection    
- Select new (virtual) VLAN, choose as a Parent interface the one connected now  
- Fill up the VLAN ID, inteface name and connection name as you like  
- Give it an IP **on your network**. For example, 192.168.10.10      
- Make it up (ifup vlan-interface-name)  
- Test you can ping it  

Download the docker.     
``git clone https://github.com/jucastil/docker-leginon.git``  
CD into the new folder docker-leginon, start the container.  
This may take time, since the CentOS 7 image is downloaded.  
``./start-sbleginon.sh dockername hostname DOCKER-IP``  

To access the web server visit [https://localhost:8443](https://localhost:8443) for SSL or [http://localhost:8080](http://localhost:8080) for no SSL.

To access phpMyadmin visit [https://localhost:8080/phpmyadmin](https://localhost:8080/phpmyadmin)

Attach to the container by running:
`sudo docker exec -i -t "your container id" /bin/bash`

SSH to the container by running:
`ssh root@localhost -p 8022` Use password: docker. For Windows and Mac substitute `localhost` with the IP of your docker.

Put your web code in /var/www/html/ inside the docker.

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
