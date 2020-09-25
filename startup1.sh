#!/bin/sh

celery worker -A sikoia -l info -Q default,celery --autoscale=10,1 -B &
GUNICORN_CMD_ARGS="--timeout 600 --access-logfile '-' --error-logfile '-' --bind=0.0.0.0:8000 --workers=4 --chdir=/home/site/wwwroot" gunicorn company.wsgi
