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
    varr = []
    tarr = [] 

    @statics.each_with_index do |area, idx|
      varr << area['value']['count']
      tarr << "'#{area['_id']}'"
    end
    @statics_varr = varr * ','
    @statics_tarr = tarr * ','
    
    @chart ="#{Agency.downtown.count}, #{Agency.suburbs.count }"
  end

  def downloads
    @names = %w[《武汉市房地产经纪机构数字认证初始申报表》 《武汉市房地产经纪人员数字认证初始申报表》\
     《武汉市房地产经纪机构信息变更表》 《武汉市房地产经纪人员信息变更表》 《武汉市房地产经纪机构数字认证补办表》\
    《武汉市房地产经纪人员数字认证补办表》 《武汉市房地产经纪机构数字认证续期表》 《武汉市房地产经纪机构数字认证续期表》\
     《武汉房地产中介协会专职秘书长应聘报名表》 《二手房买卖业务流程》 《房地产经纪机构及人员变更表格》 《经纪人公示》 《武汉经纪人培训报名表》 《武汉市诚信房地产经纪机构申报表》 《武汉市房地产经纪机构资格备案申报表》 《新设房地产经纪机构备案实地核查表》]
    render 'downloads'
  end
end
