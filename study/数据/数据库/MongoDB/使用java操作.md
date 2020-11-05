```java
public class MongoDBDao
{

    @Test
    public void testAdd() throws UnknownHostException
    {
        // 获取链接
        MongoClient mongoClient = new MongoClient("localhost", 3333);
        // 获取数据库
        MongoDatabase database = mongoClient.getDatabase("test");
        // 进入某个文档集
        MongoCollection<Document> collection = database.getCollection("pp");

        // 创建新文档
        Document doc = new Document("name", "MongoDB")
                .append("type", "database").append("count", 1)
                .append("info", new Document("x", 203).append("y", 102));
        // 将文档插入文档集合
        collection.insertOne(doc);

        // 创建一个包含多个文档的列表
        List<Document> documents = new ArrayList<Document>();
        for (int i = 0; i < 100; i++)
        {
            documents.add(new Document("i", i));
        }
        // 向文档中插入列表
        collection.insertMany(documents);

        // 关闭数据库连接
        mongoClient.close();
    }

    @Test
    public void testFind() throws UnknownHostException
    {
        // 获取链接
        MongoClient mongoClient = new MongoClient("localhost", 3333);
        // 获取数据库
        MongoDatabase database = mongoClient.getDatabase("test");
        // 进入某个文档集
        MongoCollection<Document> collection = database.getCollection("pp");

        // 显示集合中的文档的数量
        System.out.println(collection.count());

        // 查询集合中的第一个文档
        Document myDoc = collection.find().first();
        System.out.println(myDoc.toJson());

        //获取集合中的全部文档
        MongoCursor<Document> cursor = collection.find().iterator();
        try
        {
            while (cursor.hasNext())
            {
                System.out.println(cursor.next().toJson());
            }
        }
        finally
        {
            cursor.close();
        }

        //获取全部文档的另一种方法
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 根据条件获取某分文档 eq:==
        Document myDoc1 = collection.find(Filters.eq("i", 71)).first();
        System.out.println(myDoc1.toJson());

        // 通过查询语句一次性获取多个数据
        Block<Document> printBlock = new Block<Document>()
        {
            @Override
            public void apply(final Document document)
            {
                System.out.println(document.toJson());
            }
        };
        // 获得所有大于50的
        collection.find(Filters.gt("i", 50)).forEach(printBlock);
        // 大于50 小于 100
        collection.find(Filters.and(Filters.gt("i", 50), Filters.lte("i", 100))).forEach(printBlock);

        // 对输出文档进行排序,-1为递减，1为递增
        // 官方文档的例子有误：http://mongodb.github.io/mongo-java-driver/3.0/driver/getting-started/quick-tour/#sorting-documents
        Document myDoc2 = collection.find(Filters.exists("i"))
                .sort(new BasicDBObject("i", -1)).first();
        System.out.println(myDoc2.toJson());

        // 选择性输出结果中的元素，0为不显示，1为显示
        // 官方文档中的例子又不能用：http://mongodb.github.io/mongo-java-driver/3.0/driver/getting-started/quick-tour/#projecting-fields
        BasicDBObject exclude = new BasicDBObject();
        exclude.append("_id", 0);
        exclude.append("name", 1);
        exclude.append("info", 1);
        Document myDoc3 = collection.find().projection(exclude).first();
        System.out.println(myDoc3.toJson());

        // 关闭数据库连接
        mongoClient.close();
    }

    @Test
    public void testUpdate() throws UnknownHostException
    {
        // 获取链接
        MongoClient mongoClient = new MongoClient("localhost", 3333);
        // 获取数据库
        MongoDatabase database = mongoClient.getDatabase("test");
        // 进入某个文档集
        MongoCollection<Document> collection = database.getCollection("pp");

        // 修改时的参数：
        // $inc 对指定的元素加
        // $mul 乘
        // $rename 修改元素名称
        // $setOnInsert 如果以前没有这个元素则增加这个元素，否则不作任何更改
        // $set 修改制定元素的值
        // $unset 移除特定的元素
        // $min 如果原始数据更大则不修改，否则修改为指定的值
        // $max 与$min相反
        // $currentDate 修改为目前的时间

        //修改第一个符合条件的数据
        //$set 为修改
        collection.updateOne(Filters.eq("i", 10), new Document("$set", new Document("i", 110)));
        // 获取全部文档,可以看到以前10的地方变成了110
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 批量修改数据并且返回修改的结果，将所有小于100的结果都加100
        UpdateResult updateResult =
                collection.updateMany(Filters.lt("i", 100), new Document("$inc", new Document("i", 100)));
        // 显示发生变化的行数
        System.out.println(updateResult.getModifiedCount());
        // 获取全部文档,可以看到除了刚才修改的110其他的全为了100
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 关闭数据库连接
        mongoClient.close();
    }

    @Test
    public void testDelete() throws UnknownHostException
    {
        // 获取链接
        MongoClient mongoClient = new MongoClient("localhost", 3333);
        // 获取数据库
        MongoDatabase database = mongoClient.getDatabase("test");
        // 进入某个文档集
        MongoCollection<Document> collection = database.getCollection("pp");

        // 删除第一个符合条件的数据
        collection.deleteOne(Filters.eq("i", 110));
        // 获取全部文档,可以看到没有110这个数了
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 删除所有符合条件的数据，并且返回结果
        DeleteResult deleteResult = collection.deleteMany(Filters.gte("i", 100));
        // 输出删除的行数
        System.out.println(deleteResult.getDeletedCount());
        // 获取全部文档,所有i>=100的数据都没了
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 关闭数据库连接
        mongoClient.close();
    }

    @Test
    public void testMulOpera() throws UnknownHostException
    {
        // 获取链接
        MongoClient mongoClient = new MongoClient("localhost", 3333);
        // 获取数据库
        MongoDatabase database = mongoClient.getDatabase("test");
        // 进入某个文档集
        MongoCollection<Document> collection = database.getCollection("pp");

        // 按照语句先后顺序执行
        collection.bulkWrite(Arrays.asList(new InsertOneModel<Document>(new Document("_id", 4)),
                new InsertOneModel<Document>(new Document("_id", 5)),
                new InsertOneModel<Document>(new Document("_id", 6)),
                new UpdateOneModel<Document>(new Document("_id", 1), new Document("$set", new Document("x", 2))),
                new DeleteOneModel<Document>(new Document("_id", 2)),
                new ReplaceOneModel<Document>(new Document("_id", 3), new Document("_id", 3).append("x", 4))));

        // 获取全部文档
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 不按照语句先后顺序执行
        collection.bulkWrite(Arrays.asList(new InsertOneModel<Document>(new Document("_id", 4)),
                new InsertOneModel<Document>(new Document("_id", 5)),
                new InsertOneModel<Document>(new Document("_id", 6)),
                new UpdateOneModel<Document>(new Document("_id", 1), new Document("$set", new Document("x", 2))),
                new DeleteOneModel<Document>(new Document("_id", 2)),
                new ReplaceOneModel<Document>(new Document("_id", 3), new Document("_id", 3).append("x", 4))),
                new BulkWriteOptions().ordered(false));

        //获取全部文档
        for (Document cur : collection.find())
        {
            System.out.println(cur.toJson());
        }

        // 关闭数据库连接
        mongoClient.close();
    }
}
```

