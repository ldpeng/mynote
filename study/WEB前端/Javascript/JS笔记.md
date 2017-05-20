# 加号的特殊性

- 如果用在字符串之间，结果是连接
- 如果在数字之间，结果是相加
- 如果其中给是字符串，结果是连接

# Math对象常用方法
- Math.pow(a,b);    得到a的b次方
- Math.round(a);    四舍五入
- Math.ceil(a); 向上取整
- Math.floor(a);    向下取整
- Math.random();    取随机数据
- Math.max(a,b,c);  取三个数中的最大值
- Math.min(a,b,c);  得到abc中最小的值。

# == 与 ===

- ==判断的仅仅只是数据的内容，没有判断数据的类型
- ===既会关心内容也会关心类型
    - 注意：有一个比较特殊的数字NaN,它特殊到自己都不等于（== , ===）自己

# boolean在内存中存储的格式

所有的数据是存储在内存，boolean在存储的时候有个特点：**会将true转成1，会将false转成0**;所以用”false”字符串来与boolean类型的false进行的时候，是拿”false”与0在进行对比

# 强制转换

## 转Number

1. Number(字符串/boolean)
    1. 如果转换的内容可以转成数字，那么就直接返回这个内容对应的数字。
    2. 如果不可以转换那么返回NaN.
    3. 如果在内容中出现小数，那么小数会保留。
    4. 如果内容为空，那么转换成0;

2. parseInt()将内容转成Number
    1. 如果转换的内容可以转成数字，那么就直接返回这个内容对应的数字。
    2. 如果不可以转换那么返回NaN.
    3. 如果带有小数，那么会去掉小数，**而不是四舍五入**。
    4. 如果第一个字符是数字，则继续解析直至字符串解析完毕或者遇到一个非数字符号为止.

3. parseFloat():转数字

与parseInt一样，唯一区别是可以保留小数。

## 转字符串

1. +""
2. toString()
3. String()

## Boolean转换

1. !!num
2. Boolean()


- 除了false、0、""、NaN、Undefined、null在转换的时候会转成false以外，其它的都会转成true.(包括”false”).
- 参与数值运算的时候true当作1，false当作0
    - 1 + true = 2
    - 1 + false = 1

# arguments对象
- arguments对象的长度是由实参个数而不是形参个数决定的
- 这个单词只在函数 内使用，而且是正在执行的函数。

```
// 尽量要求形参和实参相互匹配
function fn(a,b) {
    //  console.log(fn.length); 返回的是 函数的 形参的个数
    // console.log(arguments.length);  返回的是正在执行的函数的 实参的个数
    // arguments  里面存放的是 [1,2]  
    if(fn.length == arguments.length) {
        console.log(a+b);
    } else {
        console.error("对不起，参数不匹配，参数正确的个数应该是" + fn.length);
    }
}

fn(1,2);
```
## arguments.callee（递归）
arguments.callee 返回正被执行的Function对象。**在使用函数递归调用时推荐使用arguments.callee代替函数名本身**。

# 检测用户表单输入事件
 - oninput 检测表单输入事件，光标进入是不触发事件的，当用户输入了内容的时候，才会触发事件。

```
txt.oninput = function() {
    //  alert(11);
    if(txt.value == "") // 如果为空就显示
    {
        text.style.display = "block";
    }
    else {   // 否则就隐藏
        text.style.display = "none";
    }
}
```

- ie 678 不支持oninput，支持的是：onpropertychange事件 

**综合兼容性写法：txt.oninput =  txt.onpropertychange =  function(){}**

# Array对象

- push()方法可向数组的末尾添加一个或多个元素，并返回新的数组长度。
- pop()方法移除最后一个元素，返回的是，所删除的元素。
- unshift()方法可向数组的开头添加一个或更多元素，并返回数组新的长度。
- shift()方法用于把数组的第一个元素从其中删除，并返回第一个元素的值。
- concat()方法用于连接两个或多个数组。它不会改变现有的数组，而仅仅会返回被连接数组的一个副本  
- join(separator) 方法将数组各个元素是通过指定的分隔符进行连接成为一个字符串。
    - 参数 separator可选的，指定要使用的分隔符。**如果省略该参数，则使用逗号作为分隔符**。

