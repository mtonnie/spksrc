#!/bin/sh

# Collect installed languages from tesseract and generate subitems for wizard
LANGS="$(/usr/local/bin/tesseract --list-langs | sed -n '1!p')"
for LANG in $LANGS
do
    SUBITEM="{\n\"key\": \"wizard_ocr_lang_${LANG}\",\n\"desc\": \"${LANG}\"\n}"
    if [ -z "$SUBITEMS_OCR_LANGS" ]; then
        SUBITEMS_OCR_LANGS="${SUBITEM}"
    else
        SUBITEMS_OCR_LANGS="${SUBITEMS_OCR_LANGS},\n${SUBITEM}"
    fi
done
export SUBITEMS_OCR_LANGS="${SUBITEMS_OCR_LANGS}"

# Generate default value for secret key
export WIZARD_SECRET_KEY="$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c50)"


cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[
    {
        "step_title": "Storage settings",
        "items": [{
           "type": "combobox",
           "subitems": [{
               "key": "wizard_shared_folder",
               "desc": "Shared folder",
               "displayField": "name",
               "valueField": "additional.real_path",
               "editable": false,
               "mode": "remote",
               "api_store": {
                  "api": "SYNO.FileStation.List",
                  "method": "list_share",
                  "version": 2,
                  "baseParams": {
                      "limit": 0,
                      "offset": 0,
                      "sort_by": "name",
                      "additional": ["real_path"]
                  },
                  "root": "shares",
                  "idProperty": "additional.real_path",
                  "fields": ["name", "additional.real_path"]
               },
               "validator": {
                   "fn": "{console.log(arguments};retrun true;"
               }
           }]
        }]
    }, {
        "step_title": "Security settings",
        "items": [{
            "type": "textfield",
            "subitems": [
            {
                "key": "wizard_secret_key",
                "desc": "Secret key",
                "defaultValue": "${WIZARD_SECRET_KEY}",
                "validator": {
                    "allowBlank": false,
                    "regex": {
                        "expr": "/^[^\"]*$/",
                        "errorText": "Please don't use double quotes!"
                    }
                }
            }, {
                "key": "wizard_admin_username",
                "desc": "Admin username",
                "allowvalidator": {
                    "allowBlank": false,
                    "regex": {
                        "expr": "/[a-zA-Z0-9-]+/",
                        "errorText": "Not allowed character"
                    }
                }
            }, {
                "key": "wizard_admin_email",
                "desc": "Admin Email",
                "validator": {
                    "allowBlank": false,
                    "vtype": "email"
                }
            }]
        }, {
            "type": "password",
            "subitems": [{
                "key": "wizard_admin_password",
                "desc": "Admin password",
                "validator": {
                    "allowBlank": false,
                    "minLength": 8
                }
            }]
        }]
    }, {
        "step_title": "OCR languages",
        "items": [{
            "type": "multiselect",
            "subitems": [$(echo -e "${SUBITEMS_OCR_LANGS}")]
        }]
    }, {
        "step_title": "Email settings",
        "items": [{
            "type": "textfield",
            "subitems": [{
                "key": "wizard_email_host",
                "desc": "Host"
           }, {
                "key": "wizard_email_port",
                "desc": "Port"
           }, {
                "key": "wizard_email_username",
                "desc": "Username"
            }]
        }, {
            "type": "password",
            "subitems": [{
                "key": "wizard_email_password",
                "desc": "password"
            }]
        }, {
            "type": "textfield",
            "subitems": [{
                "key": "wizard_email_inbox",
                "desc": "Inbox",
                "defaultValue": "INBOX"
            }, {
                "key": "wizard_email_secret",
                "desc" : "Secret"
            }]
        }]
    }, {
        "step_title": "Attention! DSM6 Permissions",
        "items": [{
            "desc": "Permissions for this package are handled by the <b>'sc-paperless'</b> group. <br>Using File Station, add this group to every folder paperless should be allowed to access.<br>Please read <a <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
        }]
    }
] EOF
cat "$SYNOPKG_TEMP_LOGFILE" > /tmp/paperless.debug
exit 0
