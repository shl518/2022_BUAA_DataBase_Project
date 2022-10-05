<template>
  <div class="app-container">
    <div class="filter-container">
      <el-input
        v-model="listQuery.title"
        placeholder="DishName"
        style="width: 200px;"
        class="filter-item"
        @keyup.enter.native="handleFilter"
      />
      <el-select v-model="listQuery.star" placeholder="Star" clearable style="width: 90px" class="filter-item">
        <el-option v-for="item in starOptions" :key="item" :label="item" :value="item"/>
      </el-select>
      <el-select v-model="listQuery.type" placeholder="Canteen" clearable class="filter-item" style="width: 130px">
        <el-option
          v-for="item in canteenOptions"
          :key="item.key"
          :label="item.display_name+'('+item.key+')'"
          :value="item.key"
        />
      </el-select>
      <el-select v-model="listQuery.sort" style="width: 140px" class="filter-item" @change="handleFilter">
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
        v-loading="listLoading"
        :data="list"
        border
        fit
        highlight-current-row
        style="width: 100%;"
        @sort-change="sortChange"
      >
        <el-table-column
          label="ID"
          prop="id"
          sortable="custom"
          align="center"
          width="90px"
          :class-name="getSortClass('id')"
        >
          <template slot-scope="{row}">
            <span>{{ row.id }}</span>
          </template>
        </el-table-column>
        <el-table-column label="FoodName" width="200px" align="center">
          <template slot-scope="{row}">
            <span>{{ row.dishname }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Canteen" width="200px" align="center">
          <template slot-scope="{row}">
            <span>{{ row.canteen }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Price" width="170px" align="center">
          <template slot-scope="{row}">
            <span>￥{{ row.price }}</span>
          </template>
        </el-table-column>
        <el-table-column v-if="showReviewer" label="Reviewer" width="110px" align="center">
          <template slot-scope="{row}">
            <span style="color:red;">{{ row.reviewer }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Star" width="180px" align="center">
          <template slot-scope="{row}">
            <svg-icon v-for="n in + row.star" :key="n" icon-class="star" class="meta-item__icon"/>
          </template>
        </el-table-column>
        <el-table-column label="Comments" align="center" width="200px">
          <template slot-scope="{row}">
            <span v-if="row.comment" class="link-type"
                  @click="handleUpdateComment">{{ row.comment }}</span>
            <span v-else>0</span>
          </template>
        </el-table-column>

        <el-table-column label="Actions" align="center" width="385px" class-name="small-padding fixed-width">
          <template slot-scope="{row,$index}">
            <el-button type="primary" size="mini" @click="handleUpdate(row)">
              Edit
            </el-button>
            <el-button
              v-if="row.status!='published'"
              size="mini"
              type="success"
              @click="handleModifyStatus(row,'published')"
            >
              Publish
            </el-button>
            <el-button v-if="row.status!='draft'" size="mini" @click="handleModifyStatus(row,'draft')">
              Draft
            </el-button>
            <el-button v-if="row.status!='deleted'" size="mini" type="danger" @click="handleDelete(row,$index)">
              Delete
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="listQuery.page"
      :limit.sync="listQuery.limit"
      @pagination="getList"
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
        <el-form-item label="Dishname" prop="dishname">
          <el-input v-model="temp.dishname"/>
        </el-form-item>
        <el-form-item label="Canteen" prop="canteen">
          <el-select v-model="temp.canteen" class="filter-item" placeholder="Please select">
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
        <el-form-item label="Price" prop="price">
          <font style="font-size: large;padding-right: 5px">￥</font>
          <el-input placeholder="00.00" style="width: 150px" v-model="temp.price"></el-input>
        </el-form-item>

        <el-form-item label="Star">
          <el-rate
            v-model="temp.star"
            :colors="['#99A9BF',
                      '#F7BA2A',
                      '#FF9900',
                      '#FF7A00',
                      '#FF3D00']"
            :max="5"
            style="margin-top:8px;"
            show-text="true"
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
import {fetchList, fetchDish, createDish, updateDish, deleteDish} from '@/api/dish'
import waves from '@/directive/waves' // waves directive
import {parseTime} from '@/utils'
import Pagination from '@/components/Pagination' // secondary package based on el-pagination

const canteenOptions = [
  {key: '合一', display_name: '合一'},
  {key: '学二', display_name: '学二'},
  {key: '新北', display_name: '新北'}
]

// arr to obj, such as { CN : "China", US : "USA" }

const canteenTypeKeyValue = canteenOptions.reduce((acc, cur) => {
  acc[cur.key] = cur.display_name
  return acc
}, {})

const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/;
const validateMoney = (rule, value, callback) => {
  rule = MoneyTest
  if (rule.test(value)) {
    callback();
  } else {
    callback("price must be a number with two decimal places")
  }
}
export default {
  name: 'ComplexTable',
  components: {Pagination},
  directives: {waves},
  filters: {
    statusFilter(status) {
      const statusMap = {
        published: 'success',
        draft: 'info',
        deleted: 'danger'
      }
      return statusMap[status]
    },
    canteenFilter(canteen) {
      return canteenTypeKeyValue[canteen]
    }
  },
  data() {
    return {
      tableKey: 0,
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 20,
        star: undefined,
        dishname: undefined,
        canteen: undefined,
        sort: '+id'
      },
      starOptions: [1, 2, 3, 4, 5],
      canteenOptions,
      sortOptions: [{label: 'ID Ascending', key: '+id'}, {label: 'ID Descending', key: '-id'}],
      showReviewer: false,
      temp: {
        id: undefined,
        dishname: '',
        price: Number(0.00),
        star: 1,
        canteen: '',
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
        canteen: [{required: true, message: 'canteen is required', trigger: 'change'}],
        timestamp: [{type: 'date', required: true, message: 'timestamp is required', trigger: 'change'}],
        price: [{validator:validateMoney, message: 'price must be a number with two decimal places',trigger: 'blur'},
          {required: true, message: 'price is required', trigger: 'blur'}],
        dishname: [{required: true, message: 'dishname is required', trigger: 'blur'}]
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
        this.list = response.data.items
        this.total = response.data.total

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
      const {prop, order} = data
      if (prop === 'id') {
        this.sortByID(order)
      }
    },
    sortByID(order) {
      if (order === 'ascending') {
        this.listQuery.sort = '+id'
      } else {
        this.listQuery.sort = '-id'
      }
      this.handleFilter()
    },
    resetTemp() {
      this.temp = {
        id: undefined,
        dishname: '',
        price: 0,
        star: 1,
        timestamp: new Date(),
        canteen: ''
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
          this.temp.id = parseInt(Math.random() * 100) + 1024 // mock a id
          this.temp.canteen = '学二'
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
            const index = this.list.findIndex(v => v.id === this.temp.id)
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
      this.$notify({
        title: 'Success',
        message: 'Delete Successfully',
        type: 'success',
        duration: 2000
      })
      this.list.splice(index, 1)
      deleteDish()
    },
    handleUpdateComment(row) {
      this.commentDialogStatus = true;
    },
    handleDownload() {
      this.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader = ['timestamp', 'dishname', 'canteen', 'star', 'status']
        const filterVal = ['timestamp', 'dishname', 'canteen', 'star', 'status']
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
          return parseTime(v[j])
        } else {
          return v[j]
        }
      }))
    },
    getSortClass: function (key) {
      const sort = this.listQuery.sort
      return sort === `+${key}` ? 'ascending' : 'descending'
    }
  }
}
</script>
