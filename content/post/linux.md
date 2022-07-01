---
title: "服务器环境部署"
date: 2022-07-01
lastmod: 
draft: false
tags: ['centos8.2','container']
author: yuhh

---

> 基于centos8.2 的常用系统服务部署

## 系统源替换

[阿里云镜像站](https://developer.aliyun.com/mirror/)

```shell
#功能 CentOS 8 EOL 切换到新的官方源
#说明：CentOS8 操作系统版本结束了生命周期，Linux社区不再维护该操作系统版本。（Status code:404）

# 设置环境变量
_DATE=`date +%Y%m%d`
_BAK="/etc/yum.repos.d/"$_DATE
# 备份源
echo "step1: 正在备份源... "
mkdir -p $_BAK
sudo rename '.repo' '.repo.bak' /etc/yum.repos.d/*.repo
mv /etc/yum.repos.d/*.bak $_BAK

# 替换源地址
echo "step2: 替换repo文件中的链接..."
# centos 社区 官方源新地址
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=https://vault.centos.org|g' /etc/yum.repos.d/CentOS


# epel (Extra Packages for Enterprise Linux) 阿里源
rm -f epel*
sudo yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm
sudo sed -i 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
sudo sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*

# 重建缓存
echo "step3: 重新创建缓存...."
sudo yum clean all && yum makecache
sudo dnf -y install git
echo "all done..."
```

## 更好的Shell

[ohmyshell](https://ohmyz.sh)

### Zsh?
**Oh My Zsh** 是 **Zsh** 的框架，Z shell。  
- *为了使**Oh My Zsh**工作，必须安装Zsh*. 
    - 请运行 zsh --version 来确认.
    - 预期结果: zsh 5.0.8 或者其它版本
- *此外，Zsh 应设置为默认 shell*.
    - 请运行 echo $SHELL 在一个终端窗口中来确认.
    - 预期结果 : /usr/bin/zsh 或者类似

### Centos/RHEL
```shell
$ dnf -y install zsh
```
### HTTPS

require：科学上网

```shell
$ #curl
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
$ #wget
$ sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
$ #fecth
$ sh -c "$(fetch -o - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
NOTE：安装程序会将现有的 **.zshrc** 文件重命名为 **.zshrc.pre-oh-my-zsh**。
### Shell切换

```shell
$ chsh -s /usr/bin/zsh
$ zsh --version # 验证安装
zsh 5.5.1 (x86_64-redhat-linux-gnu)
$ echo $SHELL
/usr/bin/zsh
```

### 安装 Ohmyzsh 框架

#### curl or wget

```shell
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"# location in ~/.oh-my-zsh
$ vim ~/.zshrc # 配置主题和插件
```

#### .zshrc配置文件
<details>
    <summary>查看代码</summary>
        <pre>
            <code>
#If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH

#Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#Set name of the theme to load --- if set to "random", it will
#load a random theme each time oh-my-zsh is loaded, in which case,
#to know which specific one was loaded, run: echo $RANDOM_THEME
#See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cloud"

#Set list of themes to pick from when loading at random
#Setting this variable when ZSH_THEME=random will cause zsh to load
#a theme from this variable instead of looking in $ZSH/themes/
#If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

#Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

#Uncomment the following line to use hyphen-insensitive completion.
#Case-sensitive completion must be off. _ and - will be interchangeable.
#HYPHEN_INSENSITIVE="true"

#Uncomment one of the following lines to change the auto-update behavior
#zstyle ':omz:update' mode disabled  # disable automatic updates
#zstyle ':omz:update' mode auto      # update automatically without asking
#zstyle ':omz:update' mode reminder  # just remind me to update when it's time

#Uncomment the following line to change how often to auto-update (in days).
#zstyle ':omz:update' frequency 13

#Uncomment the following line if pasting URLs and other text is messed up.
#DISABLE_MAGIC_FUNCTIONS="true"

#Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

#Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

#Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

#Uncomment the following line to display red dots whilst waiting for completion.
#You can also set it to another string to have that shown instead of the default red dots.
#e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
#Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
#COMPLETION_WAITING_DOTS="true"

#Uncomment the following line if you want to disable marking untracked files
#under VCS as dirty. This makes repository status check for large repositories
#much, much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

#Uncomment the following line if you want to change the command execution time
#stamp shown in the history command output.
#You can set one of the optional three formats:
#"mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#or set a custom format using the strftime function format specifications,
#see 'man strftime' for details.
#HIST_STAMPS="mm/dd/yyyy"

#Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder

#Which plugins would you like to load?
#Standard plugins can be found in $ZSH/plugins/
#Custom plugins may be added to $ZSH_CUSTOM/plugins/
#Example format: plugins=(rails git textmate ruby lighthouse)
#Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
#User configuration

#export MANPATH="/usr/local/man:$MANPATH"

#You may need to manually set your language environment
#export LANG=en_US.UTF-8

#Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#export EDITOR='vim'
#else
#export EDITOR='mvim'
#fi

#Compilation flags
#export ARCHFLAGS="-arch x86_64"

#Set personal aliases, overriding those provided by oh-my-zsh libs,
#plugins, and themes. Aliases can be placed here, though oh-my-zsh
#users are encouraged to define aliases within the ZSH_CUSTOM folder.
#For a full list of active aliases, run `alias`.
#
#Example aliases
#alias zshconfig="mate ~/.zshrc"
#alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias cls="clear && clear"
            </code>
        </pre>
</details>


## Neovim 编辑器
[官方文档](https://neovim.io/doc)

### CentOS8/RHEL 8
Neovim is available through EPEL (Extra Packages for Enterprise Linux)
```shell
$ dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
$ dnf install -y neovim python3-neovim
```
### Neovim 的基本稳定 IDE 配置

[github](https://github.com/LunarVim/nvim-basic-ide)

#### Install Neovim 0.7
```shell
$ git clone https://github.com/neovim/neovim.git
$ cd neovim
$ git checkout release-0.7
$ make CMAKE_BUILD_TYPE=Release
$ sudo make install
```
#### Install the config
```shell
$ git clone https://github.com/LunarVim/nvim-basic-ide.git ~/.config/nvim
```
then：运行nvim 命令等待插件安装加载完成

#### Get healthy

进行配置环境检查

```shell
:checkhealth
```

你可能需要安装以下编程语言接口支持：

- Neovim python support

```shell
$ pip install pynvim
```

- Neovim node  support

```shell
$ npm i -g neovim
```

## 编程语言

### python3

一般情况下python3 在centos8上已经安装有，因此进行备份即可。
- 备份python依赖库

```shell
☁  ~  pip freeze > ./requirements.txt # 依赖备份
☁  ~  pip install -r ./requirements.txt # 依赖回滚

# 如果提示找不到命令
☁  ~  which pip3
/usr/bin/pip3
☁  ~  ln -s /usr/bin/pip3 /usr/bin/pip
ln: failed to create symbolic link '/usr/bin/pip': File exists
```

### nodejs

#### 安装 NVM 版本管理工具

[github](https://github.com/nvm-sh/nvm)

要安装或更新nvm，您应该运行安装脚本。为此，您可以手动下载并运行脚本，也可以使用以下 cURL 或 Wget 命令：

```shell
☁  ~  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
☁  ~  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```
运行上述任一命令会下载脚本并运行它。该脚本将 nvm 存储库克隆到 ，并尝试将以下代码段中的源代码行添加到正确的配置文件（、、、或 ）。~/.nvm ~/.bash_profile ~/.zshrc ~/.profile ~/.bashrc

**验证**
```shell
☁  ~  nvm -version

Node Version Manager (v0.39.1)
```

#### 使用 NVM 安装 node-lts

```shell
☁  ~  nvm install --lts
Installing latest LTS version.
v16.15.1 is already installed.
Now using node v16.15.1 (npm v8.12.2)

☁  ~  npm -v # 验证安装
8.12.2

☁  ~  npm -g install typescript --registry=http://registry.npmmirror.com # 使用代理安装 typescript 支持

added 1 package in 7s
☁  ~

```

### golang

[官方地址](https://go.dev/doc/install)

#### 安装[稳定版本](https://go.dev/dl/)


1. 下载。并删除以前已经安装过的goland.

    by deleting the /usr/local/go folder (if it exists), then extract the archive you just downloaded into /usr/local, creating a fresh Go tree in /usr/local/go:

```shell
☁  ~ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz # 源码安装
☁  ~ dnf autoremove golang # 使用包管理工具
```
2. 将 /usr/local/go/bin 添加到环境变量PATH

    You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):

```shell
☁  ~ export PATH=$PATH:/usr/local/go/bin
```  
    by deleting the /usr/local/go folder (if it exists), then extract the archive you just downloaded into /usr/local, creating a fresh Go tree in /usr/local/go:
    
3. 验证配置

```shell
☁  ~  go version
go version go1.18.3 linux/amd64
```

4. 设置golang国内代理
```shell
☁  ~  go env -w GOPROXY=https://mirrors.aliyun.com/goproxy
☁  ~  go env # 使用go env 命令来查看当前golang环境配置
```

## 容器技术

容器技术:有效的将单个操作系统的资源划分到孤立的组中，以便更好的在孤立的组之间平衡有冲突的资源使用需求，这种技术就是容器技术。

容器技术已经引起了业内的广泛关注，有充分的证据表明，容器技术能够大大提升工作效率。

虚拟化技术已经成为一种被大家广泛认可的服务器资源共享方式，它可以在按需构建操作系统实例的过程当中为系统管理员提供极大的灵活性。由于hypervisor虚拟化技术仍然存在一些性能和资源使用效率方面的问题，因此出现了一种称为容器（Container）的新型虚拟化技术来帮助解决这些问题。

    容器技术的出现是为了解决多操作系统/应用程序堆栈的问题：

- 目前开源社区中主流的容器技术有docker、containerd和runc等，这里主要学习docker和containerd的部署。  
- 容器编码工具k8s放弃docker。k8s不能直接与docker通信，只能与 CRI 运行时通信，要与 Docker 通信，就必须使用桥接服务(dockershim)，k8s要与docker通信是通过节点代理Kubelet的Dockershim（k8s社区维护的）将请求转发给管理容器的 Docker 服务。Docker 本身不兼容 CRI 接口，官方并没有实现 CRI 的打算，同时也不支持容器的一些新需求，社区想要摆脱Dockershim的高维护成本。
- containerd 可以作为k8s容器运行时。同时兼容使用Docker打包的镜像。

### docker

[官方文档](https://docs.docker.com/get-started/overview/)

#### 系统要求

要安装 Docker 引擎，您需要 CentOS 7、CentOS 8 （stream） 或 CentOS 9 （stream） 的維護版本。不支持或测试存档版本。  
必须启用存储库。默认情况下，此存储库处于启用状态，但如果已禁用它，则需要重新启用它。centos-extras  
建议使用存储驱动程序。overlay2

#### Uninstall old versions

卸载旧版本，安装 [docker-ce](https://docs.docker.com/engine/install/centos/)
```shell
☁  ~  sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

```

#### Install using the repository

使用docker提供的源安装。需要先安装yum-utils工具，然后使用yum-config-manager添加源。
```shell
☁  ~  sudo yum install -y yum-utils
☁  ~  sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

#### Install Docker Engine

安装最新版本的 Docker 引擎、容器和 Docker Compose，或转到下一步以安装特定版本：

```shell
☁  ~  sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

```

#### 根据实际需求修改服务配置

```shell
# ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --data-root=/data/docker
vim /usr/lib/systemd/system/docker.service # 在docker 的配置文件中添加"--data=磁盘路径"将数据保存到服务器挂载硬盘上

```

#### 服务管理

```shell
$ sudo systemctl daemon-reload # 重新加载系统配置
$ sudo systemctl start docker # 启动服务
$ sudo systemctl stop docker # 停止服务
$ sudo systemctl restart docker # 重启服务
$ sudo docker run hello-world # 验证
```

### docker-compose

1. 要下载并安装撰写 CLI 插件，请运行：


```shell
$ DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
$ mkdir -p $DOCKER_CONFIG/cli-plugins
$ curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```

2. 要下载并安装撰写 CLI 插件，请运行：

```shell
$  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
```
    或者，如果您选择为所有用户安装 Compose：
    
```shell
$ sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```

3. 测试安装。
```shell
$ sudo docker-compose  version
Docker Compose version v2.6.1
```

### containerd

[github](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)

