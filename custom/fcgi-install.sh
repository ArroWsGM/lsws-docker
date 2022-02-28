#!/bin/bash

LS_FD=''
PHP_VERSION=''

check_input(){
    if [ -z "${1}" ]; then
        echo 'Please specify a version!'
        exit 1
    else
        PHP_VERSION="${1}"
    fi

    if [ -z "${2}" ]; then
        echo 'Please specify a path!'
        exit 1
    else
        LS_FD="${2}"
    fi
}

basic_install(){
  if [[ $PHP_VERSION == lsphp7* ]] ; then
    ln -sf "${LS_FD}"/"${PHP_VERSION}"/bin/lsphp "${LS_FD}"/fcgi-bin/lsphp7
    ln -sf "${LS_FD}"/fcgi-bin/lsphp7 "${LS_FD}"/fcgi-bin/lsphp
    echo 'lsphp7 variant'
  else
    ln -sf "${LS_FD}"/"${PHP_VERSION}"/bin/lsphp "${LS_FD}"/fcgi-bin/lsphp8
    ln -sf "${LS_FD}"/fcgi-bin/lsphp8 "${LS_FD}"/fcgi-bin/lsphp
    echo 'lsphp8 variant'
  fi
}

main(){
    check_input ${1} ${2}
    basic_install ${1} ${2}
}

main ${1} ${2}