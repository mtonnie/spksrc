PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

MANAGE_PY="${SYNOPKG_PKGDEST}/share/paperless/manage.py"

WORKER_PID_FILE="${SYNOPKG_PKGDEST}/var/WORKER_${SYNOPKG_PKGNAME}.pid"

GROUP="sc-paperless"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/gunicorn paperless.wsgi --bind 0.0.0.0:8880 --log-file ${LOG_FILE} --pid ${PID_FILE} --workers=1 --chdir=${SYNOPKG_PKGDEST}/share/paperless --daemon"

init_variables () {
    if [ -f ${INST_VARIABLES} ]; then
        . ${INST_VARIABLES}
    else
        echo "WIZARD_DATA_DIRECTORY=${wizard_data_directory}" >> ${INST_VARIABLES}
        echo "WIZARD_SECRET_KEY=${wizard_secret_key}" >> ${INST_VARIABLES}
        . ${INST_VARIABLES}
    fi
    if [ ! -z "${WIZARD_DATA_DIRECTORY}" ]; then
         export PAPERLESS_DBDIR="${WIZARD_DATA_DIRECTORY}/data/database"
         export PAPERLESS_MEDIADIR="${WIZARD_DATA_DIRECTORY}/data/media"
         export PAPERLESS_CONSUMPTION_DIR"${WIZARD_DATA_DIRECTORY}/consume"
         export PAPERLESS_IMPORT_DIR="${WIZARD_DATA_DIRECTORY}/import"
         export PAPERLESS_EXPORT_DIR="${WIZARD_DATA_DIRECTORY}/export"
    fi
    if [ ! -z "${WIZARD_SECRET_KEY}" ]; then
        export PAPERLESS_SECRET_KEY="${WIZARD_SECRET_KEY}"
    fi
}


service_postinst () {
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1
    
    echo "Init variables" >> ${INST_LOG}
    init_variables
    
    echo "Create directories" >> ${INST_LOG}
    #Create directories
    if [ ! -d ${PAPERLESS_DBDIR} ]; then
        mkdir -p ${PAPERLESS_DBDIR}
        chown ${EFF_USER}:nobody ${PAPERLESS_DBDIR}
        chmod 
        chmod 
    fi
    if [ ! -d ${PAPERLESS_MEDIADIR} ]; then
        mkdir -p ${PAPERLESS_MEDIADIR}
    fi
    if [ ! -d ${PAPERLESS_CONSUMPTION_DIR} ]; then
        mkdir -p ${PAPERLESS_CONSUMPTION_DIR}
    fi
    if [ ! -d ${PAPERLESS_IMPORT_DIR} ]; then
        mkdir -p ${PAPERLESS_IMPORT_DIR}
    fi
    if [ -d ${PAPAERLESS_EXPORT_DIR} ]; then
        mkdir -p ${PAPAELESS_EXPORT_DIR}
    fi

    #Initialize database
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
    
    #Create admin user
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} shell -c "from django.contrib.auth.models import User; User.objects.create_superuser(\"${wizard_username}\", 'admin@example.com', \"${wizard_password}\")" >> ${INST_LOG}
}

service_prestart () {
    init_variables

    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} document_consumer >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${WORKER_PID_FILE}"

    if kill -0 $(cat "${PID_FILE}") > /dev/null 2>&1; then
        return
    fi
    rm -f "${PID_FILE}" > /dev/null
    return 1
}

service_poststop ()
{
    if [ -n "${WORKER_PID_FILE}" -a -r "${WORKER_PID_FILE}" ]; then
        PID=$(cat "${PID_FILE}")
        kill -TERM $PID >> ${LOG_FILE} 2>&1
        if [ -f "${PID_FILE}" ]; then
            rm -f "${PID_FILE}" > /dev/null
        fi
    fi
}
