# 登录MySQL数据库

```
mysql -h localhost -P 3306 -u root -p
```

其中：
- -h：主机名
- -P：端口
- -u：用户名
- -p：密码

mysql默认连接localhost和3306，所以可以省略-h和-P

```
mysql -u root -p
```

# MySQL相关命令

在命令行中输入“help”或者“\h”，就会显示出MySQL的帮助信息。

命令 | 简写 | 具体含义
---|---|---
?   |\? |显示帮助信息
exit    |\q |退出MySQL
help    |\h |显示帮助信息
quit    |\q |退出MySQL
status  |\s |获取MySQL服务器状态信息
use |\u |用来选择一个数据库，以一个数据库名作为参数

# 常用数据库操作命令

- 创建数据库

```SQL
CREATE DATABASE [IF NOT EXISTS] db_name;
```

- 查看数据库

```SQL
SHOW DATABASES;
```

- 显示数据库创建语句

```SQL
SHOW CREATE DATABASE db_name;
```

- 删除数据库

```SQL
DROP DATABASE [IF EXISTS] db_name;
```

- 选择数据库

```SQL
USE db_name;
```

- 查看当前使用的数据库

```SQL
SELECT DATABASE();
```

- 查看当前数据库中的所有表

```SQL
show tables;
```

- 查看表结构

```SQL
desc table_name;
```

- 查看建表语句

```SQL
show create table table_name;
```

- 增加列

```SQL
ALTER TABLE table_name ADD colum datatype;
```

- 修改列

```SQL
ALTER TABLE table_name MODIFY colum datatype;
```

- 删除列

```SQL
ALTER TABLE table_name DROP colum;
```

- 修改表名

```SQL
rename TABLE table_name to new_table_name;
```

- 修改列名

```SQL
ALTER TABLE table_name change colum_name new_colum_name datatype;
```

- 删除数据表

```SQL
DROP TABLE table_name;
```

- 初始化数据表

```SQL
truncate table_name;
```

- truncate和delete的区别
    + delete会一条一条的删
	+ truncate先摧毁整张表，再创建一张和原来的表结构一模一样的表
	+ truncate在效率上比delete高
	+ truncate会把自增id截断恢复为1


# 数据类型

## 整数类型

类型    |大小   |范围（有符号） |范围（无符号） |用途
---|---|---|---|---
TINYINT |1 字节 |(-128，127)    |(0，255)       |小整数值
SMALLINT    |2 字节 |(-32 768，32 767)  |(0，65 535)    |大整数值
MEDIUMINT   |3 字节 |(-8 388 608，8 388 607)    |(0，16 777 215)    |	大整数值
INT或INTEGER    |4 字节 |(-2 147 483 648，2 147 483 647)    |(0，4 294 967 295)    |大整数值
BIGINT  |8 字节 |(-9 233 372 036 854 775 808，9 223 372 036 854 775 807)    |(0，18 446 744 073 709 551 615) |极大整数值
FLOAT   |4 字节 |(-3.402 823 466 E+38，1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38)   |0，(1.175 494 351 E-38，3.402 823 466 E+38)   |单精度浮点数值
DOUBLE  |8 字节 |(1.797 693 134 862 315 7 E+308，2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)	    |0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)  |双精度浮点数值
DECIMAL |对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2   |依赖于M和D的值 |依赖于M和D的值 |小数值

> DECIMAL类型的取值范围和DOUBLE相同。
但是DECIMAL类型的有效取值范围由M和D决定，M表示数据长度，D表示小数点后的长度。比如将数据类型为DECIMAL（6,2）的数据3.1415插入数据库后，显示结果为3.14。

## 日期和时间类型
类型	|大小(字节) |范围	|格式	|用途
---|---|---|---|---
DATE	|3	|1000-01-01/9999-12-31	|YYYY-MM-DD	|日期值
TIME	|3	|'-838:59:59'/'838:59:59'	|HH:MM:SS	|时间值或持续时间
YEAR	|1	|1901/2155	|YYYY	|年份值
DATETIME	|8	|1000-01-01 00:00:00/9999-12-31 23:59:59	|YYYY-MM-DD HH:MM:SS	|混合日期和时间值
TIMESTAMP	|8	|1970-01-01 00:00:00/2037 年某时	|YYYYMMDD HHMMSS    |	混合日期和时间值，时间戳

> 如果插入的数值不合法，系统会自动将对应的零值插入到数据库中。


可以使用下面三种方式指定时间的值：
1.	以“D HH：MM：SS“字符串格式表示。其中，D表示日，可以取0-34之间的值，插入数据时，小时的值等于（D*24+HH）
例如，输入‘2 11:30:50‘，插入数据库的日期为 59:30:50

2.	以‘HHMMSS‘字符串格式或者HHMMSS数字格式表示
例如：输入‘345454‘或345454，插入数据库的日期为34:54:54

3.	使用CURRENT_TIME或NOW()输入当前系统时间

-	TIMESTAMP

TIMESTAMP类型显示形式和DATETIME相同，但取值范围比DATETIME小。

1. 输入CURRENT_TIMESTAMP输入系统当前日期和时间
2. 输入NULL时，系统会自动输入当前日期和时间
3. 无任何输入时，系统会输入系统当前日期和时间

## 字符串和二进制类型
类型	|大小	|用途
---|---|---
CHAR	|0-255字节	|定长字符串
VARCHAR	|0-65535 字节	|变长字符串
TINYBLOB	|0-255字节	|不超过 255 个字符的二进制字符串
TINYTEXT	|0-255字节	|短文本字符串
BLOB	|0-65 535字节	|二进制形式的长文本数据
TEXT	|0-65 535字节	|长文本数据
MEDIUMBLOB	|0-16 777 215字节	|二进制形式的中等长度文本数据
MEDIUMTEXT	|0-16 777 215字节	|中等长度文本数据
LONGBLOB	|0-4 294 967 295字节	|二进制形式的极大文本数据
LONGTEXT	|0-4 294 967 295字节	|极大文本数据
BIT	|1~64位	|二进制数据


### CHAR和VARCHAR

插入值	|CHAR(4)	|存储需求	|VARCHAR(4)	|存储需求
---|---|---|---|---
‘‘	|‘‘	|4个字节	|‘‘	|1个字节
‘ab‘	|‘ab‘	|4个字节	|‘ab‘	|3个字节
‘abc‘	|   |4个字节	|‘abc‘	|4个字节
‘abcd‘	|	|4个字节	|‘abcd‘	|5个字节
‘abcde‘	|‘abcd‘	|4个字节	|‘abcd‘	|5个字节

当数据为CHAR(4)类型时，不管插入值的长度是多少，所占用的存储空间都是4个字节。而VARCHAR（4）所对应的数据所占用的字节数为实际长度加1.

	
总结：

- 字符长度不固定的类型使用VARCHAR	查询的时候要计算字节的长度
- 字符串长度固定的使用CHAR	查询速度快。
- VARCAHR比CHAR省空间
- CHAR比VARCHAR省时间
	
