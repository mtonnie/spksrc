PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

MANAGE_PY="${SYNOPKG_PKGDEST}/share/paperless/manage.py"

PAPERLESS_DBDIR="${SYNOPKG_PKGDEST}/var/database"
PAPERLESS_STATICDIR="${SYNOPKG_PKGDEST}/var/static"
PAPERLESS_MEDIADIR="${SYNOPKG_PKGDEST}/var/media"


service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Add symlink
    if [ ! -d ${PAPERLESS_STATICDIR} ]; then
        mkdir -p ${PAPERLESS_STATICDIR}
    fi
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} collectstatic >> ${INST_LOG}

    if [ ! -d ${PAPERLESS_DBDIR} ]; then
        mkdir -p ${PAPERLESS_DBDIR}
    fi
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} make migrations >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} make migrate >> ${INST_LOG}
    
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'adminpass')"

    if [ ! -d ${PAPERLESS_MEDIADIR} ]; then
        mkdir -p ${PAPERLESS_MEDIADIR}
    fi

    

    #mkdir -p /usr/local/bin
    #ln -s ${SYNOPKG_PKGDEST}/env/bin/borg /usr/local/bin/borg
    #ln -s ${SYNOPKG_PKGDEST}/env/bin/borgmatic /usr/local/bin/borgmatic
}

#service_postuninst ()
##{
    #rm -f /usr/local/bin/borg
    #rm -f /usr/local/bin/borgmatic
#}
