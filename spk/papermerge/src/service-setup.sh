PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3

PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"
PAPERMERGE_CONF="${INST_ETC}/papermerge.conf.py"
MANAGE_PY="${SYNOPKG_PKGDEST}/share/papermerge/manage.py"
WORKER_PID_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}_worker.pid"

GROUP="sc-papermerge"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/gunicorn config.wsgi --bind ${GUNICORN_NETWORK_BIND}:8880 --log-file ${LOG_FILE} --pid ${PID_FILE} --workers=1 --chdir=${SYNOPKG_PKGDEST}/share/papermerge --daemon"

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

createISO639_2_dict()
{
    declare -A ISO639_2
    ISO639_2["afr"]="Afrikaans"
    ISO639_2["amh"]="Amharic"
    ISO639_2["ara"]="Arabic"
    ISO639_2["asm"]="Assamese"
    ISO639_2["aze"]="Azerbaijani"
    ISO639_2["aze_cyrl"]="Azerbaijani-Cyrilic"
    ISO639_2["bel"]="Belarusian"
    ISO639_2["ben"]="Bengali"
    ISO639_2["bod"]="Tibetan"
    ISO639_2["bos"]="Bosnian"
    ISO639_2["bre"]="Breton"
    ISO639_2["bul"]="Bulgarian"
    ISO639_2["cat"]="Catalan / Valencian"
    ISO639_2["ceb"]="Cebuano"
    ISO639_2["ces"]="Czech"
    ISO639_2["chi_sim"]="Chinese simplified"
    ISO639_2["chi_tra"]="Chinese traditional"
    ISO639_2["chr"]="Cherokee"
    ISO639_2["cym"]="Welsh"
    ISO639_2["dan"]="Danish"
    ISO639_2["deu"]="German"
    ISO639_2["dzo"]="Dzongkha"
    ISO639_2["ell"]="Greek"
    ISO639_2["eng"]="English"
    ISO639_2["enm"]="English (1100-1500)"
    ISO639_2["equ"]="Math"
    ISO639_2["est"]="Estonian"
    ISO639_2["eus"]="Basque"
    ISO639_2["fas"]="Persian"
    ISO639_2["fin"]="Finnish"
    ISO639_2["fra"]="French"
    ISO639_2["frk"]="Frankish"
    ISO639_2["frm"]="French (1400-1600)"
    ISO639_2["gle"]="Irish"
    ISO639_2["glg"]="Galician"
    ISO639_2["grc"]="Greek (ancient)"
    ISO639_2["guj"]="Gujarati"
    ISO639_2["hat"]="Haitian / HaitianCreole"
    ISO639_2["heb"]="Hebrew"
    ISO639_2["hin"]="Hindi"
    ISO639_2["hrv"]="Croatian"
    ISO639_2["hun"]="Hungarian"
    ISO639_2["iku"]="Inuktitut"
    ISO639_2["ind"]="Indonesian"
    ISO639_2["isl"]="Icelandic"
    ISO639_2["ita"]="Italian"
    ISO639_2["ita_old"]="Italian (ancient)"
    ISO639_2["jav"]="Javanese"
    ISO639_2["jpn"]="Japanese"
    ISO639_2["kan"]="Kannada"
    ISO639_2["kat"]="Georgian"
    ISO639_2["kat_old"]="Georgian (ancient)"
    ISO639_2["kaz"]="Kazakh"
    ISO639_2["khm"]="CentralKhmer"
    ISO639_2["kir"]="Kirghiz / Kyrgyz"
    ISO639_2["kmr"]="Kurdish Kurmanji"
    ISO639_2["kor"]="Korean"
    ISO639_2["kor_vert"]="Korean (vertical)"
    ISO639_2["kur"]="Kurdish"
    ISO639_2["lao"]="Lao"
    ISO639_2["lat"]="Latin"
    ISO639_2["lav"]="Latvian"
    ISO639_2["lit"]="Lithuanian"
    ISO639_2["ltz"]="Luxembourgish"
    ISO639_2["mal"]="Malayalam"
    ISO639_2["mar"]="Marathi"
    ISO639_2["mkd"]="Macedonian"
    ISO639_2["mlt"]="Maltese"
    ISO639_2["mon"]="Mongolian"
    ISO639_2["mri"]="Maori"
    ISO639_2["msa"]="Malay"
    ISO639_2["mya"]="Burmese"
    ISO639_2["nep"]="Nepali"
    ISO639_2["nld"]="Dutch / Flemish"
    ISO639_2["nor"]="Norwegian"
    ISO639_2["oci"]="Occitan1500-"
    ISO639_2["ori"]="Oriya"
    ISO639_2["osd"]="Orientation and script detection module"
    ISO639_2["pan"]="Panjabi / Punjabi"
    ISO639_2["pol"]="Polish"
    ISO639_2["por"]="Portuguese"
    ISO639_2["pus"]="Pushto / Pashto"
    ISO639_2["que"]="Quechua"
    ISO639_2["ron"]="Romanian / Moldavian / Moldovan"
    ISO639_2["rus"]="Russian"
    ISO639_2["san"]="Sanskrit"
    ISO639_2["sin"]="Sinhala / Sinhalese"
    ISO639_2["slk"]="Slovak"
    ISO639_2["slv"]="Slovenian"
    ISO639_2["snd"]="Sindhi"
    ISO639_2["spa"]="Spanish / Castilian"
    ISO639_2["spa_old"]="Spanish / Castilian (ancient)"
    ISO639_2["sqi"]="Albanian"
    ISO639_2["srp"]="Serbian"
    ISO639_2["srp_latn"]="Serbian-Latin"
    ISO639_2["sun"]="Sundanese"
    ISO639_2["swa"]="Swahili"
    ISO639_2["swe"]="Swedish"
    ISO639_2["syr"]="Syriac"
    ISO639_2["tam"]="Tamil"
    ISO639_2["tat"]="Tatar"
    ISO639_2["tel"]="Telugu"
    ISO639_2["tgk"]="Tajik"
    ISO639_2["tgl"]="Tagalog"
    ISO639_2["tha"]="Thai"
    ISO639_2["tir"]="Tigrinya"
    ISO639_2["ton"]="Tonga"
    ISO639_2["tur"]="Turkish"
    ISO639_2["uig"]="Uighur / Uyghur"
    ISO639_2["ukr"]="Ukrainian"
    ISO639_2["urd"]="Urdu"
    ISO639_2["uzb"]="Uzbek"
    ISO639_2["uzb_cyrl"]="Uzbek-Cyrilic"
    ISO639_2["vie"]="Vietnamese"
    ISO639_2["yid"]="Yiddish"
    ISO639_2["yor"]="Yoruba"
    
    RET=""

    for VAL in $1
    do
        if [ "$VAL" != "osd" ]; then
            if [ "$VAL" != "equ" ]; then
                if [ ! -z "${ISO639_2[$VAL]}" ]; then
                    if [ ! -z "${RET}" ]; then
                    	RET="${RET},\n\t\"${VAL}\": \"${ISO639_2[$VAL]}\""
                    else
                        RET="\t\"${VAL}\": \"${ISO639_2[$VAL]}\""
                    fi
                fi
            fi
        fi
    done
    RET="{\n"$RET"\n}"
    echo "$RET"
}

