# 多媒体

## 常见多媒体方法

|方法              |描述                                |
|-----------------|-----------------------------------|
|addTextTrack()   |向音频/视频添加新的文本轨道             |
|canPlayType()    |检测浏览器是否能播放指定的音频/视频类型   |
|load()           |重新加载音频/视频元素                  |
|play()           |开始播放音频/视频                     |
|pause()          |暂停当前播放的音频/视频                |

## 事件

|事件           | 作用                                                  |
|---------------|-------------------------------------------------------|
|oncanplay      | 事件在用户可以开始播放视频/音频（audio/video）时触发  |
|ontimeupdate   | 通过该事件来报告当前的播放进度                        |
|onended        | 播放完时触发                                          |

## 自定义一个视频播放器

```javascript
// 获取界面上的video元素，所有的操作必须通过它实现
var video = document.getElementById('video');
var btn_play = document.getElementById('btn_play');
// 注册点击事件
// addEventListener 用于注册事件， 将事件属性的on去掉 作为第一个参数传入
btn_play.addEventListener('click', function() {
  video.play();
  btn_play.disabled = true;
  btn_pause.disabled = false;
});
var btn_pause = document.getElementById('btn_pause');
btn_pause.addEventListener('click', function() {
  video.pause();
  btn_play.disabled = false;
  btn_pause.disabled = true;
});
var btn_muted = document.getElementById('btn_muted');
btn_muted.addEventListener('click', function() {
  // 交互变化true或false
  video.muted = !video.muted;
  btn_muted.innerHTML = video.muted ? "取消静音" : "静音";
});
var volume = document.getElementById('volume');
volume.addEventListener('change', function(e) {
  // 拿一下当前volume的值
  video.volume = volume.value;
});
var btn_speed_up = document.getElementById('btn_speed_up');
btn_speed_up.addEventListener('click', function(e) {
  // 加速
  video.playbackRate += 0.1;
});
var btn_speed_down = document.getElementById('btn_speed_down');
btn_speed_down.addEventListener('click', function(e) {
  // 减速
  video.playbackRate -= 0.1;
});
var btn_forward = document.getElementById('btn_forward');
btn_forward.addEventListener('click', function(e) {
  // 前进5秒
  video.currentTime += 5;
});
var btn_back = document.getElementById('btn_back');
btn_back.addEventListener('click', function(e) {
  // 后退5秒
  video.currentTime -= 5;
});

// 注册视频播放状态变化事件
video.addEventListener('timeupdate', function() {
  progress.value = (video.currentTime / video.duration) * 100;
});
```

# 全屏 API

- HTML5中提供了可以通过JS实现网页全屏的效果
- 具体的方式就是通过特定元素的`requestFullScreen`方法实现
- 由于在不同浏览器中该方法需要加上特定前缀
- 退出全屏通过`exitFullScreen`方法

```javascript
// 全屏
function fullScreen(element) {
  if (element.requestFullScreen) {
    element.requestFullScreen();
  } else if (element.webkitRequestFullScreen) {
    element.webkitRequestFullScreen()
  } else if (element.mozRequestFullScreen) {
    element.mozRequestFullScreen()
  } else if (element.oRequestFullScreen) {
    element.oRequestFullScreen()
  } else if (element.msRequestFullScreen) {
    element.msRequestFullScreen()
  }
}
var btnFullScreen = document.getElementById('btn_fullscreen');
btnFullScreen.addEventListener('click', function() {
  fullScreen(video);
});
```

# 新的选择器

```javascript
document.querySelectorAll('ul');
document.querySelectorAll('.container');
document.querySelector('div#container > .inner');
```

|API                      |描述                           |返回结果
|-------------------------|------------------------------|----------------------------
|querySelector            |获取第一个满足选择器条件的元素     |一个DOM对象
|querySelectorAll         |获取所有满足选择器条件的元素       |包含多个DOM对象的数组
|getElementsByClassName   |获取所有使用指定类名的元素         |包含多个DOM对象的数组

> 小提示：h5大部分时候就是将我们经常需要的操作原生支持一下，让我们使用起来更方便，不用再借助第三方的框架

