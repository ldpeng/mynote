# 在样式中导入样式文件

```
@import url(文件路径);
```

导入样式必须写在其他样式设置之前。

# 伪类

伪类是获取标签的状态

a标签的伪类
- :link	表示未访问过的
- :visited 表示已访问过的
- :hover 表示鼠标移动到该元素上面
- :active 表示被点击

**原则：LoVe Hate	必须按照这个顺序写**

其他伪类
- :focus 表示焦点聚集

# 伪元素

伪元素是获取标签的内容

- :first-line 表示第一行
- :first-letter 表示第一个字符

**以上两个只能用于块级元素（P标签）**

- :first-child 选择属于第一个子元素的元素。

如：span:first-child{} 选择属于第一个子元素的所有span标签。

- :before和:after可以设置元素之前之后的内容，并且配合content设计相关内容。

如：#demo:after,#demo:before{ content: “--”; display: block; }

# 样式的优先级
- !important  >  行内样式 >  id选择器  >  类选择器  >  标签选择器  >  通配符  >  继承  >  默认

## 继承样式的特殊性
- A标签的颜色不会从父标签中继承；
- H标签的大小不会从父标签中继承；
- Div的宽高：如果div不设置宽高，则从父标签继承，宽为父标签宽，高为0
- !important这个属性不能继承

```
div{ color: red !important}
```

# Display属性
- Block使标签作为块级标签；
- Inline使标签作为行内标签；
- None使标签在浏览器中移除，不占用空间（visibility：hidden为隐藏，但还占用空间）；
- Inline-block 使标签作为行内块标签


 类型|宽高|边距|独占行
---|---|---|---
行内元素|不能设置|左右边距|不独占
块级元素|可以设置|上下左右|独占
行内块元素|可以设置|左右|不独占

**行内元素不能设置宽高，只能通过内容撑开。**

# 行高
css中的行高：两行文本之间的基线的距离。
![image](http://i4.buimg.com/567571/d1d1fb4a821b0826.jpg)

# 盒子模型
盒子：边框+内边距+内容区域+外边距组成

## 去掉边框
border : 0 none； 这是最兼容的写法

## 水平居中
将左右边距设置成auto，可是块级元素水平居中
如：.header{width:960px; margin: 0 auto;}

## margin的边框合并现象：
1. 如果两个盒子是并列关系，给上面盒子设置margin-bottom,给下面的盒子设置margin-top，它们两个的值不会相加，而是发生了**合并现象**：

```
margin-bottom:50;
margin-top:25;
```

margin-bottom + margin-top=50;由于是合并现象，所以将来在取值的时候会取得两者之间比较大的数。

2. 如果两个盒子是包含关系，如果让子盒子在父盒子之内向下平移100px：（**margin塌陷现象**）。实现方式：
    1. 给父盒子设置padding(麻烦，给父盒子设置了padding之后将来如果要父盒子的大小保持不变，还必须把padding值减掉。)
    2. 给子盒子设置margin-top(这里有一个bug，**如果父盒子没有边框，那么将来给子盒子设置以后父盒子也会随着子盒子一起向下掉**)。解决办法：
        1. 给父盒子设置边框
        2. 给父盒子设置属性：overflow(溢出)：hidden(隐藏)

# 清除浮动：
1. 使用额外标签法：

在需要清除浮动的地方加入一个额外的标签，然后使用clear:both来清除。（不推荐使用，因为会用到大量的额外标签）

2. 使用overflow：hidden
 
在需要清除浮动的标签中加入一个overflow：hidden;(不推荐使用，如果浮动与定位结合起来使用的话将来会发现冲突)

3. 使用当前最主流的清除方式：使用伪元素来清除浮动

```
.clearfix:after {
content:"";
height: 0;
line-height: 0;
display: block;
visibility:hidden;
clear:both;
}
.clearfix {
	zoom: 1;/*用来兼容ie浏览器*/
}
```

4. 使用双伪元素清除：

```
.clearfix:after , .clearfix:before {
content:””;
display: table;
clear:both;
}
.clearfix {
   	zoom: 1;
}
```

# 固定定位
- 作用：使用盒子显示浏览器的固定位置。
- 代码：position:fixed;
- 固定定位会脱离标准流
- 固定定位会改变元素的显示方式