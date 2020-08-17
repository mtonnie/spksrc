#!/bin/sh
# Wrapper to convert pdftk command line arguments to stapler

args=$(echo $@ | sed 's/cat/%/' | sed 's/output/#/') 
input_files=$(echo "${args}" | cut -d'%' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
pages=$(echo "${args}" | cut -d'%' -f2 | cut -d'#' -f1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
output_files=$(echo "${args}" | cut -d'#' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

/var/packages/papermerge/target/env/bin/stapler sel $input_files $pages $output_files

exit $?