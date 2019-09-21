#!/bin/sh

export WIZARD_SECRET_KEY="$(tr -dc 'a-zA-Z0-9@#&(-_=+)' < /dev/urandom | head -c50)"

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[
    {
        "step_title": "Configuration",
        "items": [{
            "type": "textfield",
            "subitems": [
            {
                "key": "wizard_data_directory",
                "desc": "Data directory location",
                "defaultValue": "${SYNOPKG_PKGDEST}",
                "validator": {
                    "allowBlank": false,
                    "regex": {
                        "expr": "/^\\\/volume[0-9]{1,2}\\\/[^<>: */?\"]*/",
                        "errorText": "Path should begin with /volume?/ where ? is volume number (1-99)"
                    }
                }
            }, {
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
                "key": "wizard_username",
                "desc": "Username",
                "allowvalidator": {
                    "allowBlank": false,
                    "regex": {
                        "expr": "/[a-zA-Z0-9-]+/",
                        "errorText": "Not allowed character"
                    }
                }
            }, {
                "key": "wizard_email",
                "desc": "E-Mail",
                "validator": {
                    "allowBlank": false,
                    "vtype": "email"
                }
            }]
        }, {
            "type": "password",
            "subitems": [{
                "key": "wizard_password",
                "desc": "Password",
                "validator": {
                    "allowBlank": false,
                    "minLength": 8
                }
            }]
        }]
    }, {
        "step_title": "Attention! DSM6 Permissions",
        "items": [{
            "desc": "Permissions for this package are handled by the <b>'sc-paperless'</b> group. <br>Using File Station, add this group to every folder paperless should be allowed to access.<br>Please read <a <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
        }]
    }
] EOF
exit 0
