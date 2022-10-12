<template>
  <div class="app-container">
    <div class="filter-container">
      <el-input
        v-model="listQuery.dish_name"
        placeholder="DishName"
        style="width: 200px;"
        class="filter-item"
        @keyup.enter.native="handleFilter"
      />
      <el-select v-model="listQuery.dish_star" placeholder="Star" clearable style="width: 90px" class="filter-item">
        <el-option v-for="item in starOptions" :key="item" :label="item" :value="item"/>
      </el-select>
      <el-select v-model="listQuery.canteen_name" placeholder="Canteen" clearable class="filter-item" style="width: 130px">
        <el-option
          v-for="item in canteenOptions"
          :key="item.key"
          :label="item.display_name+'('+item.key+')'"
          :value="item.key"
        />
      </el-select>
      <el-select v-model="listQuery.sort_by_id" style="width: 140px" class="filter-item" @change="handleFilter">
        <el-option v-for="item in sortOptions" :key="item.key" :label="item.label" :value="item.key"/>
      </el-select>
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        Search
      </el-button>
      <el-button
        class="filter-item"
        style="margin-left: 10px;"
        type="primary"
        icon="el-icon-edit"
        @click="handleCreate"
      >
        Add
      </el-button>
      <!--
      <el-button
        v-waves
        :loading="downloadLoading"
        class="filter-item"
        type="primary"
        icon="el-icon-download"
        @click="handleDownload"
      >
        Export
      </el-button>
      -->
      <!--
      <el-checkbox v-model="showReviewer" class="filter-item" style="margin-left:15px;" @change="tableKey=tableKey+1">
        reviewer
      </el-checkbox>
      -->
    </div>
    <div class="table-container">
      <el-table
        :key="tableKey"
        :v-loading="listLoading"
        :data="list"
        border
        fit
        highlight-current-row
        style="width: 100%;"
        @sort-change="sortChange"
      >
        <el-table-column
          label="ID"
          prop="dish_id"
          sortable="custom"
          align="center"
          width="90px"
          :class-name="getSortClass('dish_id')"
        >
          <template v-slot="{row}">
            <span>{{ row.dish_id }}</span>
          </template>
        </el-table-column>
        <el-table-column label="FoodName" width="200px" align="center">
          <template v-slot="{row}">
            <span>{{ row.dish_name }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Canteen" width="200px" align="center">
          <template v-slot="{row}">
            <span>{{ row.canteen_name }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Price" width="170px" align="center">
          <template v-slot="{row}">
            <span>￥{{ row.dish_price }}</span>
          </template>
        </el-table-column>
        <el-table-column v-if="showReviewer" label="Reviewer" width="110px" align="center">
          <template v-slot="{row}">
            <span style="color:red;">{{ row.reviewer }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Star" width="180px" align="center">
          <template v-slot="{row}">
            <svg-icon v-for="n in + row.dish_star" :key="n" icon-class="star" class="meta-item__icon"/>
          </template>
        </el-table-column>
        <el-table-column label="Comments" align="center" width="200px">
          <template v-slot="{row}">
            <span v-if="row.comment" class="link-type"
                  @click="handleUpdateComment"
            >{{ row.comment }}</span>
            <span v-else>0</span>
          </template>
        </el-table-column>

        <el-table-column label="Actions" align="center" width="385px" class-name="small-padding fixed-width">
          <template v-slot="{row,$index}">
            <el-button type="primary" size="mini" @click="handleUpdate(row)">
              Edit
            </el-button>
            <el-button
              v-if="row.status!=='published'"
              size="mini"
              type="success"
              @click="handleModifyStatus(row,'published')"
            >
              Publish
            </el-button>
            <el-button v-if="row.status!=='draft'" size="mini" @click="handleModifyStatus(row,'draft')">
              Draft
            </el-button>
            <el-button v-if="row.status!=='deleted'" size="mini" type="danger" @click="handleDelete(row,$index)">
              Delete
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <pagination
      v-show="list_length>0"
      :page.sync="listQuery.page"
      :limit.sync="listQuery.limit"
      @pagination="getList"
      total="list_length"
    />

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible" width="500px">
      <el-form
        ref="dataForm"
        :rules="rules"
        :model="temp"
        label-position="left"
        label-width="120px"
        style="width: 300px; margin-left:50px;"
      >
        <el-form-item label="DishName" prop="dish_name">
          <el-input v-model="temp.dish_name"/>
        </el-form-item>
        <el-form-item label="Canteen" prop="canteen_name">
          <el-select v-model="temp.canteen_name" class="filter-item" placeholder="Please select">
            <el-option
              v-for="item in canteenOptions"
              :key="item.key"
              :label="item.display_name"
              :value="item.key"
            />
          </el-select>
        </el-form-item>
        <!--
        <el-form-item label="Date" prop="timestamp">
          <el-date-picker v-model="temp.timestamp" type="datetime" placeholder="Please pick a date"/>
        </el-form-item>
        -->
        <el-form-item label="Price" prop="dish_price">
          <span style="font-size: large;padding-right: 5px">￥</span>
          <el-input placeholder="00.00" style="width: 150px" v-model="temp.dish_price"></el-input>
        </el-form-item>

        <el-form-item label="Star">
          <el-rate
            v-model="temp.dish_star"
            :colors="['#99A9BF',
                      '#F7BA2A',
                      '#FF9900',
                      '#FF7A00',
                      '#FF3D00']"
            :max="5"
            style="margin-top:8px;"
            show-text
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">
          Cancel
        </el-button>
        <el-button type="primary" @click="dialogStatus==='create'?createData():updateData()">
          Confirm
        </el-button>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="dialogPvVisible" title="Reading statistics">
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="dialogPvVisible = false">Confirm</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { fetchList, fetchDish, createDish, updateDish, deleteDish } from '@/api/dish'
import waves from '@/directive/waves' // waves directive
import { parseTime } from '@/utils'
import Pagination from '@/components/Pagination'
import item from '@/layout/components/Sidebar/Item' // secondary package based on el-pagination

const canteenOptions = [
  { key: '合一', display_name: '合一' },
  { key: '学二', display_name: '学二' },
  { key: '新北', display_name: '新北' }
]

// arr to obj, such as { CN : "China", US : "USA" }

const canteenTypeKeyValue = canteenOptions.reduce((acc, cur) => {
  acc[cur.key] = cur.display_name
  return acc
}, {})

const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2})?$/
const validateMoney = (rule, value, callback) => {
  rule = MoneyTest
  if (rule.test(value)) {
    callback()
  } else {
    callback('price must be a number with two decimal places')
  }
}
const pageList = (list, page, limit) => {
  return list.filter((item, index)=>index < limit * page && index >= limit * (page - 1))
}
export default {
  name: 'ComplexTable',
  components: { Pagination },
  directives: { waves },
  filters: {
    statusFilter(status) {
      const statusMap = {
        published: 'success',
        draft: 'info',
        deleted: 'danger'
      }
      return statusMap[status]
    },
    canteenFilter(canteen_name) {
      return canteenTypeKeyValue[canteen_name]
    },

  },
  data() {
    return {
      tableKey: 0,
      list: null,
      list_items: [],
      list_length: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 20,
        dish_star: undefined,
        dish_name: undefined,
        canteen_name: undefined,
        sort_by_id: '+id'
      },
      starOptions: [1, 2, 3, 4, 5],
      canteenOptions,
      sortOptions: [{ label: 'ID Ascending', key: '+id' }, { label: 'ID Descending', key: '-id' }],
      showReviewer: false,
      temp: {
        dish_id: undefined,
        dish_name: '',
        dish_price: Number(0.00),
        dish_star: 1,
        canteen_name: '',
        timestamp: new Date(),
        comment: 0
      },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: 'Edit',
        create: 'Create'
      },
      dialogPvVisible: false,

      rules: {
        canteen_name: [{ required: true, message: 'canteen is required', trigger: 'change' }],
        timestamp: [{ type: 'date', required: true, message: 'timestamp is required', trigger: 'change' }],
        dish_price: [{
          validator: validateMoney,
          message: 'price must be a number with two decimal places',
          trigger: 'blur'
        },
          { required: true, message: 'price is required', trigger: 'blur' }],
        dish_name: [{ required: true, message: 'dish_name is required', trigger: 'blur' }]
      },
      downloadLoading: false
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.listLoading = true
      fetchList(this.listQuery).then(response => {
        this.list = pageList(response.data.list_items, this.listQuery.page, this.listQuery.limit)
        this.list_length = response.data.list_length
        // Just to simulate the time of the request
        setTimeout(() => {
          this.listLoading = false
        }, 1.5 * 1000)
      })
    },
    handleFilter() {
      this.listQuery.page = 1
      this.getList()
    },
    handleModifyStatus(row, status) {
      this.$message({
        message: '操作Success',
        type: 'success'
      })
      row.status = status
    },
    sortChange(data) {
      const { prop, order } = data
      if (prop === 'dish_id') {
        this.sortByID(order)
      }
    },
    sortByID(order) {
      if (order === 'ascending') {
        this.listQuery.sort_by_id = '+id'
      } else {
        this.listQuery.sort_by_id = '-id'
      }
      this.handleFilter()
    },
    resetTemp() {
      this.temp = {
        dish_id: undefined,
        dish_name: '',
        dish_price: 0,
        dish_star: 1,
        timestamp: new Date(),
        canteen_name: ''
      }
    },
    handleCreate() {
      this.resetTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    createData() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          // this.temp.dish_id = parseInt(Math.random() * 100) + 1024 // mock a id
          createDish(this.temp).then(() => {
            this.list.unshift(this.temp)
            this.dialogFormVisible = false
            this.$notify({
              title: 'Success',
              message: 'Created Successfully',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    handleUpdate(row) {
      this.temp = Object.assign({}, row) // copy obj
      this.temp.timestamp = new Date(this.temp.timestamp)
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    updateData() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          const tempData = Object.assign({}, this.temp)
          tempData.timestamp = +new Date(tempData.timestamp) // change Thu Nov 30 2017 16:41:05 GMT+0800 (CST) to 1512031311464
          updateDish(tempData).then(() => {
            const index = this.list.findIndex(v => v.dish_id === this.temp.dish_id)
            this.list.splice(index, 1, this.temp)
            this.dialogFormVisible = false
            this.$notify({
              title: 'Success',
              message: 'Update Successfully',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    handleDelete(row, index) {
      this.temp = Object.assign({}, row)
      let Did = {
        dish_id: this.temp.dish_id
      }
      deleteDish(Did).then(() => {
          this.list.splice(index, 1)
        }
      )
      this.$notify({
        title: 'Success',
        message: 'Delete Successfully',
        type: 'success',
        duration: 2000
      })
    },
    handleUpdateComment(row) {
      this.commentDialogStatus = true
    },
    handleDownload() {
      this.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader = ['timestamp', 'dish_name', 'canteen_name', 'dish_star', 'status']
        const filterVal = ['timestamp', 'dish_name', 'canteen_name', 'dish_star', 'status']
        const data = this.formatJson(filterVal)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'table-list'
        })
        this.downloadLoading = false
      })
    },
    formatJson(filterVal) {
      return this.list.map(v => filterVal.map(j => {
        if (j === 'timestamp') {
          return parseTime(v[j], '')
        } else {
          return v[j]
        }
      }))
    },
    getSortClass: function(key) {
      const sort = this.listQuery.sort_by_id
      return sort === `+${key}` ? 'ascending' : 'descending'
    }
  }
}
</script>
