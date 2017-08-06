在移动端用来承载网页的这个区域，就是我们的视觉窗口，viewport（视口）,这个区域可设置高度宽度，可按比例放大缩小，而且能设置是否允许用户自行缩放。 

- width：宽度设置的是viewport宽度，可以设置device-width特殊值
- initial-scale：初始缩放比，大于0的数字
- maximum-scale：最大缩放比，大于0的数字
- minimum-scale：最小缩放比，大于0的数字
- user-scalable：用户是否可以缩放，yes或no（1或0）； 

```HTML
<head lang="en">
    <meta charset="UTF-8">
    <!--
    行业通用的viewpoert设置
    -->
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=0"/>
</head>
```
