#此文件用于测试远端数据库，与项目无关系
import pymysql
db = pymysql.connect(host="124.220.153.34", user="root",
                     password="123456", database="Book",
                     port=3306, charset='utf8')
cursor = db.cursor()
cursor.execute("insert into somebook(id,name,author) values (null ,'szy2','szyszy2')")
db.commit()