- querySelector 和 querySelectorAll 是每一个DOM对象都具备的函数
- 其作用就是在这个dom对象下根据选择器找到对应元素

# Element.classList

- H5中DOM对象多了一个classList属性
- 该属性其实就是是一个数组
- 这个数组中的内容就是当前DOM元素的样式列表（class属性）

| API | 描述 | 对比jQuery |
| --- | --- | --- |
| element.classList.add() | 给当前元素添加指定类名 | $element.addClass() |
| element.classList.remove() | 在当前元素中删除指定类名 | $element.removeClass() |
| element.classList.contains() | 判断当前元素中是否存在指定类名 | $element.hasClass() |
| element.classList.toggleClass() | 在当前元素上切换指定类名的存在 | $element.toggleClass() |

- toggleClass方法有两个参数，第二个参数为boolean类型，表示是否添加。为true时肯定是添加；为false时肯定是删除

# 自定义属性 DATA-* !

- 在HTML5中，如果想要给元素添加一些自定义属性
- 可以DOM对象添加一些data-xxx的属性

```html
<ul id="users">
  <li data-id="1" data-age="18" data-gender="true">张三</li>
</ul>
```

- 可以通过getAttribute()/setAttribute()方式访问元素的属性
- HTML5在JavaScript中提供了一个新的API：**dataset**，用于操作元素的自定义属性

```javascript
var liElement = document.querySelector('#users > li');

// 添加一个自定义属性
liElement.dataset['name'] = '张三';

// 获取liElement中所有的自定义属性
console.log(liElement.dataset);
// output: {id: 1, age: 18, gender: true, name: '张三'}

```

- 注意如果自定义属性中间有-，则将属性名字中间的横线去掉改成驼峰命名
- 如data-product-id="10" 获取则使用xxx.dataset['productId']

# 离线 & 存储

## Application Cache

Application Cache 就是让网页可以离线访问的技术

使用方式：

1. 创建一个缓存清单文件（比如：cache.manifest）

```
CACHE MANIFEST
# version 1.0.7

CACHE:
    css/style.css
    js/script.js
    img/logo.png
    index.html

NETWORK:
    *
```

2. 回到HTML中，给HTML标签添加manifest属性，指向刚刚创建的缓存清单文件

```html
<html manifest="cache.manifest">
...
</html>
```

3. JS中可以捕获到Application Cache的更新事件：

```javascript
if (window.applicationCache) {
    window.applicationCache.addEventListener('updateready', function(e) {
        // 更新完成触发
        if (window.applicationCache.status == window.applicationCache.UPDATEREADY) {
            window.applicationCache.swapCache();
            if (confirm('更新成功，是否刷新页面?')) {
                window.location.reload();
            }
        }
    });
}
```

## Web Storage

- localStorage （永久，除非用户手动清除）
- sessionStorage （会话，关闭浏览器清除）

两者操作方式完全相同，只不过是数据存储的周期不同

```javascript
var btnSet = document.querySelector('#btn_set');
var btnGet = document.querySelector('#btn_get');
var txtValue = document.querySelector('#txt_value');
btnGet.addEventListener('click', function() {
    txtValue.value = localStorage.getItem('key1');
    //txtValue.value = localStorage['key1'];
});
btnSet.addEventListener('click', function() {
    localStorage.setItem('key1', txtValue.value);
    //localStorage['key1'] = txtValue.value;
});
```

- getItem方式获取一个不存在的键 返回空字符串
- []方式获取一个不存在的键 返回undefined

# 文件API

