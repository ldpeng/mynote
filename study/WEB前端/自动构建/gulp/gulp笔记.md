# 环境搭建

1. 全局安装 gulp：

```shell
npm install --global gulp
```

2. 安装项目开发依赖（devDependencies）：

```shell
npm install --save-dev gulp
```

3. 在项目根目录下创建一个名为gulpfile.js的文件（用于编写gulp代码）。如：

```JavaScript
// 这里的代码完全是node代码
var gulp = require('gulp');

// 自动加前缀的一个NODE包
var autoprefixer = require('gulp-autoprefixer');

// 压缩图片
var imagemin = require('gulp-imagemin');

// 压缩html
var htmlmin = require('gulp-htmlmin');

// 改文件名（利用文件内容生成的hash名）
var rev = require('gulp-rev');

// 替换引用路径
var revCollector = require('gulp-rev-collector');

// 压缩代码
var uglify = require('gulp-uglify');

// 处理CSS
gulp.task('css', function () {
	// 获取需要构建的资源
	gulp.src('./css/*.css', {base: './'})
		// 通过管道的方式传递给了autoprefixer包
		.pipe(autoprefixer())
		// 把处理结果通过管道传递给了gulp.dest()
		.pipe(gulp.dest('./dist'));
});


// gulp.task()，配置我们的具体任务，需要的参数有任务名称，还需要一个回调方法
// gulp.src() 获取需要构建资源的路径，传递的参数必须得是一个路径
// gulp.dest() 放置我们构建好的资源的路径，传递的参数也是一个路径
// pipe 起到一个"承前启后"作用，上一次的处理结果，当做下一次参数传递
// gulp实际上啥事不干，专门"指挥"别人干

// 处理JS的任务
gulp.task('js', function() {
	return gulp.src('./js/*.js', {base: './'})
		// .pipe(concat('all.js'))
		.pipe(uglify())
		.pipe(gulp.dest('./dist'));
});

// 压缩图片
gulp.task('image', function () {
	return gulp.src('./images/*', {base: './'})
		.pipe(imagemin())
		.pipe(gulp.dest('./dist'));
});

// 压缩html
gulp.task('html', function () {
	return gulp.src('./*.html')
		.pipe(htmlmin({
			removeComments: true,
			collapseWhitespace: true,
			minifyJS: true
		}))
		.pipe(gulp.dest('./dist'));
});

// 生成hash文件名
gulp.task('rev',['css', 'js', 'image', 'html'], function () {
	// global语法
	return gulp.src(['./dist/**/*', '!**/*.html'], {base: './dist'})
		// 新的文件名
		.pipe(rev())
		// 存到dist
		.pipe(gulp.dest('./dist'))
		// 收集原文件名与新文件名的关系
		.pipe(rev.manifest())
		// 以json形式存入./rev目录下
		.pipe(gulp.dest('./rev'));
});

// 替换文件路径
gulp.task('revCollector',['rev'], function () {
	// 根据生成的json文件，去替换html里的路径
	return gulp.src(['./rev/*.json', './dist/*.html'])
		.pipe(revCollector())
		.pipe(gulp.dest('./dist'));
});

//命令行中输入gulp，默认执行名称为default的任务
gulp.task('default', ['revCollector']);
```

4. 执行gulp任务

命令行定位到项目根目录，执行gulp <任务名>（不写默认为default）。