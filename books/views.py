from django.shortcuts import render

from django.db import connection


def index(request):
    cursor = connection.cursor()
    # 要想使用sql原生语句，必须用到execute()函数
    # 然后在里面写入sql原生语句
    cursor.execute("insert into somebook(id,name,author) values (null ,'szy2','szyszy2')")
    return render(request, 'index.html')
