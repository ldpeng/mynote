# 缩小图标比例防止失真

如果1：1的显示在移动设备当中图标会失真。因为在高清屏当中会用两个或多个物理像素来显示实际的1px图片内容。

那么其实就是相当于把1px的图片放大显示了，所以有毛边的图片一般都会失真，也就是显示模糊。

解决方案，采用压缩图标尺寸的方式来解决。

- 如果是Img使用直接设置宽高的方式来压缩。
- 如果是背景使用的是设置background-size的方式来压缩。

# 点击高亮效果

>在移动端浏览器会遇见点击出现高亮的效果，在某项项目是不需要这个默认的效果的。那么我们通常会把这个点击的颜色设置成透明。

```css
/*清除点击高亮效果*/
-webkit-tap-highlight-color:transparent;
```

# 盒子模型

```css
/*设置宽度以边框开始计算*/
/*webkit内核兼容性写法*/
-webkit-box-sizing: border-box;
box-sizing: border-box;
```

# Input默认样式清除

>在移动设备的浏览器中input标签一般会有默认的样式,通过border=none,outline=none无法去除,比如立体效果,3d效果等等,我们需要添加下列样式

```css
/*在移动端清除浏览器默认样式*/
-webkit-appearance: none;
```

# 最小宽度和最大的宽度

>考虑到移动设备在大尺寸的的屏幕不会过度缩放 失去清晰度,在小尺寸的屏幕中不会出现布局错乱的问题

```css
max-width: 640px;  
min-width: 300px;
```

# css初始化样例

```css
/* 通用样式 */
*,
::before,
::after{
	font-size: 14px;

	margin: 0;
	padding: 0;

	/* 点击高亮效果 *//* 手指点击 清除默认的 高亮效果 透明 */
	-webkit-tap-highlight-color: transparent ;

	/* 盒子模型 */
	/* 样式输入完毕 在后面tab */
	-webkit-box-sizing: border-box;
	box-sizing: border-box;

	/* 统一设置文字  sans-serif 移动端 的默认字体 */
	font-family: '微软雅黑',sans-serif;
}

/* input标签 去掉默认样式 */
input{
	border: none;
	-webkit-appearance: none;
}

/* a标签的下划线 */
a{
	text-decoration: none;
}

/* 去掉小圆点 */
ol,ul{
	list-style: none;
}

/* 清除浮动 */
.f_l{
	float: left;
}
.f_r{
	float: right;
}

/* 清除浮动 */
.clearfix::before,
.clearfix::after{
	content:'';
	display: block;
	line-height: 0;
	height: 0;
	visibility: hidden;
	clear: both;
}

/* 边框的 通用样式 */
.b_l{
	border-left: 1px solid #eee;
}
.b_r{
	border-right: 1px solid #eee;
}
.b_t{
	border-top: 1px solid #eee;
}
.b_b{
	border-bottom: 1px solid #eee;
}
```
