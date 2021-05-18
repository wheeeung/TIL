#!/usr/bin/env bash

set -e

PROJECT_BASE_PATH='C:\Users\user\PycharmProjects\djangoProject1'

git pull
$PROJECT_BASE_PATH/env/bin/python manage.py migrate
$PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput
supervisorctl restart app

echo "DONE! :)"
