# 执行js代码

- 在命令行中，输入node回车。会进入node的REPL模式，可以输入js代码，类似浏览器的控制台，但此时没有dom了。
- node 文件名。可执行js文件

# 全局对象global

- 在REPL环境中，默认的所有的变量、函数、对象都会默认的挂载到global对象上
- 在文件中，声明的变量，如果你没有显示的指定，那么它是属于当前文件的

## __dirname

__dirname可以获取当前文件所属的目录的路径

## __filename

可以获取当前文件的绝对路径

# 模块加载机制

- 一个文件代表一个模块。类似java的类。
- 使用require，引入别的模块。类似java的import

```JavaScript
var http = require('http');
```

**同一个模块，如果加载多次（编写多个require），最终只会执行一次**

## 模块间通过exports进行交互

- 在模块当中暴露变量、函数、或者对象的时候，可以直接通过exports和module.exports 的方式来导出暴露
- 在一个模块中，exports和module.exports实际是是一个东西
- 实际上，require()方法调用过后最终得到的是module.exports对象
- 当返回值不是对象时，需要通过module.exports定义

```JavaScript
//foo.js代码
var name = 'Jack';

module.exports = function hello() {
  console.log('hello');
};

//exports.js代码
var fooModule = require('./foo.js');
console.log(fooModule.foo);
```

加载模块时，可以不包含扩展名。Node会按照`.js、.node、.json`的次序补足扩展名，依次尝试

- 路径.js     以后自己在加载js文件模块的时候，就省略掉.js后缀就可以了
- 路径.node   后缀为node的文件是c/c++写的一些扩展模块
- 路径.json   如果是加载json文件模块，最好加上后缀.json，能稍微的提高一点加载的速度
    + .json文件最终Node.js也是通过fs读文件的形式读取出来的，然后通过JSON.parse()转换成一个对象

Node.js会通过同步阻塞的方式看这个路径是否存在。依次尝试，直到找到为止，如果找不到，报错。

### 模拟require方法

```JavaScript
// 定义一个函数，该函数需要接收一个参数，参数暂时就解析路径就可以了
function myRequire(path) {
  function Module() {
    this.exports = {};
  }

  // fs模块是Node.js原生提供的一个用于文件操作的一个模块
  var fs = require('fs');
  // 表示读取一个文件，得到文件中的内容， 实际上就是源代码字符串,是string类型
  var sourceCode = fs.readFileSync(path, 'utf8');

  // 头尾包装
  var packSourceCode = '(function(exports,module){ '+sourceCode+' return module.exports; })';

  var packObj = eval(packSourceCode);

  // 实例化一个Module 有一个exports属性
  var module = new Module();

  var obj = packObj(module.exports,module);

  return obj;
}
```

## 核心模块

核心模块是Node.js原生提供的。加载核心模块的时候，不需要传入路径，因为Node.js已经将核心模块的文件代码编译到了二进制的可执行文件中了。**在加载的过程中，原生的核心模块的优先级是最高的**。

# 包

## package.json

包的描述文件。package.json文件内部就是一个JSON对象，该对象的每一个成员就是当前项目的一项设置，
比如name就是项目名称，version就是项目的版本号

### start属性

可以设置npm start所执行的入口文件

只要，在命令台执行npm start默认找scripts下的start属性，然后执行它的值

```javaScript
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start":"node index.js"
  },
```

### dependencies属性

定义所依赖的包：包名：“版本号”

版本号：
- \>+版本号    下载大于某个版本号，npm会下最新版
- <+版本号 下载小于某个版本号，npm会下小于这个版本号最新版
- <= 小于等于，一定会下你写的这个版本，除非没有你写的这个版本
- \>= 大于等于，下载最新版
- *、" "、X 任意 npm会给你下最新版
- ~+版本号  会去下约等于这个版本的最新版，在大版本不变的情况下下一个比较新的版本
- ^+版本号  不跃迁版本下载。如：^2.1.0 npm会下载大版本不变，去下载2.x.x版本里的最近版

[参考文献 package.json全字段解析](http://blog.csdn.net/woxueliuyun/article/details/39294375)

## 包的加载机制

通过require加载一个包。如：

```JavaScript
var cal = require('cal');
```

- Node.js中，有一种默认的路径加载规则，存储在**module.paths**属性中（每个模块都有自己的module对象）
- Node.js根据module.paths中的第一个元素，即当前路径拼上node_modules/模块名。如：c:\\Users\\LDP\\Desktop\\code\\node_modules\\cal
    + 在该目录下找一个叫做package.json的文件
        * 如果找到：通过JSON.parse的方式拿到该对象
        * 获取main属性，如果main属性中的值可以拼接为一个完整的路径并且是正确的文件
        * 直接加载该模块，拿到module.exports
    + 如果找不到package.json文件或者找到了但是里面没有main属性或者main属性的值是错误的。
        * 在该目录下依次找 index.js、index.node、index.json 文件
- 按照module.paths中的路径规则，逐级查找，重复上面的步骤
- 如果最后找到了最后一个路径还是找不到，报错。

![模块加载查找策略](node.js使用附件/模块加载查找策略.jpg)

## npm的使用

- npm init

执行npm init命令，根据提示一项一项输入，最终会初始化一个node.js包目录。

添加-y参数，代表全部使用默认选项，不用再输入

- npm install 包名

当执行npm install的时候，它会自动跑到npm的网站，然后找到该包的github地址，找到之后，下载这个压缩包，然后在执行npm install的当前目录下找一个叫做node_modules目录。如果找到，直接解压这个压缩包，到node_modules目录下；如果找不到，则新建一个node_modules目录，解压到该目录。

- npm install

当执行npm install的时候，会自动在当前目录中查找package.json文件
如果找到，找里面的 dependencies 字段，安装该字段中所有依赖的项

- npm install --save 包名

如：npm install --save express。

安装依赖的时候同时往package.json文件中，dependencies字段中添加依赖配置

- npm install -save-dev 包名

安装依赖的时候同时往package.json文件中，devDependencies字段中添加依赖配置
