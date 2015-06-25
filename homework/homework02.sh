#!/bin/bash

# 判断当前内核的主板本是否为2，且次版本是否大于6

version=`uname -a | cut -d ' ' -f 3 | cut -d '.' -f 1,2`
major=${version%%.*}
minor=${version##*.}
[ $major -ge 2 -a $minor -ge 6 ] && echo "稳定版" || "非稳定版"
