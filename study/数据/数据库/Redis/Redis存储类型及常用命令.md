redis是一种key-value的nosql数据库

其中的key是字符串类型，尽可能满足如下几点：

1. key不要太长，最好不要超过1024个字节，这不仅会消耗内存还会降低查找效率
2. key不要太短，太短会降低key的可读性
3. 在项目中，key最好有一个统一的命名规范（根据企业的需求）其中value	支持五种数据类型：
    1. 字符串型 string
    2. 字符串列表 lists
    3. 字符串集合 sets
    4. 有序字符串集合 sorted sets
    5. 哈希类型 hashs

# 存储字符串string

字符串类型在Redis中是二进制存储的，这意味着该可以接受任何格式的数据，如JPEG图像数据或Json对象描述信息等。

在Redis中字符串类型的Value最多可以容纳的数据长度是512M

- set key value

    设定key和value，如果key存在则进行覆盖。总是返回"OK"

- get key

    获取key的value。
    
    + 如果与该key关联的value不是String类型，redis将返回错误信息，因为get命令只能用于获取String value；
    + 如果该key不存在，返回null。

- getset key value

    先获取该key的值，然后在设置该key的值。

- incr key

    将指定的key的value**原子性**的递增1。
    
    + 如果该key不存在，其初始值为0，在incr之后其值为1。
    + 如果value的值不能转成整型，如hello，该操作将执行失败并返回相应的错误信息。

- decr key

    将指定的key的value**原子性**的递减1。
    
    + 如果该key不存在，其初始值为0，在incr之后其值为-1。
    + 如果value的值不能转成整型，如hello，该操作将执行失败并返回相应的错误信息。

- incrby key increment

    将指定的key的value原子性增加increment（指定值）
    + 如果该key不存在，其初始值为0，在incrby之后，该值为increment。
    + 如果该值不能转成整型，如hello，则失败并返回错误信息。

- decrby key decrement

    将指定的key的value原子性减少decrement
    
    + 如果该key不存在，其初始值为0，在decrby之后，该值为decrement。
    + 如果该值不能转成整型，如hello，则失败并返回错误信息。

- append key value
    + 如果该key存在，则在原有的value后追加该值；
    + 如果该key不存在，则重新创建一个key/value；
    + 返回key所对应字符串的长度

# 存储lists类型

在Redis中，List类型是按插入顺序排序的字符串链表。和数据结构中的普通链表一样，我们可以在其头部(left)和尾部(right)添加新的元素。

- 在插入时，如果该键并不存在，Redis将为该键创建一个新的链表。
- 如果链表中所有的元素均被移除，那么该键也将会被从数据库中删除。

- lpush key value1 value2...

    在指定的key的list头部插入所有的values，如果该key不存在，该命令在插入的之前创建一个与该key关联的空链表，之后再向该链表的头部插入数据。插入成功，返回元素的个数。

- rpush key value1 value2...

    在该list的尾部添加元素

- lrange key start end

    获取链表中从start到end的元素值，start、end可为负数，若为-1则表示链表尾部的元素，-2则表示倒数第二个，依次类推

- lpushx key value

    仅key对应的list类型的value存在时，在list的头部插入value。

- rpushx key value

    仅key对应的list类型的value存在时，在list的尾部添加元素。

- lpop key

    返回并弹出指定的key关联的链表中的第一个元素，即头部元素。

- rpop key

    从尾部弹出元素。

- rpoplpush resource destination

    将resource链表中的尾部元素弹出并添加到destination链表的头部

- llen key

    返回指定的key关联的链表中元素的数量。

- lset key index value

    设置链表中的index的脚标的元素值，0代表链表的头元素，-1代表链表的尾元素。**覆盖原来的值**

- lrem key count value

    删除count个值为value的元素
    + 如果count大于0，从头向尾遍历并删除count个值为value的元素
    + 如果count小于0，则从尾向头遍历并删除。
    + 如果count等于0，则删除链表中所有等于value的元素。

- linsert key before|after pivot value

    在pivot元素前或者后插入value这个元素。

# 存储sets类型

在Redis中，我们可以将Set类型看作为没有排序的字符集合。

和List不同的是，Set集合中不允许出现重复的元素。和List类型相比，Set在功能上还存在着一个非常重要的特性，即在服务器端完成多个Sets之间的聚合计算操作，如unions、intersections和differences。由于这些操作均在服务端完成，因此效率极高，而且也节省了大量的网络IO开销

- sadd key value1 value2...

    向set中添加数据，如果该key的值已有则不重复添加

- smembers key

    获取set中所有的成员

- scard key

    获取set中成员的数量

- sismember key member

    判断参数中指定的成员是否在该set中，1表示存在，0表示不存在或者该key本身就不存在

- srem key member1 member2...

    删除set中指定的成员

- srandmember key

    随机返回set中的一个成员

- sdiff key1 key2

    返回key1中有，而key2中没有的成员的集合

- sdiffstore destination key1 key2

    将key1、key2相差的成员（key1有，key2没有）存储在destination上

- sinter key[key1,key2…]
    返回交集

- sinterstore destination key1 key2

    将返回的交集存储在destination上

- sunion key1、key2
    返回并集。

- sunionstore destination key1 key2

    将返回的并集存储在destination上

# 存储sortedset

Sorted-Sets和Sets类型极为相似，它们都是字符串的集合，都不允许重复。它们之间的主要差别是Sorted-Sets中的每一个成员都会有一个分数(score)，Redis正是通过分数来为集合中的成员进行从小到大的排序。

在Sorted-Set中添加、删除或更新一个成员都是非常快速的，其时间复杂度为集合中成员数量的对数。因为Sorted-Sets中的成员在集合中的位置是有序的。

- zadd key score member score2 member2...

    将所有成员以及该成员的分数存放到sorted-set中

- zcard key

    获取集合中的成员数量

- zcount key min max

    获取分数在[min,max]之间的成员

- zincrby key increment member

    设置指定成员增加的分数。

- zrange key start end [withscores]

    获取集合中脚标为start-end的成员，[withscores]参数表明返回的成员包含其分数。

- zrangebyscore key min max [withscores] [limit offset count]

    返回分数在[min,max]的成员并按照分数从低到高排序。
    + [withscores]：显示分数；
    + [limit offset count]: 表明从脚标为offset的元素开始并返回count个成员。

- zrank key member

    返回成员在集合中的位置。

- zrem key member[member...]

    移除集合中指定的成员，可以指定多个成员。

- zscore key member

    返回指定成员的分数

# 存储hash

Redis中的Hashes类型可以看成具有String Key和String Value的map容器。

- hset key field value

    为指定的key设定field/value对（键值对）。

- hgetall key

    获取key中的所有filed-vaule

- hget key field

    返回指定的key中的field的值

- hmset key fields

    设置key中的多个filed/value

- hmget key fileds

    获取key中的多个filed的值

- hexists key field

    判断指定的key中的filed是否存在

- hlen key

    获取key所包含的field的数量

- hincrby key field increment

    设置key中filed的值增加increment，如：age增加20

# keys的通用操作

- keys pattern

    获取所有与pattern匹配的key。
    + * 表示任意一个或多个字符
    + ？ 表示任意一个字符

- del key1 key2...

    删除指定key

- exists key

    判断key是否存在。1表示存在，0表示不存在。

- rename key newkey

    重命名key

- expire key

    设置key的过期时间，单位：秒

- ttl key

    获取key距离过期所剩余的时间。如果没有设置过期时间，返回-1；如果已过期，返回-2。

- type key

    获取key的类型。如果key不存在，返回none