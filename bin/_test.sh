#!/usr/bin/bash
PHP_VERSION=lsphp74
if [[ $PHP_VERSION = lsphp7* ]]; then echo 144; fi
if [[ $PHP_VERSION = lsphp8* ]]; then echo 145; fi
echo 146