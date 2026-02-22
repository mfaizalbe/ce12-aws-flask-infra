#!/bin/bash
# 1. Update and install dependencies
yum update -y
yum install python3-pip git -y
pip3 install flask gunicorn

# 2. Clone EXISTING flask-app repo 
git clone https://github.com/mfaizalbe/flask-app.git
cd flask-app

# 3. Start the app
gunicorn -b 0.0.0.0:8080 app:app