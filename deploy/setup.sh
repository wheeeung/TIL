#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/wheeeung/TIL.git'

PROJECT_BASE_PATH='C:\Users\user\PycharmProjects\djangoProject1'

echo "Installing dependencies..."
apt-get update
apt-get install -y python3-dev python3-venv sqlite python-pip supervisor nginx git

# Create project directory
mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH

# Create virtual environment
mkdir -p $PROJECT_BASE_PATH/env
python3 -m venv $PROJECT_BASE_PATH/env

# Install python packages
$PROJECT_BASE_PATH/env/bin/pip install -r $PROJECT_BASE_PATH/requirements.txt
$PROJECT_BASE_PATH/env/bin/pip install uwsgi==2.0.18

# Run migrations and collectstatic
cd $PROJECT_BASE_PATH
$PROJECT_BASE_PATH/env/bin/python manage.py migrate
$PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput

# Configure supervisor
cp $PROJECT_BASE_PATH/deploy/supervisor_app.conf /etc/supervisor/conf.d/app.conf
supervisorctl reread
supervisorctl update
supervisorctl restart app

# Configure nginx
cp $PROJECT_BASE_PATH/deploy/nginx_app.conf /etc/nginx/sites-available/app.conf
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf
systemctl restart nginx.service

echo "DONE! :)"
