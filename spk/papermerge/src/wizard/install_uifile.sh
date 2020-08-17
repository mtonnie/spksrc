#!/bin/sh

# Begin translation
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
# End translation

# Collect installed languages from tesseract and generate subitems for wizard
LANGS="$(/usr/local/bin/tesseract --list-langs | sed -n '1!p')"
for LANG in $LANGS
do
    case "$LANG" in
    "equ"|"osd")
        ;;
    *)
        if [ -z "$DATA_OCR_DEFAULT" ]; then
            DATA_OCR_DEFAULT="[\"${ISO639_2[$LANG]}\",\"${LANG}\"]"
        else
            DATA_OCR_DEFAULT="${DATA_OCR_DEFAULT},\n[\"${ISO639_2[$LANG]}\",\"${LANG}\"]"
        fi
        ;;
    esac
done
export DATA_OCR_DEFAULT="${DATA_OCR_DEFAULT}"

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

# For script debugging only
printenv > /tmp/papermerge_uifile.env
# Deactivate on release!

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
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
                    debugger;
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
                            // d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_volume]').value+'/'+d.querySelector('input[name=wizard_storage_name]').value;
                            break;
                        case 'existing':
                            cmp_fld.show();
                            cmp_vol.hide();
                            cmp_nam.hide();
                            cmp_des.hide();
                            // d.querySelector('input[name=wizard_storage_path]').value=d.querySelector('input[name=wizard_storage_folder]').value;
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
                    if (d.querySelector('input[name=wizard_storage_kind]').value == 'existing' || arguments[0]) {
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
                        if (d.querySelector('input[name=wizard_storage_kind]').value == 'new' || arguments[0]) {
                            return true;
                        } else {
                            return 'Please choose an item!';
                        }
                    }"
                }
            }]
        }, {
            "type": "textfield",
            "subitems": [{
                "key": "wizard_storage_name",
                "desc": "Name",
                "defaultValue": "papermerge",
                "hidden": false,
                "validator": {
                    "fn": "{
                        debugger;
                        var d=document;
                        switch (d.querySelector('input[name=wizard_storage_kind]').value) {
                            case 'new':
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
                "defaultValue": "Papermerge database & file storage",
                "hidden": false
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
        }, {
            "key": "wizard_network_hosts",
            "desc": "Hosts",
            "displayField": "name",
            "valueField": "value",
            "forceSelection": true,
            "editable": false,
            "autoSelect": true,
            "mode": "local",
            "store": {
                "xtype": "arraystore",
                "fields": ["name", "value"],
                "data": [
                    ["All", "all"],
                    ["Specified", "specified"]
                ]
            },
            "validator": {
                "fn": "{
                    var d=document;
                    var cmp_host1=Ext.getCmp(document.querySelector('input[name=wizard_network_host1]').id);
                    var cmp_host2=Ext.getCmp(document.querySelector('input[name=wizard_network_host2]').id);
                    var cmp_host3=Ext.getCmp(document.querySelector('input[name=wizard_network_host3]').id);
                    var cmp_host4=Ext.getCmp(document.querySelector('input[name=wizard_network_host4]').id)
                    var cmp_host5=Ext.getCmp(document.querySelector('input[name=wizard_network_host5]').id)
                    switch (d.querySelector('input[name=wizard_network_hosts]').value) {
                        case 'specified':
                            cmp_host1.show();
                            cmp_host2.show();
                            cmp_host3.show();
                            cmp_host4.show();
                            cmp_host5.show();
                            break;
                        default:
                            cmp_host1.hide();
                            cmp_host2.hide();
                            cmp_host3.hide();
                            cmp_host4.hide();
                            cmp_host5.hide();
                            break;
                    }
                    return true;
                }"
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_network_host1",
            "desc": "Host 1",
            "defaultValue": "${WIZARD_HOST1}",
            "validator": {
                "fn": "{
                    var d=document;
                    if (d.querySelector('input[name=wizard_network_hosts]').value != 'all' &&
                    d.querySelector('input[name=wizard_network_hosts]').value != 'specified') {
                        arguments[2].items.items[2].hide();
                        arguments[2].items.items[3].hide();
                        arguments[2].items.items[4].hide();
                        arguments[2].items.items[5].hide();
                        arguments[2].items.items[6].hide();
                        return true;
                    }
                    if (d.querySelector('input[name=wizard_network_hosts]').value == 'specified') {
                        if (d.querySelector('input[name=wizard_network_host1]').value === '' && 
                        d.querySelector('input[name=wizard_network_host2]').value === '' && 
                        d.querySelector('input[name=wizard_network_host3]').value === '' &&
                        d.querySelector('input[name=wizard_network_host4]').value === '' &&
                        d.querySelector('input[name=wizard_network_host5]').value === '') {
                            return 'Please specify at least one valid host!';
                        } else {
                            // Insert regex to check for valid IPv4, IPv6 and FQDN/Domain
                            return true;
                        }
                    } else {
                        return true;
                    }
                }"
            }
        }, {
            "key": "wizard_network_host2",
            "desc": "Host 2",
            "defaultValue": "${WIZARD_HOST2}",
            "validator": {
                "fn": "{
                    var d=document;
                    if (d.querySelector('input[name=wizard_network_hosts]').value == 'specified') {
                        if (d.querySelector('input[name=wizard_network_host1]').value === '' && 
                        d.querySelector('input[name=wizard_network_host2]').value === '' && 
                        d.querySelector('input[name=wizard_network_host3]').value === '' &&
                        d.querySelector('input[name=wizard_network_host4]').value === '' &&
                        d.querySelector('input[name=wizard_network_host5]').value === '') {
                            return 'Please specify at least one valid host!';
                        } else {
                            // Insert regex to check for valid IPv4, IPv6 and FQDN/Domain
                            return true;
                        }
                    } else {
                        return true;
                    }
                }"
            }
        }, {
            "key": "wizard_network_host3",
            "desc": "Host 3",
            "defaultValue": "${WIZARD_HOST3}",
            "validator": {
                "fn": "{
                    var d=document;
                    if (d.querySelector('input[name=wizard_network_hosts]').value == 'specified') {
                        if (d.querySelector('input[name=wizard_network_host1]').value === '' && 
                        d.querySelector('input[name=wizard_network_host2]').value === '' && 
                        d.querySelector('input[name=wizard_network_host3]').value === '' &&
                        d.querySelector('input[name=wizard_network_host4]').value === '' &&
                        d.querySelector('input[name=wizard_network_host5]').value === '') {
                            return 'Please specify at least one valid host!';
                        } else {
                            // Insert regex to check for valid IPv4, IPv6 and FQDN/Domain
                            return true;
                        }
                    } else {
                        return true;
                    }
                }"
            }
        }, {
            "key": "wizard_network_host4",
            "desc": "Host 4",
            "defaultValue": "${WIZARD_HOST4}",
            "validator": {
                "fn": "{
                    var d=document;
                    if (d.querySelector('input[name=wizard_network_hosts]').value == 'specified') {
                        if (d.querySelector('input[name=wizard_network_host1]').value === '' && 
                        d.querySelector('input[name=wizard_network_host2]').value === '' && 
                        d.querySelector('input[name=wizard_network_host3]').value === '' &&
                        d.querySelector('input[name=wizard_network_host4]').value === '' &&
                        d.querySelector('input[name=wizard_network_host5]').value === '') {
                            return 'Please specify at least one valid host!';
                        } else {
                            // Insert regex to check for valid IPv4, IPv6 and FQDN/Domain
                            return true;
                        }
                    } else {
                        return true;
                    }
                }"
            }
        }, {
            "key": "wizard_network_host5",
            "desc": "Host 5",
            "defaultValue": "${WIZARD_HOST5}",
            "validator": {
                "fn": "{
                    var d=document;
                    if (d.querySelector('input[name=wizard_network_hosts]').value == 'specified') {
                        if (d.querySelector('input[name=wizard_network_host1]').value === '' && 
                        d.querySelector('input[name=wizard_network_host2]').value === '' && 
                        d.querySelector('input[name=wizard_network_host3]').value === '' &&
                        d.querySelector('input[name=wizard_network_host4]').value === '' &&
                        d.querySelector('input[name=wizard_network_host5]').value === '') {
                            return 'Please specify at least one valid host!';
                        } else {
                            // Insert regex to check for valid IPv4, IPv6 and FQDN/Domain
                            return true;
                        }
                    } else {
                        return true;
                    }
                }"
            }
        }]
    }]
}, {
    "step_title": "Security settings",
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_security_secretkey",
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
            "key": "wizard_security_adminuser",
            "desc": "Admin username",
            "allowvalidator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/[a-zA-Z0-9-]+/",
                    "errorText": "Not allowed character"
                }
            }
        }, {
            "key": "wizard_security_adminmail",
            "desc": "Admin Email",
            "validator": {
                "allowBlank": true,
                "vtype": "email"
            }
        }]
    }, {
        "type": "password",
        "subitems": [{
            "key": "wizard_security_adminpassword",
            "desc": "Admin password",
            "validator": {
                "allowBlank": false,
                "minLength": 8
            }
        }]
    }]
},  {
    "step_title": "Import Email settings",
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_import_mailhost",
            "desc": "Host"
        }, {
            "key": "wizard_import_mailport",
            "desc": "Port"
        }, {
            "key": "wizard_import_mailuser",
            "desc": "Username"
        }]
    }, {
        "type": "password",
        "subitems": [{
            "key": "wizard_import_mailpassword",
            "desc": "Password"
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_import_mailinbox",
            "desc": "Inbox"
        }, {
            "key": "wizard_import_mailsecret",
            "desc" : "Secret"
        }]
    }]
}, {
    "step_title": "OCR settings",
    "items": [{
        "type": "combobox",
        "subitems": [{
            "key": "wizard_ocr_defaultlanguage",
            "desc": "Default language",
            "displayField": "name",
            "valueField": "value",
            "forceSelection": true,
            "editable": false,
            "autoSelect": true,
            "mode": "local",
            "store": {
                "xtype": "arraystore",
                "fields": ["name", "value"],
                "data": [$(echo -e "${DATA_OCR_DEFAULT}")]
            },
            "validator": {
                "fn": "{
                    if (arguments[2].items.items[0].selectedIndex != -1) {
                        return true;
                    } else {
                        arguments[2].items.items[0].setValue('Please choose language ...');
                        return true;
                    }
                }"
            }
        }]
    }]
}, {    
    "step_title": "Example Data Import",
    "items": [{
        "type": "singleselect",
        "subitems": [{
            "key": "wizard_example_skip",
            "desc": "Skip",
            "defaultVaule": true
        }, {
            "key": "wizard_example_deu",
            "desc": "German",
            "defaultVaule": false
        }, {
            "key": "wizard_example_eng",
            "desc": "English",
            "defaultVaule": false
        }, {
            "key": "wizard_example_spa",
            "desc": "Spanish",
            "defaultVaule": false
        }]
    }]
}, {
    "step_title": "Attention! DSM6 Permissions",
    "items": [{
        "desc": "Permissions for this package are handled by the <b>'sc-papermerge'</b> group. <br>Using File Station, add this group to every folder papermerge should be allowed to access.<br>Please read <a <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
    }]
}] EOF
exit 0