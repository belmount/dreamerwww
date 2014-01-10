# encoding: UTF-8
namespace :db do
	desc "增加测试数据"
	task :add_test_data => :environment do 
		name = '武汉百居易房地产经营咨询有限公司'
		a = Agency.first(:conditions => {:bname => name})
		a['complain_cnt'] = 0
		b = a.brokers.where({:name => '韩威'}).first
		b.awards_array << '房地产销售明星(二星)'
		c = a.brokers.where({:name => '耿开明'}).first
		c.awards_array << '房地产销售明星(一星)'
		a.save
		b.save
		c.save
  	end

  	desc "删除测试数据"
	task :remove_test_data => :environment do 
		name = '武汉百居易房地产经营咨询有限公司'
		a = Agency.first(:conditions => {:bname => name})
		a['complain_cnt'] = 0
		b = a.brokers.where({:name => '韩威'}).first
		b.awards = ''
		a.save
		b.save
  	end
end