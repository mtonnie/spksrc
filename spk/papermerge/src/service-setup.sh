PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3

PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"
PAPERMERGE_CONF="${INST_ETC}/papermerge.conf.py"

MANAGE_PY="${SYNOPKG_PKGDEST}/share/papermerge/manage.py"

WORKER_PID_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}_worker.pid"
#CRONTAB_FILE="/etc/cron.d/papermerge"

GROUP="sc-papermerge"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/gunicorn config.wsgi --bind 0.0.0.0:8880 --log-file ${LOG_FILE} --pid ${PID_FILE} --workers=1 --chdir=${SYNOPKG_PKGDEST}/share/papermerge --daemon"


if [ "$wizard_storage_kind" == "new" ]; then
    SHARE_PATH="${wizard_storage_volume}/${wizard_storage_name}"
    export SHARE_PATH="${wizard_storage_volume}/${wizard_storage_name}"
fi
if [ "$wizard_storage_kind" == "existing" ]; then
    SHARE_PATH="${wizard_storage_folder}"
    export SHARE_PATH="${wizard_storage_folder}"
fi

PAPERMERGE_DBDIR="${SHARE_PATH}/data/database"
PAPERMERGE_MEDIADIR="${SHARE_PATH}/data/media"
PAPERMERGE_STATICDIR="${SYNOPKG_PKGDEST}/var/static"

PAPERMERGE_IMPORTERDIR="${SHARE_PATH}/import"

PAPERMERGE_TASKQUEUEDIR="${SHARE_PATH}/data/queue"

printenv > /tmp/papermerge_service-setup_$(od -An -N2 -i /dev/random | tr -d '[:space:]').env

service_postinst ()
{
    # For script debugging only
    printenv > /tmp/papermerge_install.env
    # Deactivate on release!
    
    # Create a Python virtualenv
    echo "Creating virtual environment ... " >> ${INST_LOG}
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}
    if [ -d "${SYNOPKG_PKGDEST}/env" ]; then
        echo "Installed python $(${SYNOPKG_PKGDEST}/env/bin/python3 --version | cut -d' ' -f2) with the following packages:" >> ${INST_LOG}
        ${PIP} freeze >> ${INST_LOG} 2>&1
        echo "" >> ${INST_LOG}
    else
        echo "Creation of virtual environment failed!" >> ${INST_LOG}
        exit 1
    fi

    # Install the wheels
    echo "Installing additional python packages" >> ${INST_LOG}
    ${PIP} install --no-deps --no-index --upgrade --force-reinstall --find-links ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1
    ${PIP} freeze >> ${INST_LOG} 2>&1
    echo "" >> ${INST_LOG}

    # Create directories and set permissions
    G_INDEX=$(synoacltool -get ${SHARE_PATH} | grep "group:${GROUP}" | cut -f2 -d' ' | sed 's/[][]//g')
    G_ENTRY=$(synoacltool -get ${SHARE_PATH} | grep "group:${GROUP}" | cut -f3 -d' ')
    U_INDEX=$(synoacltool -get ${SHARE_PATH} | grep "user:${EFF_USER}" | cut -f2 -d' ' | sed 's/[][]//g')
    U_ENTRY=$(synoacltool -get ${SHARE_PATH} | grep "user:${EFF_USER}" | cut -f3 -d' ')
    echo "Group index:${G_INDEX} entry:${G_ENTRY}" >> ${INST_LOG}
    echo "User index:${U_INDEX} entry:${U_ENTRY}" >> ${INST_LOG}

    echo "Processing directory ${SHARE_PATH}" >> ${INST_LOG}
    synoacltool -set-owner ${SHARE_PATH} user ${EFF_USER} >> ${INST_LOG}
    if [ ! -z "${G_INDEX}" ]; then
        if [ -z "${U_ENTRY}" ]; then
            synoacltool -replace "${SHARE_PATH}" "${G_INDEX}" $(echo "${G_ENTRY}" | sed 's/group:/user:/g') >> ${INST_LOG}
        else
            synoacltool -del "${SHARE_PATH}" "${G_INDEX}" >> ${INST_LOG}
        fi
    fi
    G_ENTRY=$(echo "${G_ENTRY}" | sed 's/A/-/g' | sed 's/W/-/g' | sed 's/C/-/g')
    #Create directories
    echo "Processing directory ${PAPERMERGE_DBDIR}" >> ${INST_LOG}
    if [ ! -d "${PAPERMERGE_DBDIR}" ]; then
        mkdir -p "${PAPERMERGE_DBDIR}"
        synoacltool -set-owner "${PAPERMERGE_DBDIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERMERGE_MEDIADIR}" >> ${INST_LOG}
    if [ ! -d "${PAPERMERGE_MEDIADIR}" ]; then
        mkdir -p "${PAPERMERGE_MEDIADIR}"
        synoacltool -set-owner "${PAPERMERGE_MEDIADIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERMERGE_TASKQUEUEDIR}" >> ${INST_LOG}
    if [ ! -d "${PAPERMERGE_TASKQUEUEDIR}" ]; then
        mkdir -p "${PAPERMERGE_TASKQUEUEDIR}"
        synoacltool -set-owner "${PAPERMERGE_TASKQUEUEDIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    synoacltool -set-owner "${SHARE_PATH}/data" user "${EFF_USER}" >> ${INST_LOG}
    echo "Processing directory ${PAPERMERGE_IMPORTERDIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERMERGE_IMPORTERDIR} ]; then
        mkdir -p ${PAPERMERGE_IMPORTERDIR}
        synoacltool -add "${PAPERMERGE_IMPORTERDIR}" "${G_ENTRY}" >> ${INST_LOG}
        synoacltool -set-owner "${PAPERMERGE_IMPORTERDIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERMERGE_STATICDIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERMERGE_STATICDIR} ]; then
        mkdir -p ${PAPERMERGE_STATICDIR}
    fi

    # Create papermerge config file (papermerge.conf.py)

    echo "DBDIR=\"${PAPERMERGE_DBDIR}\"" > ${PAPERMERGE_CONF}
    echo "MEDIA_DIR=\"${PAPERMERGE_DBDIR}\"" >> ${PAPERMERGE_CONF}
    echo "STATIC_DIR=\"${PAPERMERGE_STATICDIR}\"" >> ${PAPERMERGE_CONF}
    echo "IMPORTER_DIR=\"${PAPERMERGE_IMPORTERDIR}\"" >> ${PAPERMERGE_CONF}
    echo "TASK_QUEUE_DIR=\"${PAPERMERGE_TASKQUEUEDIR}\"" >> ${PAPERMERGE_CONF}

    # Export required environment variables 
    export DJANGO_SETTINGS_MODULE=config.settings.synology
    export PAPERMERGE_CONFIG="${PAPERMERGE_CONF}"

    # Initialize database & create admin user
    if [ ! -r "${PAPERMERGE_DBDIR}/db.sqlite3" ]; then
        echo "Create SQLite database file" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
        echo "Creating superuser (${wizard_admin_username} / ${wizard_admin_email})" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} shell -c "from django.contrib.auth import get_user_model; UserModel = get_user_model(); user = UserModel.objects.create_user(\"${wizard_admin_username}\", email=\"${wizard_admin_email}\", password=\"${wizard_admin_password}\"); user.is_superuser=True; user.is_staff=True; user.save();" >> ${INST_LOG}
    else
        echo "SQLite database file already exists, skipping super user creation" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
    fi
    
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} collectstatic --no-input >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} check >> ${INST_LOG}
}


