from .base import *

DEBUG = False
INTERNAL_IPS = ['127.0.0.1',]

DEFAULT_CONFIG_PLACES.insert(0, "/var/packages/papermerge/etc/papermerge.conf.py")

if DEBUG:
    INSTALLED_APPS.insert(0, 'whitenoise.runserver_nostatic')
else:
    MIDDLEWARE.insert(1, 'whitenoise.middleware.WhiteNoiseMiddleware')
    #STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

ALLOWED_HOSTS = cfg_papermerge.get(
    "ALLOWED_HOSTS",
    "[\"*\"]"
)

TIME_ZONE = cfg_papermerge.get(
    "TIME_ZONE",
    "UTC"
)

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file_worker': {
            'class': 'logging.FileHandler',
            'filename': '/var/packages/papermerge/target/var/papermerge_worker.log',
        },
        'file_app': {
            'class': 'logging.FileHandler',
            'filename': '/var/packages/papermerge/target/var/papermerge_app.log',
        },
    },
    'loggers': {
        'mglib': {
            'handlers': ['file_app'],
            'level': 'DEBUG'
        },
        'papermerge': {
            'handlers': ['file_app'],
            'level': 'DEBUG'
        },
        'celery': {
            'handlers': ['file_worker'],
            'level': 'DEBUG'
        },
    },
}
