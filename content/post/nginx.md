---
title: "反向代理服务器"
date: 2022-07-03
lastmod: 
draft: false
tags: ['nginx']
author: yuhh

---

> 反向代理服务器nginx

## option1 传统方式部署

### 安装nginx

```shell
☁  ~  dnf -y install nginx # 使用centos8 的仓库安装
☁  ~  nginx -v # 验证
nginx version: nginx/1.14.1

```

### 编辑配置文件

```shell
☁  ~  nvim /etc/nginx/nginx.conf # 在include /etc/nginx/conf.d/*.conf; ,目录下内置自己的反向代理配置

```
<details>
    <summary>nginx-433.conf</summary>
    <pre>
        <code>
server {
        listen       443 ssl; #配置HTTPS的默认访问端口为443。如果在此处未配置HTTPS的默认访问端口，可能会导致Nginx无法启动。
        server_name  www.alkaid.club; #修改为您证书绑定的域名。
        ssl_certificate      /etc/nginx/cert/server.crt; #替换成您的证书文件的路径。
        ssl_certificate_key  /etc/nginx/cert/server.key; #替换成您的私钥文件的路径。
        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;
        ssl_ciphers  HIGH:!aNULL:!MD5; #加密套件。
        ssl_prefer_server_ciphers  on;
        location / {
                proxy_pass  http://localhost:8080;
                proxy_set_header Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                # WebSocket proxying
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_redirect off;
                proxy_read_timeout 120s;
        }
}
        </code>
    </pre>
</details>

## option2 容器化部署

### nginx镜像下载

```shell
☁  ~ nerdctl pull nginx # 下载
☁  ~ nerdctl images # 查看下载
```
![](/images/nginx.jpg)
### 编写 compose 配置文件

```shell
☁  ~  touch docker-compose.yml
☁  ~  mkdir -p /data/nginx/conf.d
☁  ~  mkdir -p /data/nginx/html
☁  ~  mkdir -p /data/nginx/log
☁  ~  nvim docker-compose.yml # 加入下面内容
```
<details>
    <summary>docker-compose.yml</summary>
    <pre>
        <code>
services:
  nginx:
    container_name: nginx
    image:  nginx:latest
    ports:
      - 81:80
    volumes:
      - "/data/nginx/conf.d:/etc/nginx/conf.d"    # 配置文件
      - "/data/nginx/html:/usr/share/nginx/html"  # 前端工程
      - "/data/nginx/log:/var/log/nginx"          # 日志文件
        </code>
    </pre>
</details>

#### 容器管理
```
☁  ~  nerdctl compose -f ./docker-compose.yml up -d # 启动服务
INFO[0000] Creating network root_default
WARN[0000] Ignoring: volume: Bind: [CreateHostPath]
WARN[0000] Ignoring: volume: Bind: [CreateHostPath]
WARN[0000] Ignoring: volume: Bind: [CreateHostPath]
INFO[0000] Ensuring image nginx:latest
INFO[0000] Creating container nginx
☁  ~  nerdctl ps # 查看容器运行
☁  ~  nerdctl exec -it nginx bash

☁  ~  nerdctl compose down # 停止并移除容器(如果容器只是更新配置使用第一条命令 up -d )
INFO[0000] Removing container nginx
INFO[0000] Removing network root_default

```

### nginx 配置

1. 前端静态页面
    写入到/data/nginx/html路径下
2. nginx 配置
    将配置写入容器的映射外部宿主机的路径下，例如这里的
    /data/nginx/html
3. 日志查看
```shell
☁  ~  nerdctl logs -f nginx 
```
或者在/data/nginx/log 通过 tail -f filenanme.log 查看