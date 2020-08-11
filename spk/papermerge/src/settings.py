from .base import *

DEFAULT_CONFIG_PLACES.insert(0, "/var/packages/papermerge/etc/papermerge.conf.py")

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
            'level': 'INFO'
        },
    },
}