> [input file类型，文件类型的限制](http://www.cnblogs.com/Joans/p/3158582.html)

## 读取本地文件信息

文件域对象可以获取用户选择文件的信息：

```javascript
var input = document.querySelector('#input_1');
var file = input.files[0];
file.name // 获取文件名
file.lastModifiedDate // 获取最近修改时间
file.size // 获取文件大小（单位KB）
file.type // 获取文件类型（如：text/plain、image/png）
```

## 使用FileReader读取文件内容

```javascript
var reader = new FileReader();
reader.addEventListener('load', function () {
  this.result; // 读取出来的结果
});
reader.readAsText(file); // 以文本的形式读取
reader.readAsDataURL(file); // 以DataURI的形式读取，可用于展示图片
// 以下（后台工程师用，前端不会用到）
reader.readAsBinaryString(file); // 二进制格式
reader.readAsArrayBuffer(file); // 字节数组
```

## DATAURI格式描述数据

data:image/png;base64,iVBORw

# 拖放操作

## 网页内元素拖放

- 我们可以通过在元素上添加`draggable="true"`属性实现元素允许被拖拽

> 提示：链接和图片默认是可拖动的，不需要 draggable 属性。

- 在拖放的过程中会触发以下事件：
  + 在拖动目标上触发事件 (源元素):
    * ondragstart - 用户开始拖动元素时触发
    * ondrag - 元素正在拖动时触发
    * ondragend - 用户完成元素拖动后触发
  + 释放目标时触发的事件（目标元素）:
    * ondragenter - 当被鼠标拖动的对象进入其容器范围内时触发此事件
    * ondragover - 当某被拖动的对象在另一对象容器范围内拖动时触发此事件
    * ondragleave - 当被鼠标拖动的对象离开其容器范围内时触发此事件
    * ondrop - 在一个拖动过程中，释放鼠标键时触发此事件

> 注意： 在拖动元素时，每隔 350 毫秒会触发 ondrag 事件。

## 桌面文件拖拽至网页

```javascript
// 找到目标位置框框
var target = document.querySelector('#target');
var fileList = document.querySelector('#result');

// 注册拖拽进入
target.addEventListener('dragenter', function() {
    this.classList.add('actived');
});

// 离开
target.addEventListener('dragleave', function() {
    this.classList.remove('actived');
});

// 如果想要捕获drop事件 就一定得在该事件中阻止默认事件
target.addEventListener('dragover', function(e) {
  e.preventDefault();
  e.stopPropagation();
});

// 当元素放到该对象上
target.addEventListener('drop', function(e) {
    if (e.dataTransfer.files.length) {
        var files = e.dataTransfer.files;
        for (var i = 0; i < files.length; i++) {
            var li = document.createElement('li');
            li.setAttribute('class', 'list-group-item');
            // 创建信息的子节点
            li.innerHTML = '<h5 class="list-group-item-heading">' + files[i].name + '</h5><p class="list-group-item-text">' + files[i].lastModifiedDate.toLocaleDateString() + ' ' + files[i].lastModifiedDate.toLocaleTimeString() + ' ' + (files[i].size / 1024).toFixed(2) + 'KB</p>';
            fileList.appendChild(li);
        }
    } else {
        // 短路运算
        var data = e.dataTransfer.getData('text/plain');
        if (data) {
            // 拖入的是文本
            target.innerHTML = data;
        } else {
            var img = document.createElement('img');
            img.src = e.dataTransfer.getData('text/uri-list');
            target.appendChild(img);
        }
    }

    this.classList.remove('actived');

    e.preventDefault();
    e.stopPropagation();
});
```

# 网络环境判断

```javascript
window.addEventListener('online',function(){
    alert('网络连接已建立！');
});

window.addEventListener('offline',function(){
    alert('网络连接已断开！');
})
```

# 地理定位

```javascript
/*navigator 导航*/

//geolocation: 地理定位

//兼容处理
if(navigator.geolocation){
    //如果支持，获取用户地理信息

    //successCallback 当获取用户位置成功的回调函数
    //errorCallback 当获取用户位置失败的回调函数
    navigator.geolocation.getCurrentPosition(successCallback,errorCallback);
}else{
    console.log('sorry,你的浏览器不支持地理定位');
}

// 获取地理位置成功的回调函数
function successCallback(position){
    //获取用户当前的经纬度
    //coords坐标
    //纬度latitude
    var wd=position.coords.latitude;
    //经度longitude
    var jd=position.coords.longitude;

    console.log("获取用户位置成功！");
    console.log(wd+'----------------'+jd);

    //40.05867366972477----------------116.33668634275229

    //谷歌地图：40.0601398850,116.3434224706
    //百度地图：40.0658210000,116.3500430000
    //腾讯高德：40.0601486487,116.3434373643
}

// 获取地理位置失败的回调函数
function errorCallback(error){
    console.log(error);
    console.log('获取用户位置失败！')
}
```