service_prestart()
{
    # Export required environment variables 
    export DJANGO_SETTINGS_MODULE=config.settings.synology
    export PAPERMERGE_CONFIG="${PAPERMERGE_CONF}"

    printenv > /tmp/papermerge_prestart.env

    #Start worker
    cd ${SYNOPKG_PKGDEST}/var && ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} worker --pidfile ${WORKER_PID_FILE} >> ${LOG_FILE} 2>&1 &
    if kill -0 $(cat "${WORKER_PID_FILE}") > /dev/null 2>&1; then
        return
    fi
    rm -f "${WORKER_PID_FILE}" > /dev/null
    return 1
}


service_poststop()
{
    #Stop worker
    if [ -n "${WORKER_PID_FILE}" -a -r "${WORKER_PID_FILE}" ]; then
        PID=$(cat "${WORKER_PID_FILE}")
        kill -TERM $PID >> ${LOG_FILE} 2>&1
        if [ -f "${WORKER_PID_FILE}" ]; then
            rm -f "${WORKER_PID_FILE}" > /dev/null
        fi
    fi
}


service_preuninst ()
{
    synoacltool -set-owner "${SHARE_PATH}" user root >> ${INST_LOG}
    OWNER = $(synoacltool -get "${PAPERMERGE_DBDIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
    OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
    OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
    if [ "${OWNER_NAME}" -ne "root" ]; then
        synoacltool -set-owner "${PAPERMERGE_DBDIR}" user root >> ${INST_LOG}
    fi
    OWNER = $(synoacltool -get "${PAPERMERGE_MEDIADIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
    OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
    OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
    if [ "${OWNER_NAME}" -ne "root" ]; then
        synoacltool -set-owner "${PAPERMERGE_MEDIADIR}" user root >> ${INST_LOG}
    fi
    OWNER = $(synoacltool -get "${PAPERMERGE_IMPORTERDIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
    OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
    OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
    if [ "${OWNER_NAME}" -ne "root" ]; then
        synoacltool -set-owner "${PAPERMERGE_IMPORTERDIR}" user root >> ${INST_LOG}
    fi
    OWNER = $(synoacltool -get "${PAPERMERGE_TASKQUEUEDIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
    OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
    OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
    if [ "${OWNER_NAME}" -ne "root" ]; then
        synoacltool -set-owner "${PAPERMERGE_TASKQUEUEDIR}" user root >> ${INST_LOG}
    fi
}