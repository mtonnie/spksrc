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

WIZARD_HOST1=$(hostname)
IFACES="$(ifconfig | grep -e '^[lo|eth]' | cut -d' ' -f1)"
for IFACE in $IFACES
do
    IP="$( ifconfig ${IFACE} | grep 'inet addr' | cut -d':' -f2 | cut -d' ' -f1)"
    if [ "${IF}" -eq "lo" ]; then
        DATA="[\"local (${IFACE}) - $IP\",\"${IP}\"]"
    else
        DATA="[\"ethernet (${IFACE}) - $IP\",\"${IP}\"]"
    fi
    if [ -z "$DATA_NETWORK_BIND" ]; then
        DATA_NETWORK_BIND="${DATA}"
    else
        DATA_NETWORK_BIND="${DATA_NETWORK_BIND},\n${DATA}"
    fi
    if [ -z "$WIZARD_HOST1" ]; then
        WIZARD_HOST1="$IP"
    else
        if [ -z "$WIZARD_HOST2" ]; then
            WIZARD_HOST2="$IP"
        else
            if [ -z "$WIZARD_HOST3" ]; then
                WIZARD_HOST3="$IP"
            else
                if [ -z "$WIZARD_HOST4" ]; then
                    WIZARD_HOST4="$IP"
                else
                    if [ -z "$WIZARD_HOST5" ]; then
                        WIZARD_HOST5="$IP"
                    fi
                fi
            fi
        fi
    fi
done
DATA="[\"all interfaces - 0.0.0.0\",\"0.0.0.0\"]"
if [ -z "$DATA_NETWORK_BIND" ]; then
    DATA_NETWORK_BIND="${DATA}"
else
    DATA_NETWORK_BIND="${DATA_NETWORK_BIND},\n${DATA}"
fi
export DATA_NETWORK_BIND="${DATA_NETWORK_BIND}"

printenv > /tmp/paperless.env

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[
    {
        "step_title": "Storage settings",
        "items": [{
           "type": "combobox",
           "subitems": [{
               "key": "wizard_storage_kind",
               "displayField": "name",
               "valueField": "value",
               "forceSelection": true,
               "editable": false,
               "mode": "local",
               "store": {
                   "xtype": "arraystore",
                   "fields": ["name", "value"],
                   "data": [
                       ["New shared folder","new"],
                       ["Existing shared folder","existing"]
                   ]
               },
               "validator": {
                   "fn": "{
                       var d=document;
                       var cmp_vol=Ext.getCmp(document.querySelector('input[name=wizard_storage_volume]').parentElement.querySelector('input[role=combobox]').id);
                       var cmp_fld=Ext.getCmp(document.querySelector('input[name=wizard_storage_folder]').parentElement.querySelector('input[role=combobox]').id);
                       var cmp_nam=Ext.getCmp(document.querySelector('input[name=wizard_storage_name]').id);
                       var cmp_des=Ext.getCmp(document.querySelector('input[name=wizard_storage_description]').id)
                       switch (d.querySelector('input[name=wizard_storage_kind]').value) {
                           case 'new':
                               cmp_vol.show();
                               cmp_nam.show();
                               cmp_des.show();
                               cmp_fld.hide();
                               d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_volume]').value+'/'+d.querySelector('input[name=wizard_storage_name]').value;
                               break;
                           case 'existing':
                               cmp_fld.show();
                               cmp_vol.hide();
                               cmp_nam.hide();
                               cmp_des.hide();
                               d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_folder]').value;
                               break;
                           }
                       return true;
                   }"
               }
           }, {
               "key": "wizard_storage_volume",
               "desc": "Volume",
               "displayField": "display_name",
               "valueField": "volume_path",
               "forceSelection": true,
               "editable": false,
               "hidden": false,
               "mode": "remote",
               "api_store": {
                   "api": "SYNO.Core.Storage.Volume",
                   "method": "list",
                   "version": 1,
                   "baseParams": {
                       "limit": 0,
                       "offset": 0,
                       "location": "internal"
                   },
                   "root": "volumes",
                   "idProperty": "volume_path",
                   "fields": ["display_name", "volume_path"]
               },
               "validator": {
                    "fn": "{
                        debugger;
                        var d=document;
                        switch (d.querySelector('input[name=wizard_storage_kind]').value) {
                            case 'new':
                                d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_volume]').value+'/'+d.querySelector('input[name=wizard_storage_name]').value;
                                break;
                            case 'existing':
                                return true;
                                break;
                        }
                        if (arguments[0]) {
                            return true;
                        } else {
                            return 'Please choose an item!';
                        }
                    }"
                }
           }, {
               "key": "wizard_storage_folder",
               "desc": "Shared folder",
               "displayField": "name",
               "valueField": "additional.real_path",
               "forceSelection": true,
               "editable": false,
               "hidden": false,
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
                    "fn": "{
                        debugger;
                        var d=document;
                        switch (d.querySelector('input[name=wizard_storage_kind]').value) {
                            case 'new':
                                return true;
                                break;
                            case 'existing':
                                d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_folder]').value;
                                break;
                        }
                        if (arguments[0]) {
                            return true;
                        } else {
                            return 'Please choose an item!';
                        }
                    }"
                }

           }]
        }, {
            "type": "textfield",
            "subitems": [
            {
                "key": "wizard_storage_name",
                "desc": "Name",
                "defaultValue": "paperless",
                "hidden": false,
                 "validator": {
                    "fn": "{
                        debugger;
                        var d=document;
                        switch (d.querySelector('input[name=wizard_storage_kind]').value) {
                            case 'new':
                                d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_volume]').value+'/'+d.querySelector$
                                break;
                            case 'existing':
                                return true;
                                break;
                            default:
                                arguments[2].items.items[0].setValue('Please choose storage ...');
                                arguments[2].items.items[1].hide();
                                arguments[2].items.items[2].hide();
                                arguments[2].items.items[3].hide();
                                arguments[2].items.items[4].hide();
                                break;
                        }
                        if (arguments[0]) {
                            return true;
                        } else {
                            return 'Please input an shared folder name!';
                        }
                    }"
                }

            }, {
                "key": "wizard_storage_description",
                "desc": "Description",
                "defaultValue": "Paperless database & file storage",
                "hidden": false
            }, {
                "key": "wizard_storage_path",
                "desc": "Path",
                "disabled": true,
                "hidden": true
            }]
        }]
    }, {
        "step_title": "Network settings",
        "items": [{
            "type": "combobox",
            "subitems": [{
                "key": "wizard_network_bind",
                "desc": "Interface",
                "displayField": "name",
                "valueField": "value",
                "forceSelection": true,
                "editable": false,
                "mode": "local",
                "store": {
                    "xtype": "arraystore",
                    "fields": ["name", "value"],
                    "data": [$(echo -e "${DATA_NETWORK_BIND}")]
                }
            }]

        }, {
            "type": "textfield",
            "subitems": [
            {
                "key": "wizard_network_host1",
                "desc": "Host 1",
                "defaultValue": "${WIZARD_HOST1}"
            }, {
                "key": "wizard_network_host2",
                "desc": "Host 2",
                "defaultValue": "${WIZARD_HOST2}"
            }, {
                "key": "wizard_network_host3",
                "desc": "Host 3",
                "defaultValue": "${WIZARD_HOST3}"
            }, {
                "key": "wizard_network_host4",
                "desc": "Host 4",
                "defaultValue": "${WIZARD_HOST4}"
            }, {
                "key": "wizard_network_host5",
                "desc": "Host 5",
                "defaultValue": "${WIZARD_HOST5}"
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
