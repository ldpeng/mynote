# 选择器

CSS3选择器与jQuery中所提供的绝大部分选择器兼容。

## 属性选择器

其特点是通过属性来选择元素，具体有以下7种形式：

1. E[attr] 表示存在attr属性即可；
2. E[attr=val] 表示属性值完全等于val；
3. E[attr*=val] 表示的属性值里包含val字符并且在“__任意__”位置；
4. E[attr^=val] 表示的属性值里包含val字符并且在“__开始__”位置；
5. E[attr$=val] 表示的属性值里包含val字符并且在“__结束__”位置；

## 伪类选择器

除了以前学过的:link、:active、:visited、:hover，CSS3又新增了其它的伪类选择器。

- 以某元素相对于其父元素或兄弟元素的位置来获取无素的结构伪类。重点理解通过E来确定元素的父元素。
  - E:first-child第一个子元素
  - E:last-child最后一个子元素
  - E:nth-child(n) 第n个子元素，计算方法是E元素的全部兄弟元素；
  - E:nth-last-child(n) 同E:nth-child(n) 相似，只是倒着计算；
    - n遵循线性变化，其取值0、1、2、3、4、... 但是当n<=0时，选取无效。
    - n可是多种形式：nth-child(2n)、nth-child(2n+1)、nth-child(-1n+5)等；
- E:empty 选中没有任何子节点的E元素；（使用不是非常广泛）
- E:target 目标伪类，结合锚点进行使用，处于当前锚点的元素会被选中；

## 伪元素选择器
- E::first-letter文本的第一个单词或字（如中文、日文、韩文等）；
- E::first-line 文本第一行；
- E::selection 可改变选中文本的样式；
- **E::before、E::after** 是一个行内元素，需要转换成块元素

>E:after、E:before 在旧版本里是伪类，在新版本里是伪元素，新版本下E:after、E:before会被自动识别为E::after、E::before，按伪元素来对待，这样做的目的是用来做兼容处理。
":" 与 "::" 区别在于区分伪类和伪元素
