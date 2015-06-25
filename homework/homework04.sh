#!/bin/bash

# 判断httpd是否运行

service httpd status &> /dev/null
[ $? -eq 0 ] && echo "httpd正在运行" || echo "httpd已停止"
