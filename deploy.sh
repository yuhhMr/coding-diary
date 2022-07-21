#!/bin/bash
# 功能：静态站点自动化部署
# 作者：yuhh

# 环境变量
_CURPATH=$(cd "$(dirname "$0")"; pwd)
_START=public
_TARGET=/data/compose/nginx/html/
_FILE=public.tar
# deploy cmd
cd $_CURPATH && hugo && tar -cf $_FILE $_START && mv $_FILE $_TARGET && \
cd $_TARGET && rm -rf public && tar -xf $_FILE && rm -f $_FILE


