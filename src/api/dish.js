import request from '@/utils/request'

export function fetchList(query) {
  return request({
    url: '/vue-element-admin/dish/list',
    method: 'get',
    params: query
  })
}

export function fetchDish(id) {
  return request({
    url: '/vue-element-admin/dish/detail',
    method: 'get',
    params: { id }
  })
}

export function createDish(data) {
  return request({
    url: '/vue-element-admin/dish/create',
    method: 'post',
    data
  })
}

export function updateDish(data) {
  return request({
    url: '/vue-element-admin/dish/update',
    method: 'post',
    data
  })
}
