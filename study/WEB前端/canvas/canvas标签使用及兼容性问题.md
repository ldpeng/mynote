# 标签语法

```html
<canvas></canvas>
```

注意：
- canvas元素本身是没有绘图能力的。所有的绘制工作必须在JavaScript内部完成。
- 可以给canvas画布通过style属性设置它的背景色和边框。
- 不能用css来设置canvas的宽高：如果设置了，只会将画布整体缩放。
- width和hegiht：如果不设置宽高，默认为300*150像素。

# 浏览器不兼容的处理

- ie9以上才支持canvas, 其他chrome、ff、苹果浏览器等都支持
- 只要浏览器兼容canvas，那么就会支持绝大部分api(个别最新api除外)
- 移动端的兼容情况非常理想，基本上随便使用
- 2d的支持的都非常好，3d（webgl）ie11才支持，其他都支持
- 如果浏览器不兼容，最好进行友好提示

```html
<canvas id="cavsElem">
你的浏览器不支持canvas，请升级浏览器。
</canvas>
```