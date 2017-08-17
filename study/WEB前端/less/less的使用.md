# 定义变量

```css
// less支持跟js一样的注释，并且这样的注释 不会被编译

/* 使用 css的注释 那么 编译的时候 该注释 也会被保留 */

// 变量名 :变量值
@jdRed:rgb(201,21,35);

// 定义宽度
@minWidth:100px;

// 定义图片尺寸
@imageSize:100px 100px;


body{
	background-color: @jdRed;
}
h3{
	background-color:@jdRed;
	background-size: @imageSize;
}

ul{
	background-color:@jdRed;
	width:@minWidth;
}
```

编译后的CSS文件

```css
/* 使用 css的注释 那么 编译的时候 该注释 也会被保留 */
body {
  background-color: #c91523;
}
h3 {
  background-color: #c91523;
  background-size: 100px 100px;
}
ul {
  background-color: #c91523;
  width: 100px;
}
```

# 定义函数

注意：函数名不能与类名相同

```css
.red{
	background-color: red;
	border:1px solid red;
	color:red;
}

body{
	.red();
}

// 括号中 参数名: 参数的默认值
// 如果不传递参数,会使用默认值
.oneColor(@color:#0094ff){
	background-color: @color;
	border:1px solid @color;
	color:@color;
}

ul{
	.oneColor(yellow);
}

div{
	.oneColor();
}
```

# 嵌套使用

```css
//直接写单纯的层次关系
.main{
	width: 100%;
	.main_left{
		width: 90px;
		ul{
			width: 100%;
			li{
				width: 100%;
				text-align: center;
				height: 50px;
				line-height: 50px;
				border-bottom: 1px solid gray;
				border-right: 1px solid gray;
				a{
					color:black;
				}
			}
		}
	}

	.main_right{
		overflow: hidden;
		/* 顶部 左右 底部为0 */
		padding: 10px 10px 0;

		.right_banner{
			display: block;
			width: 100%;
			img{
				display: block;
				width: 100%;	
			}
		}
		h3{
			margin-top: 10px;
			font-size: 12px;	
		}	
		ul{
			width: 100%;
			padding-top: 10px;
		}
	}
}

.clearfix{
	content: '';
	display:block;
	line-height:0;
	height:0;
	visibility: hidden;
	clear:both;
}

ul{
    // 如果 只是想要是该class里面的样式 不传递 任何的参数 时可以不写括号的
	.clearfix;
	li{
		width: 100%;
		height: 60px;
		//如果直接写生成的css是后代选择器
        //可以用&符号表示当前节点
		&.current{
			color:red;
		}
		&::before{
			.clearfix;
		}
	}

}
```

编译后的css文件

```css
.main {
  width: 100%;
}
.main .main_left {
  width: 90px;
}
.main .main_left ul {
  width: 100%;
}
.main .main_left ul li {
  width: 100%;
  text-align: center;
  height: 50px;
  line-height: 50px;
  border-bottom: 1px solid gray;
  border-right: 1px solid gray;
}
.main .main_left ul li a {
  color: black;
}
.main .main_right {
  overflow: hidden;
  /* 顶部 左右 底部为0 */
  padding: 10px 10px 0;
}
.main .main_right .right_banner {
  display: block;
  width: 100%;
}
.main .main_right .right_banner img {
  display: block;
  width: 100%;
}
.main .main_right h3 {
  margin-top: 10px;
  font-size: 12px;
}
.main .main_right ul {
  width: 100%;
  padding-top: 10px;
}
.clearfix {
  content: '';
  display: block;
  line-height: 0;
  height: 0;
  visibility: hidden;
  clear: both;
}
ul {
  content: '';
  display: block;
  line-height: 0;
  height: 0;
  visibility: hidden;
  clear: both;
}
ul li {
  width: 100%;
  height: 60px;
}
ul li.current {
  color: red;
}
ul li::before {
  content: '';
  display: block;
  line-height: 0;
  height: 0;
  visibility: hidden;
  clear: both;
}
```
