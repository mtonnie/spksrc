# Setup environment
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

service_postinst () {
    echo "WIZARD_KIND=${wizard_kind}" >> ${INST_VARIABLES}
    echo "WIZARD_VERSION=${wizard_version}" >> ${INST_VARIABLES}
    LANGS=$(ls "${SYNOPKG_PKGDEST}/share/tessdata/" | grep ".*traineddata$" | sed -n -e 's/.traineddata$//p')
    echo "$LANGS" >> ${INST_lOG}
    for LANG in $LANGS
    do
        echo "$LANG" >> ${INST_lOG}
        rm -f "${SYNOPKG_PKGDEST}/share/tessdata/${LANG}"
        var="wizard_lang_${LANG}"
        if [ "${!var}" == "true" ]; then
          curl -L "https://github.com/tesseract-ocr/$wizard_kind/raw/$wizard_version/${LANG}.traineddata" -o "${SYNOPKG_PKGDEST}/share/tessdata/${LANG}.traineddata"
        fi
    done
    printenv | grep "^wizard_lang_.*=true$" | sed -n -e 's/=.*$//p' | while read -r line ; do
        if [ "${!line}" == "true" ]; then
            URL="https://github.com/tesseract-ocr/$wizard_kind/raw/$wizard_version/${line:12}.traineddata"
            curl -L "$URL" -o "${SYNOPKG_PKGDEST}/share/tessdata/${line:12}.traineddata" >> ${INST_LOG}
        fi
    done
    mkdir -p /usr/local/bin
    ln -s ${SYNOPKG_PKGDEST}/bin/tesseract /usr/local/bin/tesseract
}

service_postuninst () {
    rm -f "${SYNOPKG_PKDEST}/share/tessdata/*traineddata"
    rm -f /usr/local/bin/tesseract
}
