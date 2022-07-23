---
title: "git"
date: 2022-07-24
lastmod: 
draft: false
tags: ['git']
author: yuhh

---

> 分布式版本管理工具Git

## GIT 的安装

```pwsh
➜ scoop install git # 安装
```

## 常用操作

```pwsh

# 1. 用户信息设置

➜ git config --global user.name "yuhh" # 设置提交的用户名
➜ git config --global user.email yuhh@example.com  # 设置用户邮箱
➜ git config --global --unset user.name # 移除设置
➜ git config --list # 显示当前仓库下的配置
➜ git config --global  -l # 显示全局配置

# 2. 设置默认文本编辑器

➜ git config --global core.editor code 

# 3. 缓存用户信息

# 清除配置中纪录的用户名和密码，下次提交代码时会让重新输入账号密码
➜ git config --system --unset credential.helper 
# 清除git缓存中的用户名的密码
➜ git credential-manager uninstall 
# 缓存用户凭据15分钟
➜  git config --global credential.helper cache
# 执行命令之后，再次pull或push时会缓存输入的用户名和密码(全局设置)
➜ git config --global credential.helper store --file ~/.git-credentials
➜ git config credential.helper store # 当前仓库下
```
+ 默认所有都不缓存。 每一次连接都会询问你的用户名和密码。

+ “cache” 模式会将凭证存放在内存中一段时间。 密码永远不会被存储在磁盘中，并且在15分钟后从内存中清除。

+ “store” 模式会将凭证用明文的形式存放在磁盘中，并且永不过期。 这意味着除非你修改了你在 Git 服务器上的密码，否则你永远不需要再次输入你的凭证信息。 这种方式的缺点是你的密码是用明文的方式存放在你的 home 目录下。

+ 如果你使用的是 Mac，Git 还有一种 “osxkeychain” 模式，它会将凭证缓存到你系统用户的钥匙串中。 这种方式将凭证存放在磁盘中，并且永不过期，但是是被加密的，这种加密方式与存放 HTTPS 凭证以及 Safari 的自动填写是相同的。

+ 如果你使用的是 Windows，你可以安装一个叫做 “Git Credential Manager for Windows” 的辅助工具。 这和上面说的 “osxkeychain” 十分类似，但是是使用 Windows Credential Store 来控制敏感信息。 可以在 https://github.com/Microsoft/Git-Credential-Manager-for-Windows 下载。

## 深入学习

[中文文档](https://git-scm.com/book/zh/v2)