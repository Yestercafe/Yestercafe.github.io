---
layout: wiki
title: JupyterHub Deployment
categories: Jupyter
description: How to set up a JupyterHub env on the server
keywords: Jupyter, JupyterHub
archived: true
---

## Prerequisites
1. You MUST own the server with root access.
2. This post ONLY test on an Ubuntu 18.04 VPS host.

## Part I. JupyterHub and JupyterLab
### Setup the JupyterHub and JupyterLab in a venv
Firstly, create a Python virtualenv for our whole installation separately. According to the official website, the folder `/opt` is a location of apps which are not belonging to the OS. So, we use:  
```bash
sudo python -m venv /opt/jupyterhub
```
I used `conda activate` without Python in system paths, thus this part got a crash. In this situation, you need to activate Anaconda Python venv for sudoer:  
```bash
sudo -s
conda acitvate
python -m venv /opt/jupyterhub
```
I suggest to use `sudo -s` **unconditionally**. After here, I assume that `sudo -s` has been used by default. 

Then, activate the new virtualenv:  
```bash
source /opt/jupyterhub/bin/activate
```
Now you can see a descriptor `(jupyterhub)` on the head.  

Install necessary contents using the following commands:  
```bash
pip install wheel
pip install jupyterhub jupyterlab
pip install ipywidgets
```

JupyterHub defaults to requiring `configurable-http-proxy`, which needs `nodejs` and `npm`, so install them:   
```bash
sudo apt install nodejs npm
```
Before install `configurable-http-proxy`, switch npm source into Taobao mirrors for users in China:   
```bash
npm install express --registry=https://registry.npm.taobao.org
```
then install it:
```bash
npm install -g configurable-http-proxy
```

### Configuration for JupyterHub

Now we start creating configuration files. For convenience, we keep everything together:  

```bash
mkdir -p /opt/jupyterhub/etc/jupyterhub
cd /opt/jupyterhub/etc/jupyterhub
```

We will create the default configuration file `/opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py`. Set the following configuration option in this file:   

```python
c.Spawner.default_url = '/lab'
```

### Setup Systemd service

In this part, JupyterHub will be set as a system service and can be run by using Systemd.  

Firstly, create the folder for the service file:  

```bash
mkdir -p /opt/jupyterhub/etc/systemd
```

The create `/opt/jupyterhub/etc/systemd/jupyterhub.service`, and copy the following texts and paste into it:  

```
[Unit]
Description=JupyterHub
After=syslog.target network.target

[Service]
User=root
Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin"
ExecStart=/opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py

[Install]
WantedBy=multi-user.target
```

Then we need to make a symlink our service file into the system directory:  

```bash
ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service
```

Finally, reload systemd's configuration files and enable the service on boot:  

```bash
systemctl daemon-reload
systemctl enable jupyterhub.service
systemctl start jupyterhub.service
```

Check it's running status:  

```bash
systemctl status jupyterhub.service
```

## Part II. Conda Environments

### Install conda for the whole system

Install Anconda using this command:  

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
```

or use Tsinghua mirrors for Chinese users:  

```bash
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2020.02-Linux-x86_64.sh
```

You can find the latest version on [the official website](https://www.anaconda.com/products/individual).

Install conda in `/opt` directory. 

Then make a symlink to the profile folder so that it gets run on login.  

```bash
ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
```

### Install a default conda environment for all users

First create a folder for conda envs:  

```bash
mkdir /opt/conda/envs
```

Then create a new conda environment with `ipykernel`.  You can call it whatever you like.  

```bash
/opt/conda/bin/conda create --prefix /opt/conda/envs/python python=3.7 ipykernel
```

Wait for a minute. 

### Setting up users' own conda environments

Users can use the following command enable their own kernel by `ipykernel`:  

```bash
python -m ipykernel install --name 'python-my-env' --display-name "Python My Env"
```

This will place the kernel spec into their home folder, where Jupyter will look for it on startup.  

## Setting Up a Reverse Proxy (Optional)

### Using Nginx

Install Nginx:  

```bash
sudo apt install nginx
```

Edit the JupyterHub configuration file, add the line:  

```python
c.JupyterHub.bind_url = 'http://:8000/jupyter'
```

Now configure Nginx. Firstly, back up the original file:  

```bash
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
```

 New a `/etc/nginx/sites-available/default`, Add this snippet:  

```
map $http_upgrade $connection_upgrade {
	default upgrade;
	'' close;
}
server {
	listen 80;
	listen [::]:80;

	server_name _;

	location /jupyter/ {
	proxy_pass http://127.0.0.1:8000;

		proxy_redirect off;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $connection_upgrade;
	}
}
```

Restart `nginx.service` and `jupyterhub.service`:  

```bash
systemctl restart jupyterhub.service
systemctl restart nginx.service
```

Browse to `123.456.789.1/jupyter` to test Nginx runnable.  


## Reference
1. [https://jupyterhub.readthedocs.io/en/stable/installation-guide-hard.html](https://jupyterhub.readthedocs.io/en/stable/installation-guide-hard.html)