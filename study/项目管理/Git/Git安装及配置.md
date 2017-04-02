# 在Linux上安装Git

首先，你可以试着输入git，看看系统有没有安装Git：

```
git
The program 'git' is currently not installed. You can install it by typing:
sudo apt-get install git
```

* 像上面的命令，有很多Linux会友好地告诉你Git没有安装，还会告诉你如何安装Git。

* 如果你碰巧用Debian或Ubuntu Linux，通过一条sudo apt-get install git就可以直接完成Git的安装，非常简单。

* 老一点的Debian或Ubuntu Linux，要把命令改为sudo apt-get install git-core，因为以前有个软件也叫GIT（GNU Interactive Tools），结果Git就只能叫git-core了。由于Git名气实在太大，后来就把GNU Interactive Tools改成gnuit，git-core正式改为git。

* 如果是其他Linux版本，可以直接通过源码安装。先从Git官网下载源码，然后解压，依次输入：./config，make，sudo make install这几个命令安装就好了。

# 在Mac OS X上安装Git

如果你正在使用Mac做开发，有两种安装Git的方法。

1. 安装homebrew，然后通过homebrew安装Git，具体方法请参考homebrew的文档：http://brew.sh/。

2. 第二种方法更简单，也是推荐的方法，就是直接从AppStore安装Xcode，Xcode集成了Git，不过默认没有安装，你需要运行Xcode，选择菜单“Xcode”->“Preferences”，在弹出窗口中找到“Downloads”，选择“Command Line Tools”，点“Install”就可以完成安装了。

# 在Windows上安装Git

Windows下比较简单，上网下一个exe（Git for Windows）的安装包安装即可。

# 配置Git

安装完成后，还需要最后一步设置，在命令行输入：

```
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
```

因为Git是分布式版本控制系统，所以，每个机器都必须自报家门：你的名字和Email地址。

**注意git config命令的--global参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址**。