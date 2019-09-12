#!/bin/sh

FILES=$(ls "${SYNOPKG_PKGDEST}/share/tessdata/" | grep ".*.traineddata$")

for FILE in $FILES
do
    if [ -z "${INSTALLED_LANGS}" ]; then
        INSTALLED_LANGS="'${FILE:0:3}'"
    else
        INSTALLED_LANGS="${INSTALLED_LANGS}, '${FILE:0:3}'"
    fi
done

export INSTALLED_LANGS="$INSTALLED_LANGS"

cat <<EOF > ${SYNOPKG_TEMP_LOGFILE}
[{
  "step_title": "Select training data",
  "activeate": "{
    wizard_hide_func=function() {
      var d=document;
      var dataset;
      switch (d.querySelector('input[type=hidden][name=wizard_kind]').value) {
        case 'tessdata':
          dataset=[
            'afr', 'amh', 'ara', 'asm', 'aze', 'aze_cyrl',
            'bel', 'ben', 'bod', 'bos', 'bre', 'bul',
            'cat', 'ceb', 'ces', 'chi_sim', 'chi_sim_vert', 'chi_tra', 'chi_tra_vert', 'chr', 'cos', 'cym',
            'dan', 'dan_frak', 'deu', 'deu_frak', 'div', 'dzo',
            'ell', 'eng', 'enm', 'epo', 'equ', 'est', 'eus',
            'fao', 'fas', 'fil', 'fin', 'fra', 'frk', 'frm', 'fry',
            'gla', 'gle', 'glg', 'grc', 'guj',
            'hat', 'heb', 'hin', 'hrv', 'hun', 'hye',
            'iku', 'ind', 'isl', 'ita', 'ita_old',
            'jav', 'jpn', 'jpn_vert',
            'kan', 'kat', 'kat_old', 'kaz', 'khm', 'kir', 'kmr', 'kor', 'kor_vert',
            'lao', 'lat', 'lav', 'lit', 'ltz',
            'mal', 'mar', 'mkd', 'mlt', 'mon', 'mri', 'msa', 'mya',
            'nep', 'nld', 'nor',
            'oci', 'ori', 'osd',
            'pan', 'pol', 'por', 'pus',
            'que',
            'ron', 'rus',
            'san', 'sin', 'slk', 'slk_frak', 'slv', 'snd', 'spa', 'spa_old', 'sqi', 'srp', 'srp_latn', 'sun', 'swa', 'swe', 'syr',
            'tam', 'tat', 'tel', 'tgk', 'tgl', 'tha', 'tir', 'ton', 'tur',
            'uig', 'ukr', 'urd', 'uzb', 'uzb_cyrl',
            'vie',
            'yid', 'yor'
          ];
          break;
        case 'tessdata_fast':
          dataset=[
            'afr', 'amh', 'ara', 'asm', 'aze', 'aze_cyrl',
            'bel', 'ben', 'bod', 'bos', 'bre', 'bul',
            'cat', 'ceb', 'ces', 'chi_sim', 'chi_sim_vert', 'chi_tra', 'chi_tra_vert', 'chr', 'cos', 'cym',
            'dan', 'deu', 'div', 'dzo',
            'ell', 'eng', 'enm', 'epo', 'est', 'eus',
            'fao', 'fas', 'fil', 'fin', 'fra', 'frk', 'frm', 'fry',
            'gla', 'gle', 'glg', 'grc', 'guj',
            'hat', 'heb', 'hin', 'hrv', 'hrv', 'hun', 'hye',
            'iku', 'ind', 'isl', 'ita', 'ita_old',
            'jav', 'jpn', 'jpn_vert',
            'kan', 'kat', 'kat_old', 'kaz', 'khm', 'kir', 'kmr', 'kor', 'kor_vert',
            'lao', 'lat', 'lav', 'lit', 'ltz',
            'mal', 'mar', 'mkd', 'mlt', 'mon', 'mri', 'mya',
            'nep', 'nld', 'nor',
            'oci', 'ori', 'osd',
            'pan', 'pol', 'pus',
            'que',
            'ron', 'rus',
            'san', 'sin', 'slk', 'slv', 'snd', 'spa', 'spa_old', 'sqi','srp', 'srp_latn', 'sun', 'swa', 'swe', 'syr',
            'tam', 'tat', 'tel', 'tgk', 'tha', 'tir', 'ton', 'tur',
            'uig', 'ukr', 'urd', 'uzb', 'uzb_cyrl',
            'vie',
            'yid', 'yor'
          ];
          break;
        case 'tessdata_best':
          dataset=[
            'afr', 'amh', 'ara', 'asm', 'aze', 'aze_cyrl',
            'bel', 'ben', 'bod', 'bos', 'bre', 'bul',
            'cat', 'ceb', 'ces', 'chi_sim', 'chi_sim_vert', 'chi_tra', 'chi_tra_vert', 'chr', 'cos', 'cym',
            'dan', 'deu', 'div', 'dzo',
            'ell', 'eng', 'enm', 'epo', 'est', 'eus',
            'fao', 'fas', 'fil', 'fin', 'fra', 'frk', 'frm', 'fry',
            'gla', 'gle', 'glg', 'grc', 'guj',
            'hat', 'heb', 'hin', 'hrv', 'hun', 'hye',
            'iku', 'ind', 'isl', 'ita', 'ita_old',
            'jav', 'jpn', 'jpn_vert',
            'kan', 'kat', 'kat_old', 'kaz', 'khm', 'kir', 'kmr', 'kor', 'kor_vert',
            'lao', 'lat', 'lav', 'lit', 'ltz',
            'mal', 'mar', 'mkd', 'mlt', 'mon', 'mri', 'msa', 'mya',
            'nep', 'nld', 'nor',
            'oci', 'ori', 'osd',
            'pan', 'pol', 'por', 'pus',
            'que',
            'ron', 'rus',
            'san', 'sin', 'slk', 'slv', 'snd', 'spa', 'spa_old', 'sqi', 'srp', 'srp_latn', 'sun', 'swa', 'swe', 'syr',
            'tam', 'tat', 'tel', 'tgk', 'tha', 'tir', 'ton', 'tur',
            'uig', 'ukr', 'urd', 'uzb', 'uzb_cyrl',
            'vie',
            'yid', 'yor'
          ];
          break;
      }
      var re=new RegExp(d.querySelector('input[type=text][name=wizard_search]').value,'gi');
      var els=document.querySelectorAll('input[type=checkbox][name*=wizard_lang_]');
      for (var el of els) {
        var comp=Ext.getCmp(el.id);
        if (dataset.includes(comp.name.substring(12))) {
          if (comp.boxLabel.match(re) || comp.name.substring(12).match(re)) {
            if (comp.initialConfig.checked && comp.disabled) {
              comp.setValue(true);
            }
            comp.show();
          } else {
            comp.hide();
          }
        } else {
          comp.hide();
          comp.setValue(false);
        }
      }
    };
    var d=document;
    d.querySelector('input[type=text][name=wizard_search]').oninput=this.window.wizard_hide_func;
    debugger;
    var installed_langs=[$INSTALLED_LANGS];
    for (var lang of installed_langs) {
      var comp=Ext.getCmp(d.querySelector('input[type=checkbox][name=wizard_lang_'+lang+']').id);
      comp.setValue(true);
    }
  }",
  "invalid_next_disabled": true,
  "items": [{
    "type": "combobox",
    "subitems": [{
      "key": "wizard_kind",
      "desc": "Kind",
      "displayField": "name",
      "valueField": "value",
      "editable": false,
      "forceSelection": true,
      "autoSelect": true,
      "mode": "local",
      "store": {
        "xtype": "arraystore",
        "fields": ["name", "value"],
        "data": [
          ["Fast", "tessdata_fast"],
          ["Best", "tessdata_best"],
          ["Common", "tessdata"]
        ]
      },
      "validator": {
        "fn": "{
          this.window.wizard_hide_func();
          return true;
        }"
      }
    }]
  }, {
    "type": "textfield",
    "subitems": [{
      "key": "wizard_version",
      "desc": "Version",
      "disabled": true,
      "hidden": true,
      "defaultValue": "4.0.0"
    }, {
      "key": "wizard_search",
      "desc": "Search",
      "emptyText": "Search for specific language"
    }]
  }, {
    "type": "multiselect",
    "subitems": [{
      "key": "wizard_lang_afr",
      "desc": "Afrikaans"
    }, {
      "key": "wizard_lang_amh",
      "desc": "Amharic"
    }, {
      "key": "wizard_lang_ara",
      "desc": "Arabic"
    }, {
      "key": "wizard_lang_asm",
      "desc": "Assamese"
    }, {
      "key": "wizard_lang_aze",
      "desc": "Azerbaijani"
    }, {
      "key": "wizard_lang_aze_cyrl",
      "desc": "Azerbaijani - Cyrilic"
    }, {
      "key": "wizard_lang_bel",
      "desc": "Belarusian"
    }, {
      "key": "wizard_lang_ben",
      "desc": "Bengali"
    }, {
      "key": "wizard_lang_bod",
      "desc": "Tibetan"
    }, {
      "key": "wizard_lang_bos",
      "desc": "Bosnian"
    }, {
      "key": "wizard_lang_bre",
      "desc": "Breton"
    }, {
      "key": "wizard_lang_bul",
      "desc": "Bulgarian"
    }, {
      "key": "wizard_lang_cat",
      "desc": "Catalan; Valencian"
    }, {
      "key": "wizard_lang_ceb",
      "desc": "Cebuano"
    }, {
      "key": "wizard_lang_ces",
      "desc": "Czech"
    }, {
      "key": "wizard_lang_chi_sim",
      "desc": "Chinese simplified"
    }, {
      "key": "wizard_lang_chi_tra",
      "desc": "Chinese traditional"
    }, {
      "key": "wizard_lang_chr",
      "desc": "Cherokee"
    }, {
      "key": "wizard_lang_cym",
      "desc": "Welsh"
    }, {
      "key": "wizard_lang_dan",
      "desc": "Danish"
    }, {
      "key": "wizard_lang_deu",
      "desc": "German"
    }, {
      "key": "wizard_lang_dzo",
      "desc": "Dzongkha"
    }, {
      "key": "wizard_lang_ell",
      "desc": "Greek, Modern, 1453-"
    }, {
      "key": "wizard_lang_eng",
      "desc": "English",
      "defaultValue": true,
      "disabled": true
    }, {
      "key": "wizard_lang_enm",
      "desc": "English, Middle, 1100-1500"
    }, {
      "key": "wizard_lang_equ",
      "desc": "Math / equation detection module",
      "defaultValue": true,
      "disabled": true
    }, {
      "key": "wizard_lang_est",
      "desc": "Estonian"
    }, {
      "key": "wizard_lang_eus",
      "desc": "Basque"
    }, {
      "key": "wizard_lang_fas",
      "desc": "Persian"
    }, {
      "key": "wizard_lang_fin",
      "desc": "Finnish"
    }, {
      "key": "wizard_lang_fra",
      "desc": "French"
    }, {
      "key": "wizard_lang_frk",
      "desc": "Frankish"
    }, {
      "key": "wizard_lang_frm",
      "desc": "French, Middle, 1400-1600"
    }, {
      "key": "wizard_lang_gle",
      "desc": "Irish"
    }, {
      "key": "wizard_lang_glg",
      "desc": "Galician"
    }, {
      "key": "wizard_lang_grc",
      "desc": "Greek, Ancient, -1453"
    }, {
      "key": "wizard_lang_guj",
      "desc": "Gujarati"
    }, {
      "key": "wizard_lang_hat",
      "desc": "Haitian; Haitian Creole"
    }, {
      "key": "wizard_lang_heb",
      "desc": "Hebrew"
    }, {
      "key": "wizard_lang_hin",
      "desc": "Hindi"
    }, {
      "key": "wizard_lang_hrv",
      "desc": "Croatian"
    }, {
      "key": "wizard_lang_hun",
      "desc": "Hungarian"
    }, {
      "key": "wizard_lang_iku",
      "desc": "Inuktitut"
    }, {
      "key": "wizard_lang_ind",
      "desc": "Indonesian"
    }, {
      "key": "wizard_lang_isl",
      "desc": "Icelandic"
    }, {
      "key": "wizard_lang_ita",
      "desc": "Italian"
    }, {
      "key": "wizard_lang_ita_old",
      "desc": "Italian - Old"
    }, {
      "key": "wizard_lang_jav",
      "desc": "Javanese"
    }, {
      "key": "wizard_lang_jpn",
      "desc": "Japanese"
    }, {
      "key": "wizard_lang_kan",
      "desc": "Kannada"
    }, {
      "key": "wizard_lang_kat",
      "desc": "Georgian"
    }, {
      "key": "wizard_lang_kat_old",
      "desc": "Georgian - Old"
    }, {
      "key": "wizard_lang_kaz",
      "desc": "Kazakh"
    }, {
      "key": "wizard_lang_khm",
      "desc": "Central Khmer"
    }, {
      "key": "wizard_lang_kir",
      "desc": "Kirghiz; Kyrgyz"
    }, {
      "key": "wizard_lang_kmr",
      "desc": "Kurdish Kurmanji"
    }, {
      "key": "wizard_lang_kor",
      "desc": "Korean"
    }, {
      "key": "wizard_lang_kor_vert",
      "desc": "Korean vertical"
    }, {
      "key": "wizard_lang_kur",
      "desc": "Kurdish"
    }, {
      "key": "wizard_lang_lao",
      "desc": "Lao"
    }, {
      "key": "wizard_lang_lat",
      "desc": "Latin"
    }, {
      "key": "wizard_lang_lav",
      "desc": "Latvian"
    }, {
      "key": "wizard_lang_lit",
      "desc": "Lithuanian"
    }, {
      "key": "wizard_lang_ltz",
      "desc": "Luxembourgish"
    }, {
      "key": "wizard_lang_mal",
      "desc": "Malayalam"
    }, {
      "key": "wizard_lang_mar",
      "desc": "Marathi"
    }, {
      "key": "wizard_lang_mkd",
      "desc": "Macedonian"
    }, {
      "key": "wizard_lang_mlt",
      "desc": "Maltese"
    }, {
      "key": "wizard_lang_mon",
      "desc": "Mongolian"
    }, {
      "key": "wizard_lang_mri",
      "desc": "Maori"
    }, {
      "key": "wizard_lang_msa",
      "desc": "Malay"
    }, {
      "key": "wizard_lang_mya",
      "desc": "Burmese"
    }, {
      "key": "wizard_lang_nep",
      "desc": "Nepali"
    }, {
      "key": "wizard_lang_nld",
      "desc": "Dutch / Flemish"
    }, {
      "key": "wizard_lang_nor",
      "desc": "Norwegian"
    }, {
      "key": "wizard_lang_oci",
      "desc": "Occitan 1500-"
    }, {
      "key": "wizard_lang_ori",
      "desc": "Oriya"
    }, {
      "key": "wizard_lang_osd",
      "desc": "Orientation and script detection module",
      "defaultValue": true,
      "disabled": true
    }, {
      "key": "wizard_lang_pan",
      "desc": "Panjabi / Punjabi"
    }, {
      "key": "wizard_lang_pol",
      "desc": "Polish"
    }, {
      "key": "wizard_lang_por",
      "desc": "Portuguese"
    }, {
      "key": "wizard_lang_pus",
      "desc": "Pushto / Pashto"
    }, {
      "key": "wizard_lang_que",
      "desc": "Quechua"
    }, {
      "key": "wizard_lang_ron",
      "desc": "Romanian / Moldavian / Moldovan"
    }, {
      "key": "wizard_lang_rus",
      "desc": "Russian"
    }, {
      "key": "wizard_lang_san",
      "desc": "Sanskrit"
    }, {
      "key": "wizard_lang_sin",
      "desc": "Sinhala / Sinhalese"
    }, {
      "key": "wizard_lang_slk",
      "desc": "Slovak"
    }, {
      "key": "wizard_lang_slv",
      "desc": "Slovenian"
    }, {
      "key": "wizard_lang_snd",
      "desc": "Sindhi"
    }, {
      "key": "wizard_lang_spa",
      "desc": "Spanish / Castilian"
    }, {
      "key": "wizard_lang_spa_old",
      "desc": "Spanish / Castilian - Old"
    }, {
      "key": "wizard_lang_sqi",
      "desc": "Albanian"
    }, {
      "key": "wizard_lang_srp",
      "desc": "Serbian"
    }, {
      "key": "wizard_lang_srp_latn",
      "desc": "Serbian - Latin"
    }, {
      "key": "wizard_lang_sun",
      "desc": "Sundanese"
    }, {
      "key": "wizard_lang_swa",
      "desc": "Swahili"
    }, {
      "key": "wizard_lang_swe",
      "desc": "Swedish"
    }, {
      "key": "wizard_lang_syr",
      "desc": "Syriac"
    }, {
      "key": "wizard_lang_tam",
      "desc": "Tamil"
    }, {
      "key": "wizard_lang_tat",
      "desc": "Tatar"
    }, {
      "key": "wizard_lang_tel",
      "desc": "Telugu"
    }, {
      "key": "wizard_lang_tgk",
      "desc": "Tajik"
    }, {
      "key": "wizard_lang_tgl",
      "desc": "Tagalog"
    }, {
      "key": "wizard_lang_tha",
      "desc": "Thai"
    }, {
      "key": "wizard_lang_tir",
      "desc": "Tigrinya"
    }, {
      "key": "wizard_lang_ton",
      "desc": "Tonga"
    }, {
      "key": "wizard_lang_tur",
      "desc": "Turkish"
    }, {
      "key": "wizard_lang_uig",
      "desc": "Uighur / Uyghur"
    }, {
      "key": "wizard_lang_ukr",
      "desc": "Ukrainian"
    }, {
      "key": "wizard_lang_urd",
      "desc": "Urdu"
    }, {
      "key": "wizard_lang_uzb",
      "desc": "Uzbek"
    }, {
      "key": "wizard_lang_uzb_cyrl",
      "desc": "Uzbek - Cyrilic"
    }, {
      "key": "wizard_lang_vie",
      "desc": "Vietnamese"
    }, {
      "key": "wizard_lang_yid",
      "desc": "Yiddish"
    }, {
      "key": "wizard_lang_yor",
      "desc": "Yoruba"
    }]
  }]
}]
EOF
exit 0
