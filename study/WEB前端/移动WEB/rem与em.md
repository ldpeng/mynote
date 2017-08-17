# 认识rem与em

- em 和 rem 都有一个默认的初始大小16px
- em的大小是根据父类元素的font-size来设置的
- rem的大小是根据 html标签的font-size来设置的

```html
<!DOCTYPE html>
<html style="font-size: 30px">
<head lang="en">
    <meta charset="UTF-8">
    <title></title>
    <style>
        div{
            font-size: 30px;
        }
        .class_em{
            /*em的大小是根据父类元素的font-size来设置的*/
            font-size: 2em;
        }
        .class_rem{
            /*
               r  root  根  页面当中 html标签才是根元素
               rem的大小是根据 html标签的font-size来设置的
            */
            font-size: 2rem;
        }
        .class_rem01{
            font-size: 4rem;
        }
    </style>
</head>
<body>
    <div>
        <span class="class_em">EM</span>
        <span class="class_rem">REM</span>
        <span class="class_rem01">REM</span>
    </div>
</body>
</html>
```

# 使用rem进行移动端适配

```html
<!DOCTYPE html>
<html style="font-size: 100px">
<head lang="en">
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"/>
    <title></title>
    <script>
        /*让文字和标签的大小随着屏幕的尺寸做变话 等比缩放*/
        var html = document.getElementsByTagName('html')[0];
        /*取到屏幕的宽度*/
        var width = window.innerWidth;
        /* 640 : 100 = 320 : 50 */
        var fontSize = 100/640*width;
        
        /*设置fontsize*/
        html.style.fontSize = fontSize +'px';
        
        window.onresize = function(){
            var html = document.getElementsByTagName('html')[0];
            /*取到屏幕的宽度*/
            var width = window.innerWidth;
            var fontSize = 100/640*width;
            /*设置fontsize*/
            html.style.fontSize = fontSize +'px';
        }
    </script>
    <style>
        body,html{
            margin: 0;
            padding : 0;
        }
        div{
            width: 2rem;
            height: 2rem;
            background: red;
            color: #fff;
        }
    </style>
</head>
<body>
    <div>AAA</div>
</body>
</html>
```
