# encoding: UTF-8
namespace :db do
	desc "增加明星经纪人"
	task :add_stars => :environment do 
		tag = "2011年武汉市房地产销售明星(一星级)"
		people = [
			{:name =>'谢刚', :org => '武汉市华明达房地产信息咨询有限公司'},
			{:name =>'黄惠进', :org => '武汉世纪芳华房地产经纪有限公司'},
			{:name =>'徐康', :org => '武汉康辉房地产咨询有限公司'},
			{:name =>'宋达', :org => '顺驰置业武汉有限公司'},
			{:name =>'赵裔群', :org => '武汉百家居房地产信息咨询有限公司'},
			{:name =>'陈士江', :org => '武汉福瑞居房地产代理有限公司'},
			{:name =>'陈亚洲', :org => '武汉福瑞居房地产代理有限公司'},
			{:name =>'张松', :org => '武汉市尚居不动产代理有限公司'},
			{:name =>'王瑜皓', :org => '武汉亿房房地产咨询有限责任公司'},
			{:name =>'杨洲', :org => '武汉仁和地产经纪有限公司'},
		]
		people.each do |person|
			a = Agency.first(:conditions => {:bname => person[:org]})
			if a.nil? then 
				next
			end
			b = a.brokers.where({:name => person[:name]}).first
			if not b.nil? then 
				b.awards_array = [tag]
				b.save
			end
		end

		tag = "2011年武汉市房地产销售明星(二星级)"
		people = [{:name =>'王天兵', :org => '武汉市百居易房地产经营咨询有限公司'},
			{:name =>'张小平', :org => '武汉市志城易居房地产代理有限公司'},
			{:name =>'向娟娟', :org => '武汉康辉房地产咨询有限公司'},
			{:name =>'胡焕堋', :org => '武汉渡边房地产营销策划有限公司'},
		]
		people.each do |person|
			a = Agency.first(:conditions => {:bname => person[:org]})
			if a.nil? then 
				next
			end
			b = a.brokers.where({:name => person[:name]}).first
			if not b.nil? then 
				b.awards_array = [tag]
				b.save
			end
		end

	end
end