# String对象
- split(separator,howmany)方法用于把一个字符串分割成字符串数组。
    - 参数separator可选，指定要使用的分隔符。如果省略该参数，则使用逗号作为分隔符。
    - howmany可选，该参数可指定返回的数组的最大长度。

# Date对象常用的方法
- getDate() 获取日 1-31       
- getDay() 获取星期 0-6      
- getMonth()    获取月 0-11 
- getFullYear() 获取完整年份（浏览器都支持）
- getHours()   获取小时 0-23
- getMinutes()  获取分钟 0-59
- getSeconds()  获取秒  0-59
- getMilliseconds() 获取毫秒1s = 1000ms
- getTime() 返回累计毫秒数(从1970/1/1午夜)  时间戳

# offset 家族 

offset是偏移的意思，这个家族主要用来检测盒子的大小和位置。

## offsetWidth和offsetHeight

```
offsetWidth =  width + border + padding  
```

## offsetLeft和offsetTop

- 没有下和右，只有offsetLeft和offsetTop  
- offsetLeft返回距离上级盒子（带有定位）左边的位置。如果父级都没有定位，则以body为准。如果父级有定位，则以父级的左侧为准。

## offsetParent
- offsetParent返回该对象的父级（带有定位）
    - 如果当前元素的父级元素没有进行CSS定位（position为absolute或relative），offsetParent为body。
    - 如果当前元素的父级元素中有CSS定位（position为absolute或relative），offsetParent取最近的那个父级元素。

## box.style.left和box.offsetLeft区别

- 最大区别在于offsetLeft可以返回没有定位盒子的距离左侧的位置。而style.left不可以
- offsetTop返回的是数字，而style.top返回的是字符串，除了数字外还带有单位：px。所以style.left不能直接进行加减需要parseInt（box.style.left）
- offsetTop只读，而style.top可读写。
- 如果没有给 HTML 元素指定过 top 样式，则 style.top 返回的是空字符串。

# client家族

- offsetWidth:  width + padding + border
- clientWidth： width + padding
- scrollWidth:  width + padding  不包含边框   **大小是内容的大小**    

![image](http://i4.buimg.com/588926/7b3774fe6358cd9d.png)

## 检测屏幕宽度(可视区域)
- ie9+及其以上的版本:   window.innerWidth            
- 标准模式: document.documentElement.clientWidth
- 怪异模式: document.body.clientWidth

# scroll家族

## 滚动事件

```
window.onscroll = function() { 语句 }
```

每滚动一次，1像素 就会触发这个事件。

## scrollTop和scrollLeft  

scrollTop被卷去的头部,它就是当你滑动滚轮浏览网页的时候网页隐藏在屏幕上方的距离

1. 怪异模式的浏览器（未声明DTD ）应该使用 document.body.scrollTop/scrollLeft
    - 判断是否声明DTD: document.compatMode === "BackCompat" BackCompat为未声明，CSS1Compat为已经声明（注意大小写)
2. 标准模式的浏览器应该使用的是 document.documentElement.scrollTop;
3. ie9+ 以上的版本，以及正常浏览器（除了ie678等）提倡使用window.pageYOffset/pageXOffset

兼容写法：  

```
var scrolltop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;  
```

## scrollTo
window.scrollTo 方法可把内容滚动到指定的坐标。
- 格式：window.scrollTo(xpos,ypos)
    - xpos	必需。要在窗口文档显示区左上角显示的文档的 x 坐标。
    - ypos	必需。要在窗口文档显示区左上角显示的文档的 y 坐标

我们想要返回顶部: window.scrollTo(0,0);（让y为0即可）

# 事件

## 事件对象（event）  
所有浏览器都支持event对象，但支持的方式不同：
- 普通浏览器支持 event  
- ie 678 支持 window.event

