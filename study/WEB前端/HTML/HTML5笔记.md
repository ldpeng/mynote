# HTML5 骨架

```html
<!-- HTML5的DOCTYPE声明做了最大简化 -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- 在标准的HTML5骨架中charset是直接在meta中设置charset -->
    <!-- 字符编码的设置一定是在head中的第一行 -->
    <title>页面标题</title>
</head>
<body>
    
</body>
</html>
```

# 语义化标签

- HTML5中制定了一系列语义化标签：
    + section：独立的内容节块，一般包含标题和内容
    + article：一种特殊的section，定义文档中的具体的文章内容
    + nav：页面导航的链接组
    + aside：标签用来装载非正文的内容，此标签中的文字权重低
    + header：定义文档的页眉，不仅仅是文档的页头可以使用header，一个独立块的头部也应该使用header
    + footer：定义section或document的页脚
- 我们应该根据内容的性质决定使用特定的标签
- h1一定只能出现一个，不是HTML的约定，页面中最重要的内容

- time标签专门用于时间，
    + datetime属性应该是一个标准时间格式，
    + pubdate属性指的是当前时间为article的发布时间

```html
<article>
    <header>
        <h3>文章标题</h3>
        <!-- time标签专门用于时间，datetime应该是一个标准时间格式，pubdate指的是当前时间为article的发布时间 -->
        <time datetime="2015-12-21T10:44:03" pubdate>刚刚</time>
    </header>
    <section>
        <p>内容内容内<strong>容内</strong>容内容内内容</p>
    </section>
    <footer>
        <p>
            <span>阅读10次</span>
            <span>点击10次</span>
            <a href="#">阅读全文</a>
        </p>
    </footer>
</article>
```

> 在H5中，主体结构标签默认和DIV都是相同的块级效果，但是DIV没有语义，而以上标签有特定语义

## 兼容性

在IE9版本以下，并不能正常解析这些新标签，可以通过document.createElement("tagName")创建的自定义标签的方式将HTML5的新标签全部创建一遍，这样IE低版本也能正常解析HTML5新标签了

```html
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title></title>
    <!-- 注意：ie8以下的浏览器不支持h5标签-->
    <!--解决办法： 引入html5shiv.js文件-->
    <!--  条件注释 只有ie能够识别-->

    <!--[if lte ie 8]>
        <script src="html5shiv.min.js"></script>
    <![endif]-->

    <!--
        l:less 更小
        t：than 比
        e:equal等于
        g：great 更大
    -->
</head>
<body>
<!-- 新增的h5有语义 的标签  有语义的div -->
    <header>header</header>
    <nav>nav</nav>
    <section>
        <aside>侧边栏</aside>
        <article>文章</article>
    </section>
    <footer>底部</footer>
</body>
</html>
```

# 表单

## 新的表单类型

- email - 限定输入内容为邮箱地址，表单提交时会校验格式
- url - 限定输入内容为URL，表单提交时会校验格式
- number - 限定输入内容为数字，表单提交时会校验格式
- range - 数值范围选择器
- Date Pickers - 日期时间选择器
    + 样式不能修改，移动端用的比较多，因为移动端显示的是系统的时间或日期选择器
    + date - 选取日、月、年
    + month - 选取月、年
    + week - 选取周和年
    + time - 选取时间（小时和分钟）
    + datetime - 选取时间、日、月、年，浏览器兼容性不好，效果等同于datetime-local
    + datetime-local - 选取本地时间、日、月、年
- search - 搜索域，语义化，表示定义搜索框

## 新的表单属性

- form
    + autocomplete 设置整个表单是否开启自动完成 on|off
    + novalidate 设置H5的表单校验是否工作 true 不工作  不加该属性代表校验

- input:
    + autocomplete 单独设置每个文本框的自动完成
    + autofocus 设置当前文本域页面加载完了过后自动得到焦点
    + form 属性是让**表单外**的表单元素也可以**跟随表单一起提交**
    + form overrides（在submit上重写表单的特定属性，当点击当前submit时会以当前值使用）
        * formaction 
        * formenctype
        * formmethod
        * formnovalidate
        * formtarget
    + list 作用就是指定当前文本框的自动完成列表的datalist的ID 
    + min / max / step
        * min max 限制值的范围，但是不会再输入时限制，提交时校验，
        * step设置的是每次加减的增量
        * 主要使用在number range datepicker上
    + multiple
        * 文件域的多选
    + pattern
        * 设置文本框的匹配格式（正则）
    + placeholder
        * 文本框占位符
    + required
        * 限制当前input为必须的

```html
<input type="text" list="text_list">
<datalist id="text_list">
    <option value="avalue1"></option>
    <option value="bvalue2"></option>
    <option value="cvalue3"></option>
</datalist>

<input type="number" min="10" max="100" step="5" name="num">
<input type="range" min="10" max="1000" value="50" step="500" id="">
<input type="date" name="" max="2015-12-25" min="2015-11-25" step="2">

<input type="file" multiple>

<input type="text" placeholder="请输入用户名" id="">
```

## 表单事件

- oninput:当用户输入时 触发
- oninvalid:当验证不通过是触发-->设置验证不通过时的提示文字

```JavaScript
var txt1 = document.getElementById('txt1');
var txt2 = document.getElementById('txt2');
var num=0;

txt1.oninput = function(){
    num++;
    //将字数显示在txt2中
    txt2.value=num;
}

//oninvalid 当验证不通过是触发
//一般用于设置验证不通过时的 提示文字
txt1.oninvalid = function(){
    //用于设置验证不通过时的 提示文字
    this.setCustomValidity('亲，请输入正确的邮箱格式！');
}
```

## 虚拟键盘适配

- 在移动端中，我们可以通过不同的表单类型控制弹出的键盘类型

# 多媒体

## 音频

```html
<!--
    audio 定义音频播放组件
    controls 决定是否显示控制菜单
    autoplay 自动播放
    loop 循环播放
    height="200" width="200" 只会在视频时使用
    preload 预加载 在视频或者音频没有开始播放时是否开始加载文件
-->
<audio src="rushus-modal_blues.mp3" controls autoplay loop muted></audio>
  
<audio controls>
    <source src="rushus-modal_blues.mp3">
    <source src="rushus-modal_blues.ogg">
</audio>
```

## 视频

```html
<!--
    不管是audio还是video都不要直接设置标签的src
    格式问题：每个浏览器的音视频格式支持不同
    希望兼容各种格式
-->
<!-- 如果HTML中遇到不能识别的标签，就会将该标签当做DIV(块级元素) -->
<video controls width="500">
    <!-- html解析过程中会找其中第一个能认识的格式播放，一旦找到认识的视频格式，就不会再往后找了 -->
    <source src="chrome.mp4">
    <source src="chrome.ogv">
    <source src="chrome.webm">
    <!-- 这里可以做兼容提示 -->
    <span>shit 弱爆了 有木有</span>
</video>
```

