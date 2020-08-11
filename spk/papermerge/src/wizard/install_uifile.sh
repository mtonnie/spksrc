#!/bin/sh

# Generate default value for secret key
export WIZARD_SECRET_KEY="$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c50)"

# For script debugging only
printenv > /tmp/papermerge_uifile.env
# Deactivate on release!

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
            "subitems": [
            {
                "key": "wizard_storage_name",
                "desc": "Name",
                "defaultValue": "papermerge",
                "hidden": false,
                 "validator": {
                    "fn": "{
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
                    "allowBlank": true,
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
        "step_title": "Attention! DSM6 Permissions",
        "items": [{
            "desc": "Permissions for this package are handled by the <b>'sc-papermerge'</b> group. <br>Using File Station, add this group to every folder papermerge should be allowed to access.<br>Please read <a <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
        }]
    }
] EOF
cat "$SYNOPKG_TEMP_LOGFILE" > /tmp/paperless.debug
exit 0