### event的属性
- data  返回拖拽对象的url字符串（dragDrop）
- width 该窗口或框架的宽度
- height    该窗口或框架的高度
- pageX 光标相对于该网页的水平位置（ie无）
- pageY 光标相对于该网页的垂直位置（ie无）
- screenX   光标相对于该屏幕的水平位置
- screenY   光标相对于该屏幕的垂直位置
- target    该事件被传送的对象
- type  事件类型
- clientX   光标相对于该网页的水平位置（当前可见区域）
- clientY   光标相对于该网页的垂直位置（当前可见区域）

ie 678 不支持pageX和pageY但是我们只能采取另外的方式获取：

```
pageY = clientY + document.documentElement.scrollTop  
```

## 事件冒泡

当一个元素上的事件被触发的时候，比如说鼠标点击了一个按钮，同样的事件将会在那个元素的所有祖先元素中被触发。这一过程被称为事件冒泡；这个事件从原始元素开始一直冒泡到DOM树的最上层。

顺序

- IE 6.0: div -> body -> html -> document   
- 其他浏览器:div -> body -> html -> document -> window

不是所有的事件都能冒泡。**不冒泡事件：blur、focus、load、unload**

### 阻止冒泡的方法

- w3c的方法是event.stopPropagation()
- IE则是使用event.cancelBubble = true

兼容的写法：

```
if(event && event.stopPropagation) {
    event.stopPropagation();  //  w3c 标准
} else {
    event.cancelBubble = true;  // ie 678  ie浏览器
}
```

### 判断当前对象

- 火狐、谷歌等  event.target.id        
- ie 678    event.srcElement.id      

兼容性写法：  
```
var targetId = event.target ? event.target.id : event.srcElement.id;
```

### 判断用户是否选择文字

- IE9以下支持：document.selection 　　
- IE9、Firefox、Safari、Chrome和Opera支持：window.getSelection() 

#### 清除选中的内容

```
window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
```

# 获得css样式属性值

- ie专属    div.currentStyle.left 
- w3c   window.getComputedStyle(元素,伪元素)
    - 一般情况下没有伪元素，我们用 null 来替代。

兼容性的写法：  
```
function getStyle(obj,attr) {
    if(obj.currentStyle) {
        return  obj.currentStyle[attr];
    } else {
        return window.getComputedStyle(obj,null)[attr];
    }
}
```

# 正则表达式

使用语法：表达式.test("要验证的内容");  

```
console.log(/\d/.test(567));
```

## 正则表达式声明

1. 通过构造函数定义: var 变量名= new RegExp(/表达式/); 
2. 通过直接量定义（较为常用）: var 变量名= /表达式/;

## 预定义类                                                       

-  .    [^\n\r] 除了换行和回车之外的任意字符
- \d    [0-9]   数字字符
- \D    [^0-9]  非数字字符
- \s    [ \t\n\x0B\f\r] 空白字符 
- \S    [^ \t\n\x0B\f\r]    非空白字符
- \w    [a-zA-Z_0-9]    单词字符
- \W    [^a-zA-Z_0-9]   非单词字符  

## 量词

-  *    重复零次或更多  (>=0)
-  +    重复一次或更多次    (>=1)
-  ?    重复零次或一次（0||1）
- {}    重复多少次的意思

## replace 函数

需要匹配的对象.replace(正则式/字符串，替换的目标字符)

## 正则表达式的匹配模式

- g：表示全局模式（global），即模式将被应用于所有字符串而非发现一个而停止
- i：表示不区分大小写（ease-insensitive）模式，在确定匹配想时忽略模式与字符串的大小写

## 封装自己的trim函数

```
function trim(str) {
    //起始就去掉第一个和最后一个空白字符串
    str.replace(/^\s+|\s+$/g,"");
}
```

# 获得css样式属性值

div. style.left只能得到行内样式的属性值。而工作中，最为常用的是内嵌式和外链式的写法。

- ie 专属：div.currentStyle.left 
- w3c：window.getComputedStyle(元素,伪元素)。一般情况下没有伪元素，用null来替代。

兼容性的写法：
```
function getStyle(obj,attr) {
    if(obj.currentStyle) {
        return  obj.currentStyle[attr];
    } else {
        return window.getComputedStyle(obj,null)[attr];
    }
}
```
