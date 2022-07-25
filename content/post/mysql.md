---
title: "mysql"
date: 2022-07-22
lastmod: 
draft: false
tags: ['mysql']
author: yuhh

---

> 关系型数据库mysql


## Mysql的安装

这里使用docker-compose 的方式安装，其它安装方式请参照 [官方文档](https://dev.mysql.com/doc/refman/8.0/en/installing.html)

前提：已经搭建容器环境

1. 在数据盘下建立容器映射路径

```shell
mkdir -p /data/compose/mysql/conf.d  # 配置文件
mkdir -p /data/compose/mysql/datadir # 数据文件
cd /data/compose/mysql/ && touch mysqld.log # 日志文件
```

2. 编写compose 配置文件

<details>
    <summary>查看代码</summary>
    <pre>
        <code>
version: "1"
services:        
    mysql:
    container_name: mysql # 指定容器的名称
    image: mysql:latest   # 指定镜像和版本
    ports:
      - 3306:3306
      - 33060:33060
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: *******
      MYSQL_ROOT_HOST: '%'
      TZ: Asia/Shanghai
    command:
      --character-set-server=utf8mb4 
      --collation-server=utf8mb4_general_ci 
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1 # 1：区分大小 0：不区分
      --max_allowed_packet=512M # 最大允许的数据包大小(数据备份的时候用到)
    volumes:
      - /data/compose/mysql/conf.d:/etc/mysql/conf.d # 配置文件
      - /data/compose/mysql/datadir:/var/lib/mysql # 数据文件
      - /data/compose/mysql/mysqld.log:/var/log/mysqld.log # 日志文件      
        </code>
    </pre>
</details>

3. 启动容器

```shell
nerdctl pull mysql:latest # 下载镜像
nerdctl compose up -d # 启动容器
nerdctl compose down # 停止并删除容器
nerdctl compose kill # Force stop service containers
```


## Mysql的使用

### 用户管理

创建好数据库之后进行本地登录

```shell
mysql -u root -p # 本地登录
```
1. 查看用户
```sql

use mysql; -- 切换到mysql database;
select a.Host, a.User from`user`a; -- 查看用户

```
2. 创建用户
    * username：创建的用户名；
    * host：指定用户可在哪个主机地址进行登陆，可以是 IP、IP 段、域名以及 %（% 为通配符，表示任何地址），本地登陆可用 localhost；
    * password：用户的登录密码，可以为空，如果为空则不需要密码登录；

```sql
CREATE USER 'yuhh'@'localhost' IDENTIFIED BY 'password'; -- 创建本地登录用户
CREATE USER 'yuhh'@'%' IDENTIFIED BY 'password'; -- 创建远程登录用户
```
3. 修改用户

```sql
RENAME USER 'yuhh'@'%' TO 'yhh'@'%'; -- 修改用户名

UPDATE `mysql`.`user` SET `authentication_string`=PASSWORD('123456') WHERE `user`='yuhh'; -- 修改密码
FLUSH PRIVILEGES; -- 密码修改生效
```

**使用 mysqladmin 命令:**

    命令格式：mysqladmin -u用户名 -p旧的密码 password 新密码

*提示：*  mysqladmin 位于 mysql 安装目录的 bin 目录下(/usr/bin/mysqladmin)

4. 删除用户

```sql
-- 删除的时候要结合用户名和 host 来删除（如果缺省 host 则默认为 %）
DROP USER 'yuhh'@'localhost';
```

### 用户权限管理

1. 查看权限

```sql
SHOW GRANTS FOR 'root'@'%';
```
2. 添加权限
    
    + privilege：用户的操作权限，创建用户时默认是没有权限的 USAGE；
    + ON：后面紧跟数据库和数据表名称，表示要对哪个数据库的哪张表进行授权，可以使用通配符 * 表示所有；
    + TO：表示授予权限的用户；
    
```sql
-- 给远程登录用户赋予 demo 库下的 test 表 的查询和插入权限
GRANT SELECT, INSERT ON `demo`.`test` TO 'yuhh'@'%';
-- 给远程登录用户赋予 demo 库下的 所有表的所有权限
GRANT ALL PRIVILEGES ON `demo`.* TO 'yuhh'@'%';
-- 给远程登录用户赋予Mysql服务器的所有权限
GRANT ALL PRIVILEGES ON *.* TO 'yuhh'@'%';
-- 创建用户的同时赋予权限
GRANT ALL ON demo.* TO 'yuhh'@'%' IDENTIFIED BY 'passwd';
-- 刷新权限
FLUSH PRIVILEGES;
```

3. 移除权限

```sql
-- 移除用户在demo库下的test的查询、写入权限
REVOKE SELECT, INSERT ON `demo`.`test` FROM 'yuhh'@'%';
-- 移除用户所有的权限
REVOKE ALL ON *.* FROM 'yuhh'@'%';
-- 刷新权限
FLUSH PRIVILEGES;
```
### 日志调试

```sql
-- 查看日志调试控制变量和日志文件存放位置
SHOW VARIABLES LIKE "general_log%";
-- 设置日志输出格式(以表的形式输出)
SET GLOBAL log_output = 'TABLE'; 
-- 开启日志调试
SET GLOBAL general_log = 'ON';
-- 关闭日志调试
SET GLOBAL general_log = 'OFF';
-- 查询会话表执行的SQL(分析持久层框架的sql封装，如mybatisplus)
SELECT * from mysql.general_log a where a.argument like "UPDATE course_schedule_log%" order by   event_time DESC
```