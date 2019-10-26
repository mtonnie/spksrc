PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

MANAGE_PY="${SYNOPKG_PKGDEST}/share/paperless/manage.py"

WORKER_PID_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}_worker.pid"

GROUP="sc-paperless"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/gunicorn paperless.wsgi --bind 0.0.0.0:8880 --log-file ${LOG_FILE} --pid ${PID_FILE} --workers=1 --chdir=${SYNOPKG_PKGDEST}/share/paperless --daemon"

service_postinst ()
{
    echo -n "Storing installer variables to ${INST_VARIABLES} ... " >> ${INST_LOG}
    echo "SECRET_KEY=${wizard_secret_key}" >> ${INST_VARIABLES}
    LANGS=$(printenv | grep "^wizard_ocr_lang_.*=true$" | sed -n -e 's/=.*$//p')
    for LANG in $LANGS
    do
        if [ "${!LANG}" == "true" ]; then
            if [ -z "$OCR_LANGUAGE" ]; then
                OCR_LANGUAGE="${LANG:16}"
            else
                OCR_LANGUAGE="${OCR_LANGUAGE} ${LANG:16}"
            fi
        fi
    done
    echo "OCR_LANGUAGE=\"${OCR_LANGUAGE}\"" >> ${INST_VARIABLES}
    HOSTS=$(printenv | grep "^wizard_network_host[0-9]\+\=.*$" | sed -n -e 's/^.*=//p')
    for HOST in $HOSTS
    do
        if [ ! -z "$HOST" ]; then
            if [ -z "$ALLOWED_HOSTS" ]; then
                ALLOWED_HOSTS="$HOST"
            else
                ALLOWED_HOSTS="$ALLOWED_HOSTS $HOST"
            fi
        fi
    done
    echo "ALLOWED_HOSTS=\"${ALLOWED_HOSTS}\"" >> ${INST_VARIABLES}
    if [ ! -z "${wizard_email_host}" ]; then
        echo "EMAIL_HOST=${wizard_email_host}" >> ${INST_VARIABLES}
        if [ ! -z "${wizard_email_port}" ]; then
            echo "EMAIL_PORT=${wizard_email_port}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_email_username}" ]; then
            echo "EMAIL_USER=${wizard_email_username}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_email_password}" ]; then
            echo "EMAIL_PASSWORD=${wizard_email_password}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_email_inbox}" ]; then
            echo "EMAIL_INBOX=${wizard_email_inbox}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_email_secret}" ]; then
            echo "EMAIL_SECRET=${wizard_email_secret}" >> ${INST_VARIABLES}
        fi
    fi
    echo "done" >> ${INST_LOG}

    # Create a Python virtualenv
    echo "Creating virtual environment ... " >> ${INST_LOG}
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}
    if [ -d "${SYNOPKG_PKGDEST}/env" ]; then
        echo "Installed python $(${SYNOPKG_PKGDEST}/env/bin/python3 --version | cut -d' ' -f2) with the following packages:" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/pip freeze >> ${INST_LOG}
    else
        echo "Creation of virtual environment failed!" >> ${INST_LOG}
        exit 1
    fi

    # Install the wheels
    echo "Installing additional python packages" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    export PAPERLESS_DBDIR="${SHARE_PATH}/data/database"
    export PAPERLESS_MEDIADIR="${SHARE_PATH}/data/media"
    export PAPERLESS_CONSUMPTION_DIR="${SHARE_PATH}/consume"
    export PAPERLESS_EXPORT_DIR="${SHARE_PATH}/export"
    export PAPERLESS_IMPORT_DIR="${SHARE_PATH}/import"
    export PAPERLESS_STATICDIR="${SYNOPKG_PKGDEST}/var/static"

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
    echo "Processing directory ${PAPERLESS_DBDIR}" >> ${INST_LOG}
    if [ ! -d "${PAPERLESS_DBDIR}" ]; then
        mkdir -p "${PAPERLESS_DBDIR}"
        synoacltool -set-owner "${PAPERLESS_DBDIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERLESS_MEDIADIR}" >> ${INST_LOG}
    if [ ! -d "${PAPERLESS_MEDIADIR}" ]; then
        mkdir -p "${PAPERLESS_MEDIADIR}"
        synoacltool -set-owner "${PAPERLESS_MEDIADIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    synoacltool -set-owner "${SHARE_PATH}/data" user "${EFF_USER}" >> ${INST_LOG}
    echo "Processing directory ${PAPERLESS_CONSUMPTION_DIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERLESS_CONSUMPTION_DIR} ]; then
        mkdir -p ${PAPERLESS_CONSUMPTION_DIR}
        synoacltool -add "${PAPERLESS_CONSUMPTION_DIR}" "${G_ENTRY}" >> ${INST_LOG}
        synoacltool -set-owner "${PAPERLESS_CONSUMPTION_DIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERLESS_IMPORT_DIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERLESS_IMPORT_DIR} ]; then
        mkdir -p ${PAPERLESS_IMPORT_DIR}
        synoacltool -add "${PAPERLESS_IMPORT_DIR}" "${G_ENTRY}" >> ${INST_LOG}
        synoacltool -set-owner ${PAPERLESS_IMPORT_DIR} user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERLESS_STATICDIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERLESS_STATICDIR} ]; then
        mkdir -p ${PAPERLESS_STATICDIR}
    fi
    echo "Processing directory ${PAPERLESS_EXPORT_DIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERLESS_EXPORT_DIR} ]; then
        mkdir -p ${PAPERLESS_EXPORT_DIR}
        synoacltool -add "${PAPERLESS_EXPORT_DIR}" "${G_ENTRY}" >> ${INST_LOG}
        synoacltool -set-owner "${PAPERLESS_EXPORT_DIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    if [ ! -r "${PAPERLESS_DBDIR}/db.sqlite3" ]; then
        #Initialize database
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
        #Create admin user
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} shell -c "from django.contrib.auth.models import User; User.objects.create_superuser(\"${wizard_admin_username}\", \"${wizard_admin_email}\", \"${wizard_admin_password}\")" >> ${INST_LOG}
    else
        echo "SQLite database file ${PAPAERLESS_DBDIR}/db.sqlite3 already exists, skipping migration and super user creation" >> ${INST_LOG}
    fi
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} collectstatic >> ${INST_LOG}
}

