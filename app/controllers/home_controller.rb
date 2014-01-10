#encoding: UTF-8
class HomeController < ApplicationController

	def index
		map = %Q{
      function() {
      emit (this.area, {count:1});
      }
    }

    reduce = %Q{
      function(key, values){
      var result = {count :0}
      values.forEach(function (value) {
        result.count += value.count;
      });
      return result;
      }
    }


    statics_temp = Agency#.where(:location.ne =>[])
      .where(:area.ne => nil).map_reduce(map, reduce).out(inline: 1)
    @statics = statics_temp.to_a.sort_by{|r| -r["value"]["count"]}


    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', '城区')
    data_table.new_column('number', '备案数量')
    downtown_count = Agency.downtown.count 
    data_table.add_rows(@statics.count)
    @statics.each_with_index do |area, idx|
      logger.info(area.inspect)
      data_table.set_cell(idx, 0, area['_id'])
      data_table.set_cell(idx, 1, area['value']['count'])
    end
    
    opts   = { :width => 800, :height => 500, :title => '城区备案数量统计',}
    @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', '区域')
    data_table.new_column('number', 'Hours per Day')
    data_table.add_rows(2)
    data_table.set_cell(0, 0, '中心城区'   )
    data_table.set_cell(0, 1, Agency.downtown.count )
    data_table.set_cell(1, 0, '新城区'    )
    data_table.set_cell(1, 1, Agency.suburbs.count  )


    opts = { :width => 800, :height => 400, :title => '区域备案占比', :is3D => true }
    @chart_pie = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
  end

  def downloads
    @names = %w[《武汉市房地产经纪机构数字认证初始申报表》 《武汉市房地产经纪人员数字认证初始申报表》\
     《武汉市房地产经纪机构信息变更表》 《武汉市房地产经纪人员信息变更表》 《武汉市房地产经纪机构数字认证补办表》\
    《武汉市房地产经纪人员数字认证补办表》 《武汉市房地产经纪机构数字认证续期表》 《武汉市房地产经纪机构数字认证续期表》\
     《武汉房地产中介协会专职秘书长应聘报名表》 《二手房买卖业务流程》 《房地产经纪机构及人员变更表格》 《经纪人公示》 《武汉经纪人培训报名表》 《武汉市诚信房地产经纪机构申报表》 《武汉市房地产经纪机构资格备案申报表》 《新设房地产经纪机构备案实地核查表》]
    render 'downloads'
  end
end
