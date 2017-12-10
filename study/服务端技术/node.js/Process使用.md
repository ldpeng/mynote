# process
process对象是Node的一个全局对象，提供当前Node进程的信息。它可以在脚本的任意位置使用，不需要通过require方法加载。

## process的一些基本属性

- process.argv  返回当前进程的命令行参数数组
    + argv属性返回一个数组，由命令行执行脚本时的各个参数组成。它的第一个参数总是node可执行文件的绝对路径，第二个是脚本的绝对路径，其余成员是脚本文件的参数
    + 一般在argv中，真正的用户输入的参数是从process.argv[2]开始的。即：`process.argv.slice(2)`
- process.env   返回一个对象，成员为当前控制台的环境变量
- process.pid   返回当前进程的进程号
- process.platform  返回当前的操作系统平台，比如win32
- process.version   返回Node的版本号，如4.3.1

## process的一些主要属性

- stdout（standard output）stdout属性指向标准输出。它的write方法等同于console.log，可以用在标准输出向用户显示内容。
- stdin（standard input）stdin表示标准输入
- stderr（standard error）

## process的一些方法

- process.exit()    该方法可以用来退出当前进程
- process.nextTick()    将任务放到当前一轮事件循环的尾部。
  
```JavaScript
process.nextTick(function(){
    console.log('哈哈');
});
```

上面代码可以用`setTimeout(function(){},0)`改写，效果接近，但是原理不同

```JavaScript
setTimeout(function(){
    console.log('哈哈');
},0);
```

- `setTimeout(function(){},0)`是将任务放到下一轮事件循环的头部，因此nextTick会比它先执行。
- `nextTick`的效率更高，因为不用检查是否到了指定时间。

- process.kill()    该方法可以通过指定一个进程id，终止该进程

## process的一些事件

- exit事件。当进程退出时，会触发exit事件

```JavaScript
process.on('exit', function() {
    console.log('程序退出了');
})
```

- uncaughtException事件。当Node.js进程抛出一个没有被捕获的错误时，会触发`uncaughtException`事件