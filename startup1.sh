#!/bin/sh

#pip install -r requirements.txt

# Collect static
#python manage.py collectstatic --no-input

# Migrate database
#python manage.py migrate
#celery worker -A sikoia -l info -Q default,celery --autoscale=10,1 -B &

#gunicorn --bind=0.0.0.0 --timeout 600 --workers=4 wsgi

# Enter the source directory to make sure the script runs where the user expects
cd /home/site/wwwroot

if [ -z "$HOST" ]; then
                export HOST=0.0.0.0
fi

export PORT=8000

export PATH="/opt/python/3.7.7/bin:${PATH}"
echo Found virtual environment .tar.gz archive.
extractionCommand="tar -xzf antenv.tar.gz -C /antenv"
echo Removing existing virtual environment directory '/antenv'...
rm -fr /antenv
mkdir -p /antenv
echo Extracting to directory '/antenv'...
$extractionCommand
PYTHON_VERSION=$(python -c "import sys; print(str(sys.version_info.major) + '.' + str(sys.version_info.minor))")
echo Using packages from virtual environment 'antenv' located at '/antenv'.
export PYTHONPATH=$PYTHONPATH:"/antenv/lib/python$PYTHON_VERSION/site-packages"
echo "Updated PYTHONPATH to '$PYTHONPATH'"

celery worker -A sikoia -l info -Q default,celery --autoscale=10,1 -B &

GUNICORN_CMD_ARGS="--timeout 600 --access-logfile '-' --error-logfile '-' --bind=0.0.0.0:8000 --workers=4 --chdir=/home/site/wwwroot" gunicorn company.wsgi