create_config()
{
    # Create/Update papermerge config file (papermerge.conf.py)
    if [ -r "${INST_VARIABLES}" ]; then
        . "${INST_VARIABLES}"
    fi

    echo "DBDIR = \"${PAPERMERGE_DBDIR}\"" > ${PAPERMERGE_CONF}
    echo "MEDIA_DIR = \"${PAPERMERGE_MEDIADIR}\"" >> ${PAPERMERGE_CONF}
    echo "STATIC_DIR = \"${PAPERMERGE_STATICDIR}\"" >> ${PAPERMERGE_CONF}
    echo "IMPORTER_DIR = \"${PAPERMERGE_IMPORTERDIR}\"" >> ${PAPERMERGE_CONF}
    echo "TASK_QUEUE_DIR = \"${PAPERMERGE_TASKQUEUEDIR}\"" >> ${PAPERMERGE_CONF}
    echo "BINARY_FILE = \"${SYNOPKG_PKGDEST}/bin/file\"" >> ${PAPERMERGE_CONF}
    echo "BINARY_PDFTOPPM = \"${SYNOPKG_PKGDEST}/bin/pdftoppm\"" >> ${PAPERMERGE_CONF}
    echo "BINARY_PDFINFO = \"${SYNOPKG_PKGDEST}/bin/pdfinfo\"" >> ${PAPERMERGE_CONF}
    echo "BINARY_OCR = \"/usr/local/bin/tesseract\"" >> ${PAPERMERGE_CONF}
    echo "BINARY_PDFTK = \"${SYNOPKG_PKGDEST}/bin/pdftk.sh\"" >> ${PAPERMERGE_CONF}

    echo "OCR_DEFAULT_LANGUAGE = \"$OCR_DEFAULTLANGUAGES\"" >> ${PAPERMERGE_CONF}
    
    LANGS="$(/usr/local/bin/tesseract --list-langs | sed -n '1!p')"
    OCR_LANGUAGES=$(createISO639_2_dict "$LANGS")
    echo -n "OCR_LANGUAGES = " >> ${PAPERMERGE_CONF}
    echo -e $OCR_LANGUAGES >> ${PAPERMERGE_CONF}

    echo -n "ALLOWED_HOSTS = [" >> ${PAPERMERGE_CONF}
    if [ "${NETWORK_HOSTS}" == "all" ]; then
        echo -e "\t\"*\"" >> ${PAPERMERGE_CONF}
    else
        echo "" >> ${PAPERMERGE_CONF}
        if [ ! -z "${NETWORK_HOST1}" ]; then
            echo -e "\t\"$NETWORK_HOST1\"," >> ${PAPERMERGE_CONF}
        fi
        if [ ! -z "$NETWORK_HOST2" ]; then
            echo -e "\t\"$NETWORK_HOST2\"," >> ${PAPERMERGE_CONF}
        fi
        if [ ! -z "$NETWORK_HOST3" ]; then
            echo -e "\t\"$NETWORK_HOST3\"," >> ${PAPERMERGE_CONF}
        fi
        if [ ! -z "$NETWORK_HOST4" ]; then
            echo -e "\t\"$NETWORK_HOST4\"," >> ${PAPERMERGE_CONF}
        fi
        if [ ! -z "$NETWORK_HOST5" ]; then
            echo -e "\t\"$NETWORK_HOST5\"," >> ${PAPERMERGE_CONF}
        fi
    fi
    echo "]" >> ${PAPERMERGE_CONF}

    echo "SECRET_KEY = \"$SECURITY_SECRETKEY\"" >> ${PAPERMERGE_CONF}

    SYNO_TZ=$(cat /etc/synoinfo.conf | grep timezone | cut -f2 -d'"')
    echo "TIME_ZONE = \"$(cat /usr/share/zoneinfo/zone.tab | grep "${SYNO_TZ}" | cut -f3)\"" >> ${PAPERMERGE_CONF}

    echo "FILES_MIN_UNMODIFIED_DURATION = 10" >> ${PAPERMERGE_CONF}
    echo "LANGUAGE_FROM_AGENT = True" >> ${PAPERMERGE_CONF}
}

