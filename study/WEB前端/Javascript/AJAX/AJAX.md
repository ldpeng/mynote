# ajax步骤

1. 建立XMLHTTPRequest对象
2. 注册回调函数
3. 使用open方法设置和服务器端交互的基本信息。设置提交的网址,数据,post提交的一些额外内容
4. 设置发送的数据，开始和服务器端交互
5. 在注册的回调函数中,获取返回的数据,更新界面

# XMLHttpRequest_API讲解

## 创建XMLHttpRequest对象(兼容性写法)

```Javascript
if(XMLHttpRequest){
    // 新式浏览器写法
    return new XMLHttpRequest();
 }else{
    //IE5,IE6写法
    return new ActiveXObject("Microsoft.XMLHTTP");
}
```

## 发送请求:

- open(method,url,async) 规定请求的类型、URL 以及是否异步处理请求。
    + method: 请求的类型；GET 或 POST
    + url：文件在服务器上的位置
    + async：true（异步）或 false（同步）
- send(string) 将请求发送到服务器。
    + string：仅用于 POST 请求

# POST请求注意点:

如果想要像form表单提交数据那样使用POST请求,需要使用XMLHttpRequest对象的setRequestHeader()方法来添加 HTTP 头。然后在 send() 方法中添加想要发送的数据：

```javascript
xmlhttp.open("POST","ajax_test.php",true);
xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
xmlhttp.send("fname=Bill&lname=Gates");
```

## onreadystatechange事件

- onreadystatechange 存储函数（或函数名），每当readyState属性改变时，就会调用该函数。
    + readyState 存有 XMLHttpRequest 的状态。从 0 到 4 发生变化。
        * 0: 请求未初始化
        * 1: 服务器连接已建立
        * 2: 请求已接收
        * 3: 请求处理中
        * 4: 请求已完成，且响应已就绪
    + status
        * 200: "OK"
        * 404: 未找到页面

## 服务器响应内容

- responseText 获得字符串形式的响应数据。
- responseXML 获得 XML 形式的响应数据。

## ajax工具方法封装

```javascript
var $ = {
	params: function (params) {
		var data = '';
		// 拼凑参数
		for(key in params) {
			data += key + '=' + params[key] + '&';
		}

		// 将最后一个&字符截掉
		return data.slice(0, -1);
	},
	// Ajax实例
	ajax: function (options) {
		// 实例化XMLHttpRequest
		var xhr = createXhr(),

			// 默认为get方式
			type = options.type || 'get',
			// 默认请求路径
			url = options.url || location.pathname,
			// 格式化数据key1=value1&key2=value2
			data = this.params(options.data);

		// get 方式将参数拼接到URL上并将data设置成null
		if(type == 'get') {
			url = url + '?' + data;
			data = null;
		}

		xhr.open(type, url);

		// post 方式设置请求头
		if(type == 'post') {
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		}

		// 发送请求主体
		xhr.send(data);

		// 监听响应
		xhr.onreadystatechange = function () {
			if(xhr.readyState == 4 && xhr.status == 200) {
				// 获取响应类型
				var contentType = xhr.getResponseHeader('Content-Type');

				var data = xhr.responseText;

				// 解析JSON
				if(contentType.indexOf('json') != -1) {
					data = JSON.parse(data);
				}

				// 调用success
				if(optinos.success) options.success(data);
			} else {
			    if(options.error) options.error('请求失败!');
			}
		}

	}
};

function createXhr() {
    if(XMLHttpRequest){
        // 新式浏览器写法
        return new XMLHttpRequest();
    }else{
        //IE5,IE6写法
        return new ActiveXObject("Microsoft.XMLHTTP");
    }
}
```

## jQuery的Ajax

```javascript
$.ajax({
  url:'01.php',//请求地址
  data:'name=fox&age=18',//发送的数据
  type:'GET',//请求的方式
  success:function (argument) {},// 请求成功执行的方法
  beforeSend:function (argument) {},// 在发送请求之前调用,可以做一些验证之类的处理
  error:function (argument) {console.log(argument);},//请求失败调用
})
```

### 使用jsonp

- dataType: 'jsonp' 设置dataType值为jsonp即开启跨域访问
- jsonp 可以指定服务端接收的参数的“key”值，默认为callback
- jsonpCallback 可以指定相应的回调函数，默认自动生成

```javascript
$.ajax({
  url:'http://www.section02.com/sectcion02_jqJsonp.php',
  type:'post',
  dataType: 'jsonp',
  data:{name:'itt'},
  success:function(data){
    console.log(data);
  }
})
```
