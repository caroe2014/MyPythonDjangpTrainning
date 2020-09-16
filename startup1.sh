pip install -r requirements.txt

# Collect static
#python manage.py collectstatic --no-input

# Migrate database
#python manage.py migrate

# Run celery workers + web app
celery worker -A sikoia -l info -Q default,celery --autoscale=10,1 -B &

gunicorn --bind=0.0.0.0 --timeout 600 --workers=4 wsgi
