service_postinst () {
    printenv | grep "^wizard_lang_.*=true$" | sed -n -e 's/=.*$//p' | while read -r line ; do
        if [ "${!line}" == "true" ]; then
            URL="https://github.com/tesseract-ocr/$wizard_kind/raw/$wizard_version/${line:12}.traineddata"
            curl "$URL" -o "${SYNOPKG_PKGDEST}/share/tessdata/${line:12}.traineddata" >> ${INST_LOG}
        fi
    done
    mkdir -p /usr/local/bin
    ln -s ${SYNOPKG_PKGDEST}/bin/tesseract /usr/local/bin/tesseract
}

service_postuninst () {
    rm -f /usr/local/bin/tesseract
}
