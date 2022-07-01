#!/bin/bash
# 全局变量
CURPATH=$(cd "$(dirname "$0")"; pwd)
_PORT=8080
_LOG="hugo.log"
# 加载变量
cd $CURPATH && echo "" >> $_LOG

# 杀死进程
_PID=`lsof -i:$_PORT -n | awk 'NR==2 {print $2}'`
if [ `echo $_PID | wc -c` -gt 1 ]; then
  echo "the running pid will be kill..."
  kill -9 $_PID
  echo "killed => "$_PID
fi

# 启动服务
hugo server --liveReloadPort 80 -v -w -p $_PORT > $_LOG 2>&1 &
