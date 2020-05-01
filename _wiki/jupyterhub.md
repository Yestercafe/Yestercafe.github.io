---
layout: wiki
title: JupyterHub Installation
categories: Jupyter
description: How to set up a JupyterHub env on the server
keywords: Jupyter, JupyterHub
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






## Reference
1. [https://jupyterhub.readthedocs.io/en/stable/installation-guide-hard.html](https://jupyterhub.readthedocs.io/en/stable/installation-guide-hard.html)