service_prestart ()
{
    if [ -r "${INST_VARIABLES}" ]; then
        . "${INST_VARIABLES}"
        export PAPERLESS_DBDIR="${SHARE_PATH}/data/database"
        export PAPERLESS_MEDIADIR="${SHARE_PATH}/data/media"
        export PAPERLESS_CONSUMPTION_DIR="${SHARE_PATH}/consume"
        export PAPERLESS_EXPORT_DIR="${SHARE_PATH}/export"
        export PAPERLESS_IMPORT_DIR="${SHARE_PATH}/import"
        export PAPERLESS_STATICDIR="${SYNOPKG_PKGDEST}/var/static"
        export PAPERLESS_SECRET_KEY="${SECRET_KEY}"
        export PAPERLESS_OCR_LANGUAGE="${OCR_LANGUAGE}"
        export PAPERLESS_ALLOWD_HOSTS="${ALLOWED_HOSTS}"
        echo "${OCR_LANGUAGE}" >> ${LOG_FILE}
    fi
    export PAPERLESS_DEBUG=false
    export PAPERLESS_CONVERT_BIN="/var/packages/imagemagick/target/bin/convert"
    export PAPERLESS_GS_BINARY="/var/packages/paperless/target/bin/gs"
    export PAPERLESS_OPTIPNG_BINARY="/var/packages/paperless/target/bin/optipng"
    export PAPERLESS_UNPAPER_BINARY="/var/packages/paperless/target/bin/unpaper"
    SYNO_TZ=$(cat /etc/synoinfo.conf | grep timezone | cut -f2 -d'"')
    export PAPERLESS_TIME_ZONE=$(cat /usr/share/zoneinfo/zone.tab | grep "${SYNO_TZ}" | cut -f3)

    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} document_consumer >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${WORKER_PID_FILE}"

    if kill -0 $(cat "${WORKER_PID_FILE}") > /dev/null 2>&1; then
        return
    fi
    rm -f "${WORKER_PID_FILE}" > /dev/null
    return 1
}

service_poststop ()
{
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
    if [ -r "${INST_VARIABLES}" ]; then
        . "${INST_VARIABLES}"
        export PAPERLESS_DBDIR="${SHARE_PATH}/data/database"
        export PAPERLESS_MEDIADIR="${SHARE_PATH}/data/media"
        export PAPERLESS_CONSUMPTION_DIR="${SHARE_PATH}/consume"
        export PAPERLESS_EXPORT_DIR="${SHARE_PATH}/export"
        export PAPERLESS_IMPORT_DIR="${SHARE_PATH}/export"

        OWNER = $(synoacltool -get "${PAPERLESS_DBDIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
        OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
        OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
        if [ "${OWNER_NAME}" -ne "root" ]; then
            synoacltool -set-owner "${PAPERLESS_DBDIR}" user root >> ${INST_LOG}
        fi
        OWNER = $(synoacltool -get "${PAPERLESS_MEDIADIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
        OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
        OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
        if [ "${OWNER_NAME}" -ne "root" ]; then
            synoacltool -set-owner "${PAPERLESS_MEDIADIR}" user root >> ${INST_LOG}
        fi
        OWNER = $(synoacltool -get "${PAPERLESS_CONSUMPTION_DIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
        OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
        OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
        if [ "${OWNER_NAME}" -ne "root" ]; then
            synoacltool -set-owner "${PAPERLESS_CONSUMPTION_DIR}" user root >> ${INST_LOG}
        fi
        OWNER = $(synoacltool -get "${PAPERLESS_EXPORT_DIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
        OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
        OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
        if [ "${OWNER_NAME}" -ne "root" ]; then
            synoacltool -set-owner "${PAPERLESS_EXPORT_DIR}" user root >> ${INST_LOG}
        fi
        OWNER = $(synoacltool -get "${PAPERLESS_IMPORT_DIR}" | grep Owner | sed 's/Owner: //g' | sed 's/[][]//g' | sed 's/(/ /g' | sed 's/)//g')
        OWNER_NAME = $(echo "${OWNER}" | cut -d' ' -f1)
        OWNER_TYPE = $(echo "${OWNER}" | cut -d' ' -f2)
        if [ "${OWNER_NAME}" -ne "root" ]; then
            synoacltool -set-owner "${PAPERLESS_IMPORT_DIR}" user root >> ${INST_LOG}
        fi
    fi
}