service_postinst ()
{
    echo -n "Storing installer variables to ${INST_VARIABLES} ... " >> ${INST_LOG}
    # Storage variables
    # Noting to store, SHARE_PATH has already been stored
    # Network variables
    echo "NETWORK_BIND=${wizard_network_bind}" >> ${INST_VARIABLES}
    echo "NETWORK_HOSTS=${wizard_network_hosts}" >> ${INST_VARIABLES}
    if [ "${wizard_network_hosts}" == "specified" ]; then
        if [ ! -z "${wizard_network_host1}" ]; then
            echo "NETWORK_HOST1=${wizard_network_host1}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_network_host2}" ]; then
            echo "NETWORK_HOST2=${wizard_network_host2}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_network_host3}" ]; then
            echo "NETWORK_HOST3=${wizard_network_host3}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_network_host4}" ]; then
            echo "NETWORK_HOST4=${wizard_network_host4}" >> ${INST_VARIABLES}
        fi
        if [ ! -z "${wizard_network_host5}" ]; then
            echo "NETWORK_HOST5=${wizard_network_host5}" >> ${INST_VARIABLES}
        fi
    fi
    # Security
    echo "SECURITY_SECRETKEY=${wizard_security_secretkey}" >> ${INST_VARIABLES}
    # Import
    if [ ! -z "${wizard_import_mailhost}" ]; then
        echo "IMPORT_MAILHOST=${wizard_import_mailhost}" >> ${INST_VARIABLES}
        if [ ! -z "${wizard_import_mailhost}" ]; then 
            echo "IMPORT_MAILPORT=${wizard_import_mailport}" >> ${INST_VARIABLES}
        fi
        echo "IMPORT_MAILUSER=${wizard_import_mailuser}" >> ${INST_VARIABLES}
        echo "IMPORT_MAILPASSWORD=${wizard_import_mailpassword}" >> ${INST_VARIABLES}
        echo "IMPORT_MAILINBOX=${wizard_import_mailinbox}" >> ${INST_VARIABLES}
        if [ ! -z "${wizard_import_mailsecret}" ]; then 
            echo "IMPORT_MAILSECRET=${wizard_import_mailsecret}" >> ${INST_VARIABLES}
        fi
    fi
    # OCR
        echo "OCR_DEFAULTLANGUAGE=${wizard_ocr_defaultlanguage}" >> ${INST_VARIABLES}
    # Example
    # Nothing to store

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
    synoacltool -add "${SHARE_PATH}" "group:${GROUP}:allow:r-x---a-R----:---n" >> ${INST_LOG}
    G_ENTRY=$(echo "${G_ENTRY}" | sed 's/C/-/g')
    # Create directories
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
        echo "${G_ENTRY}" >> ${INST_LOG}
        synoacltool -add "${PAPERMERGE_IMPORTERDIR}" "${G_ENTRY}" >> ${INST_LOG}
        synoacltool -set-owner "${PAPERMERGE_IMPORTERDIR}" user "${EFF_USER}" >> ${INST_LOG}
    fi
    echo "Processing directory ${PAPERMERGE_STATICDIR}" >> ${INST_LOG}
    if [ ! -d ${PAPERMERGE_STATICDIR} ]; then
        mkdir -p ${PAPERMERGE_STATICDIR}
    fi



    # Create papermerge.conf.py
    if [ ! -e "${PAPERMERGE_CONF}" ]; then
        touch "${PAPERMERGE_CONF}"
    fi
    if [ -e "${PAPERMERGE_CONF}" ]; then
        chmod go-rwx ${PAPERMERGE_CONF}
        chmod u-x ${PAPERMERGE_CONF}
        chown ${EFF_USER} ${PAPERMERGE_CONF}
    fi
    create_config
    
    # Export required environment variables 
    export DJANGO_SETTINGS_MODULE=config.settings.synology
    export PAPERMERGE_CONFIG="${PAPERMERGE_CONF}"
    export GUNICORN_NETWORK_BIND="${NETWORK_BIND}"

    # Initialize database & create admin user
    if [ ! -r "${PAPERMERGE_DBDIR}/db.sqlite3" ]; then
        echo "Create SQLite database file" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
        echo "Creating superuser (${wizard_security_adminuser})" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} shell -c "from django.contrib.auth import get_user_model; UserModel = get_user_model(); user = UserModel.objects.create_user(\"${wizard_security_adminuser}\", email=\"${wizard_security_adminmail}\", password=\"${wizard_security_adminpassword}\"); user.is_superuser=True; user.is_staff=True; user.save();" >> ${INST_LOG}
    else
        echo "SQLite database file already exists, skipping super user creation" >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} makemigrations >> ${INST_LOG}
        ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} migrate >> ${INST_LOG}
    fi
    
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} collectstatic --no-input >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/python3 ${MANAGE_PY} check >> ${INST_LOG}

    # Copy example data to import folder
    if [ ! -z "${wizard_example_ger}" ]; then
        cp --backup=numbered ${SYNOPKG_PKGDEST}/share/papermerge/example_data/deutsch/page_management/*/*.pdf ${PAPERMERGE_IMPORTERDIR}
    fi
    if [ ! -z "${wizard_example_eng}" ]; then
        cp --backup=numbered ${SYNOPKG_PKGDEST}/share/papermerge/example_data/english/page_management/*/*.pdf ${PAPERMERGE_IMPORTERDIR}
    fi 
    if [ ! -z "${wizard_example_spa}" ]; then
        cp --backup=numbered ${SYNOPKG_PKGDEST}/share/papermerge/example_data/spanish/*.pdf ${PAPERMERGE_IMPORTERDIR}
    fi 
}


service_prestart()
{
    if [ -r "${INST_VARIABLES}" ]; then
        . "${INST_VARIABLES}"
    fi

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