---
title: "redis"
date: 2022-07-23
lastmod: 
draft: false
tags: ['redis']
author: yuhh

---

> nosql缓存数据库redis

+ Redis 是目前最流行的跨平台的非关系型数据库。

+ Redis 是一个开源的使用 ANSI C 语言编写、遵守 BSD 协议、支持网络、可基于内存、分布式、可选持久性的键值对(Key-Value)存储数据库，并提供多种语言的 API。

+ Redis 通常被称为数据结构服务器，因为值（value）可以是字符串(String)、哈希(Hash)、列表(list)、集合(sets)和有序集合(sorted sets)等类型。

## redis 的安装

1. 在window 平台下使用 [scoop](https://scoop.sh/) 包管理工具安装（dev环境）

```pwsh
➜ scoop install redis # 安装redis
➜ redis-server --service-install redis.windows.conf --loglevel verbose # 安装redis服务
➜ redis-server --service-start # 启动服务
➜ redis-server --service-stop # 停止服务
➜ redis-server --service-start redis.windows-service.conf # 指定配置环境启动
```

2. 使用容器部署(prod环境)

```shell
version: "1"
services:
    redis:
    container_name: redis
    image: redis:latest
    restart: always
    ports:
      - 6379:6379
    command: redis-server /usr/local/etc/redis/redis.conf
    volumes:
      - /data/redis/redis.conf:/usr/local/etc/redis/redis.conf # 配置文件映射
      - /data/redis/:/data/ # dump.rdb 快照文件映射
```

## redis 命令行

[官方文档](https://redis.io/docs/)

[翻译文档](http://redisdoc.com/index.html)


## redis 的配置

### NETWORK

```shell
# 指定redis只接收哪些IP的请求，如果配置bind 127.0.0.1则只监听本机的客户端请求，(可配置多个ip)
# 如果注释掉不进行设置，则代表接收所有IP的请求。
bind 127.0.0.1

#是否开启保护模式，默认开启。要是配置里没有指定bind和密码。开启该参数后，redis只能本地进行访问，
#拒绝外部访问。如果开启了密码和bind，可以开启。否则最好关闭，即设置为no。
protected-mode yes  # 开启此模式后，需要auth

# 设置监听的端口号，默认是6379。如果设置0，则不监听任何tcp请求。
port 6379

#在高并发环境下，并且客户端连接请求慢时，你需要设置更高的值。此值代表了TCP连接中已完成队列
#(完成三次握手之后)的长度，此值必须会受到Linux系统下/proc/sys/net/core/somaxconn文件
# 中值的限制，redis默认是511，而Linux的默参数值是128。所以我们得同时提高这2个值的大小，
#以至于能获得更好的性能以及预期的效果。一般会将它修改为2048或者更大。
# 在/etc/sysctl.conf中添加:net.core.somaxconn = 2048，然后在终端中执行sysctl -p
tcp-backlog 511

#  此参数为设置客户端空闲超过timeout，服务端会断开连接，为0则服务端不会主动断开连接，不能小于0
timeout 0

# TCP keepalive.
#
# If non-zero, use SO_KEEPALIVE to send TCP ACKs to clients in absence
# of communication. This is useful for two reasons:
#
# 1) Detect dead peers.
# 2) Take the connection alive from the point of view of network
#    equipment in the middle.
#
# On Linux, the specified value (in seconds) is the period used to send ACKs.
# Note that to close the connection the double of the time is needed.
# On other kernels the period depends on the kernel configuration.
#
# A reasonable value for this option is 300 seconds, which is the new
# Redis default starting with Redis 3.2.1.
tcp-keepalive 300
```

### GENERAL

```shell
# 后台运行 默认是no
daemonize yes  

# 可以通过upstart和systemd管理Redis守护进程，这个参数是和具体的操作系统相关的。
supervised no

# redis服务后台启动时，pid写入的文件位置
pidfile /var/run/redis_6379.pid

# 日志级别。
#   debug：记录大量日志信息，适用于开发和测试
#   verbose：较多日志信息
#   notice：适量日志信息，适用于生产环境
#   warning：仅有部分重要、关键信息才会被记录
loglevel notice

# 日志文件的位置，当指定为空字符串时，为标准输出，如果redis为守护进程模式运行，那么日志将会输出到 /dev/null 
logfile ""

# 是否把日志记录到系统日志
# syslog-enabled no

# 设置系统日志的id
# syslog-ident redis

# 指定syslog设备，必须是user或则local0到local7
# syslog-facility local0

# 默认有16个数据库，可通过select切换数据库 （编号为[0,15]）
databases 16  

# 是否在交互式终端启动的时候显示log，不用管它就好，感觉没啥意义
always-show-logo yes

```

### SNAPSHOTTING 快照

```shell
# 保存数据到磁盘。格式是：save <seconds> <changes> ，即在seconds秒之后至少有
#changes个keys发生改变则保存一次。如果你不想保存数据到磁盘，则注释掉所有save行即可
#，也可改为save ""
#
save 900 1
save 300 10
save 60 10000

# 默认情况下，如果redis最后一次的后台保存失败，redis将停止接受写操作，这样以一种强硬
# 的方式让用户知道数据不能正确的持久化到磁盘，否则就会没人注意到灾难的发生。如果后台保存
# 进程重新启动工作了，redis也将自动的允许写操作。如果你要是安装了靠谱的监控，你可能不希
# 望redis这样做，那你就改成no。
#
stop-writes-on-bgsave-error yes

# 是否在dump.rdb数据库的时候压缩字符串，默认设置为yes。如果你想节约一些cpu资源的话，
# 可以把它设置为no，这样的话数据集就可能会比较大。
rdbcompression yes

# 是否CRC64校验rdb文件，会有一定的性能损失（大概10%）。
rdbchecksum yes

# rdb文件的名字。
dbfilename dump.rdb

# 数据库存放目录。必须是一个目录，aof文件也会保存到该目录下。默认在启动脚本相同的目录下。
dir ./
```

### SECURITY 安全

```shell
# redis连接密码
#
requirepass 123456

# 将命令重命名。为了安全考虑，可以将某些重要的、危险的命令重命名。当你把某个命令重命名成空字符串的时候就等于取消了这个命令。
# rename-command CONFIG b4dw78w47d15w4d8w，表示将CONFIG命令重命名为b4dw78w47d15w4d8w；rename-command CONFIG "" 代表禁用CONFIG
#
# rename-command CONFIG ""
```
### CLIENTS 客户端

```shell
# 设置客户端最大并发连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数-32（redis server自身会使用一些），
# 如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息。
#
# maxclients 10000
```

### MEMORY MANAGEMENT

```shell

# 指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，
# 当此方法处理后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。
# Redis新的vm机制，会把Key存放内存，Value会存放在swap区，格式：maxmemory <bytes>　。
#
# maxmemory <bytes>


# 当内存使用达到最大值时，redis使用的清除策略。有以下几种可以选择：
#     1：volatile-lru     ->   利用LRU算法移除设置了过期时间的key (LRU:最近最少使用 Least Recently Used ) 
#     2：allkeys-lru      ->   利用LRU算法移除任何key 
#     3：volatile-lfu     ->   利用LFU算法移除设置了过期时间的key (LFU:最不经常使用 Least Frequently Used )
#	  4：allkeys-lfu      ->   利用LFU算法移除任何key
#     3）volatile-random  ->   移除设置了过期时间的随机key 
#     4）allkeys-random   ->   移除随机key
#     5）volatile-ttl     ->   移除即将过期的key(minor TTL) 
#     6）noeviction  noeviction  不移除任何key，只是返回一个写错误 。默认选项
#
# maxmemory-policy noeviction


# LRU和minimal TTL算法都不是精准的算法，但是相对精确的算法(为了节省内存)，随意你可以选择样本大小进行检测。
# redis默认选择5个样本进行检测，你可以通过maxmemory-samples进行设置样本数。
#
# maxmemory-samples 5


# 是否开启salve的最大内存
# 
# replica-ignore-maxmemory yes
```

### LAZY FREEING

```shell
# 当使用DEL命令时，会停止执行新的命令，删除key对应的value是个小对象，速度会很快，如果是个大对象，则会阻塞比较长时间。
# 如下配置是否以非阻塞方式释放内存

lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no

```

### APPEND ONLY MODE

```shell
# Please check http://redis.io/topics/persistence for more information.
# 是否启用aof持久化方式 。即是否在每次更新操作后进行日志记录，默认配置是no，
# 即采用异步方式把数据写入到磁盘，如果不开启，可能会在断电时导致部分数据丢失。
# AOF 和 RDB 可以同时开启。如果AOF开启了，恢复时会选用AOF
#
appendonly no


# 追加模式的文件名，默认为appendonly.aof
#
appendfilename "appendonly.aof"


# aof文件刷新的频率。有三种：推荐使用 everysec
#   1：no 依靠OS进行刷新，redis不主动刷新AOF，这样最快，但安全性就差。
#   2: always 每提交一个修改命令都调用fsync刷新到AOF文件，非常非常慢，但也非常安全。
#   3：everysec 每秒钟都调用fsync刷新到AOF文件，很快，但可能会丢失一秒以内的数据。
#
# appendfsync always
appendfsync everysec
# appendfsync no


# 指定是否在后台aof文件rewrite期间调用fsync，默认为no，表示要调用fsync（无论后台是否有子进程在刷盘）。
# Redis在后台写RDB文件或重写AOF文件期间会存在大量磁盘IO，此时，在某些linux系统中，调用fsync可能会阻塞。
#
no-appendfsync-on-rewrite no


# 当AOF文件增长到一定大小的时候Redis能够调用BGREWRITEAOF对日志文件进行重写。当AOF文件大小的增长率大于该配置项时自动开启重写。
auto-aof-rewrite-percentage 100
# 当AOF文件增长到一定大小的时候Redis能够调用BGREWRITEAOF对日志文件进行重写 。当AOF文件大小大于该配置项时自动开启重写。
auto-aof-rewrite-min-size 64mb


# redis在启动时可以加载被截断的AOF文件，而不需要先执行redis-check-aof工具。
aof-load-truncated yes


# 加载redis时，可以识别AOF文件以“redis”开头字符串并加载带前缀的RDB文件，然后继续加载AOF尾巴
aof-use-rdb-preamble yes
```
### REDIS CLUSTER

```
# 集群开关，默认是不开启集群模式
#
# cluster-enabled yes


# 集群配置文件的名称，每个节点都有一个集群相关的配置文件，持久化保存集群的信息。这个文件并不需要手动
# 配置，这个配置文件由Redis生成并更新，每个Redis集群节点需要一个单独的配置文件，请确保与实例运行的系
# 统中配置文件名称不冲突
# cluster-config-file nodes-6379.conf


# 节点互连超时的阀值。集群节点超时毫秒数
#
# cluster-node-timeout 15000

# cluster-replica-validity-factor 10


# cluster-migration-barrier 1

# cluster-require-full-coverage yes

# cluster-replica-no-failover no

# cluster-allow-reads-when-down no

```

### CLUSTER DOCKER/NAT support

```shell
# In certain deployments, Redis Cluster nodes address discovery fails, because
# addresses are NAT-ted or because ports are forwarded (the typical case is
# Docker and other containers).
#
# In order to make Redis Cluster working in such environments, a static
# configuration where each node knows its public address is needed. The
# following two options are used for this scope, and are:
#
# * cluster-announce-ip
# * cluster-announce-port
# * cluster-announce-bus-port
#
# Each instruct the node about its address, client port, and cluster message
# bus port. The information is then published in the header of the bus packets
# so that other nodes will be able to correctly map the address of the node
# publishing the information.
#
# If the above options are not used, the normal Redis Cluster auto-detection
# will be used instead.
#
# Note that when remapped, the bus port may not be at the fixed offset of
# clients port + 10000, so you can specify any port and bus-port depending
# on how they get remapped. If the bus-port is not set, a fixed offset of
# 10000 will be used as usually.
#
# Example:
#
# cluster-announce-ip 10.1.1.5
# cluster-announce-port 6379
# cluster-announce-bus-port 6380
```

