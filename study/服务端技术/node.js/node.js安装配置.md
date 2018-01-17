# 使用nvm安装（Node Version Management）

## 安装nvm

### window环境安装

1. [下载nvm-noinstall.zip](https://github.com/coreybutler/nvm-windows/releases)
2. 解压，建议放到C盘，如：C:\dev\nvm
3. 在安装目录下创建setting.txt文件，内容如下：

```txt
root: C:\dev\nvm
path: C:\dev\nodejs
arch: 64
proxy: none
```

其中root为nvm安装目录，path为当前运行node的版本的快捷方式

4. 配置环境变量

```
NVM_HOME=C:\dev\nvm
NVM_SYMLINK=C:\dev\nodejs
Path=%NVM_HOME%;%NVM_SYMLINK%
```

5. 打开命令窗口，输入nvm命令，可验证是否安装成功

### mac环境安装

1. 命令窗口中执行命令：

```shell
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
```

2. 复制以下内容到etc/bashrc（可以是其他文件）中

```shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
```

## nvm的使用

- 查看nvm中所有已安装的Node.js版本

```
nvm list
nvm ls  ls是list的别名
```

- 使用和切换node版本

```
nvm use 版本号
nvm use 版本号 32	32的操作系统使用这种方式切换node版本
```

- 安装Node版本

```
nvm install 版本号
nvm install 版本号 32
```

- 卸载指定版本

```
nvm uninstall 版本号
```

- 查看远程服务器版本（官方node version list）

```
nvm ls-remote
```

- 安装最新稳定版

```
nvm install --lts
```

## npm配置

- npm root -g

查看当前全部包安装路径

- 修改全局包安装路径（Mac中配置无效）

1. npm config set prefix "C:\dev\nvm\npm"
2. 添加path环境变量
    NPM_HOME : C:\dev\nvm\npm
    ;%NPM_HOME%;

## nrm安装

安装nrm通过命令npm install -g nrm安装即可。

- nrm ls

列出所有已注册的镜像地址。其中前面带星号的是当前正在使用的镜像地址

- nrm use cnpm

使用cnpm对应的地址
