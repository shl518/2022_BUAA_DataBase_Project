const Mock = require('mockjs')
const url = require("url");

const List = []
const count = 100

const baseContent = '<p>I am testing data, I am testing data.</p><p><img src="https://wpimg.wallstcn.com/4c69009c-0fd4-4153-b112-6cb53d1cf943"></p>'
const image_uri = 'https://wpimg.wallstcn.com/e4558086-631c-425c-9430-56ffb46e70b3'

Mock.Random.extend({
  dishname: function () {
    var dish = ['饺子', '米饭', '面条']
    return this.pick(dish)
  }
})

Mock.Random.extend({
  canteen: function () {
    var canteen = ['合一', '学二', '新北']
    return this.pick(canteen)
  }
})

for (let i = 0; i < count; i++) {
  List.push(Mock.mock({
    id: '@increment',
    dishname: '@dishname',  // as title
    price: '@integer(8,30)',
    canteen: '@canteen',  // as type
    star: '@integer(1, 5)',   // as importance
    pictureid: '@integer(1,100)',
    image_uri,
  }))
}

module.exports = [
  {
    // 符合检索条件的展示页面
    url: '/vue-element-admin/dish/list',
    type: 'get',
    response: config => {
      const {importance: star, canteen, title: dishname, page = 1, limit = 20, sort} = config.query

      let mockList = List.filter(item => {
        if (star && item.star !== +star) return false
        if (canteen && item.canteen !== canteen) return false
        if (dishname && item.dishname.indexOf(dishname) < 0) return false
        return true
      })

      if (sort === '-id') {
        mockList = mockList.reverse()
      }

      const pageList = mockList.filter((item, index) => index < limit * page && index >= limit * (page - 1))

      return {
        code: 20000,
        data: {
          total: mockList.length,
          items: pageList
        }
      }
    }
  },

  {
    // detail dialog
    url: '/vue-element-admin/dish/detail',
    type: 'get',
    response: config => {
      const {id} = config.query
      for (const dishname of List) {
        if (dishname.id === +id) {
          return {
            code: 20000,
            data: dishname
          }
        }
      }
    }
  },

  {
    url: '/vue-element-admin/dish/create',
    type: 'post',
    response: _ => {
      return {
        code: 20000,
        data: 'success'
      }
    }
  },

  {
    url: '/vue-element-admin/dish/update',
    type: 'post',
    response: _ => {
      return {
        code: 20000,
        data: 'success'
      }
    }
  }
]

