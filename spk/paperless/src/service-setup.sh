PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

CFG_FILE="${SYNOPKG_PKGDEST}/etc/paperless"
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

    #Create configuration file /etc/paperless.conf
    echo "PAPERLESS_DBDIR=$PAPERLESS_DBDIR" >> ${CFG_FILE}
    echo "PAPERLESS_STATICDIR=$PAPERLESS_STATICDIR" >> ${CFG_FILE}
    echo "PAPERLESS_MEDIADIR=$PAPERLESS_MEDIADIR" >> ${CFG_FILE}
    #if [[ "$wizard_provider_gdriv" == "true" ]]; then
    #        echo "TRANSFERSH_PROVIDER=gdrive" >> ${CFG_FILE}
    #fi

    #Create directories
    if [ ! -d ${PAPERLESS_STATICDIR} ]; then
        mkdir -p ${PAPERLESS_STATICDIR}
    fi
    if [ ! -d ${PAPERLESS_DBDIR} ]; then
        mkdir -p ${PAPERLESS_DBDIR}
    fi
    if [ ! -d ${PAPERLESS_MEDIADIR} ]; then
        mkdir -p ${PAPERLESS_MEDIADIR}
    fi
    
    #Collect static files
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} collectstatic >> ${INST_LOG}
    
    #Initialize database
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
    
    #Create admin user
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'adminpass')"

}
