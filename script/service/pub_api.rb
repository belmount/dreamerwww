# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'rubygems'
require 'sinatra'
require 'digest/md5'
require 'json'
require 'mongo'
require 'sinatra/contrib'

set :port, 5454
set :bind, '0.0.0.0'

before do
	content_type :txt
end

DB_NAME = 'estatee'

namespace '/api' do 
	post '/new_agency_pub' do 
		jdata = request.body.read
		puts jdata.inspect

		data = JSON.parse(jdata)
		
		
		

		conn = Mongo::Connection.new
		db   = conn[DB_NAME]
		agency = db['agency']
		target = agency.find_one({"bname"=>data["bname"]})
		awards_array = target.nil? ? nil : target['awards_array']
		agency.remove({"bname" => data["bname"]})
	#经纪人（整合同步接口）
		data2=data["brokers"].dup
		data.delete "brokers"
		puts data.inspect
		id = agency.insert(data, :safe => true)
		if not awards_array.nil? then 
			agency.update({'_id'=>id}, {'$set'=>{'awards_array'=>awards_array}})
	  end
		aa=db['broker']
	 	aa.remove("belong_to" => data["guid"])
		data2.each{|n|
			n[:agency_id]=id
			id2=aa.insert(n)
			puts n
		}
	#经纪人
		#md5=Digest::MD5.hexdigest("#{data[:name]}#{data[]}www.superidea.com.cn")
		#md5=Digest::MD5.hexdigest("#{formal_data}www.superidea.com.cn")
		puts agency.find({"bname" => data["bname"]}).count
		{:result => 'Success'}.to_json
		#puts data
	end

	#经纪人(单独同步接口)
	post '/new_borker_pub' do 
		jdata = request.body.read
		puts jdata.inspect

		data = JSON.parse(jdata)

		puts data.inspect

		conn = Mongo::Connection.new
		db   = conn[DB_NAME]
		broker = db['broker']

		broker.remove({"guid" => data["guid"]})
		agency = db['agency']
		agency_id = agency.find({"guid" =>data['belong_to']}).first()['_id']
		data[:agency_id]=agency_id
		id = broker.insert(data)
		#md5=Digest::MD5.hexdigest("#{data[:name]}#{data[]}www.superidea.com.cn")
		#md5=Digest::MD5.hexdigest("#{formal_data}www.superidea.com.cn")
		puts broker.find({"guid" => data["guid"]}).count
		{:result => 'Success'}.to_json
		#puts data
	end


	#挂牌信息，不更改字段名
	post '/new_gpinfo_pub' do 
		jdata = request.body.read
		puts jdata.inspect

		data = JSON.parse(jdata)

		puts data.inspect

		conn = Mongo::Connection.new
		db   = conn[DB_NAME]
		gpinfo = db['gpinfo']

		gpinfo.remove({"gpxxid" => data["gpxxid"]})
		id = gpinfo.insert(data)

		#md5=Digest::MD5.hexdigest("#{data[:name]}#{data[]}www.superidea.com.cn")
		#md5=Digest::MD5.hexdigest("#{formal_data}www.superidea.com.cn")
		puts gpinfo.find({"gpxxid" => data["gpxxid"]}).count
		#{:result => 'Success'}.to_json
		{:result => 'Success',:id=>data["gpxxid"]}.to_json
		#puts data
	end

	#挂牌信息，转换字段名
	post '/new_gpinfos_pub' do 
		jdata = request.body.read
		

		data = JSON.parse(jdata)
		puts data.to_json

		datas={:pubid => data["gpxxid"], :region => data["fwszqy"], :villa => data["xqmc"], :type=>data["fwxz"],
			:area =>data["fwjzmj"], :total_stage => data["fwzcs"], :stage=>data["lc"], :built_year => data["jznf"], 
			:rooms => data["fx"], :orientation => data["cx"], :traffic=>data["jtzk"], 
			:structue => data["jg"], :infracture => data["jbss"], :price => data["fwnzrjg"],
			:price_per_square => data["dj"], :end_at =>data["zjfwjssj"],
			:pub_at => data["gpsj"], :image_1=>data["tu1"], :image_2=>data["tu2"] , :image_3=>data["tu3"], 
			:images => data["tu1"].split('|'),
			:location => data["location"],
			:totalprice => data["fwnzrjg"], 
			:exclusive => data["djwt"], :broker_name => data["zjr"], :contactway => data["zjrlxfs"],
			:others => data["qtxx"], :contract => data["wthtid"], :state => data["gpzt"], :management => data["wyglqk"], 
			:contracttypes => data["hetlx"],
			:brokerid => data["jjrid"], :intermediary => data["jjjgid"], :address => data["fwzl"]
		}

		puts datas.inspect
		conn = Mongo::Connection.new
		db   = conn[DB_NAME]
		gpinfos = db['gpinfos']

		gpinfos.remove({"pubid" => data["gpxxid"]})

    # create connection between estate and publish broker and agency
    broker = db['broker'].find({"guid"=>data["jjrrid"]}).to_a
    if broker.nil? or broker.length == 0  then 
   		datas["broker_id"] = nil
   	else
   		datas["broker_id"] = broker[0]["_id"]
   	end
		id = gpinfos.insert(datas)

		agency_id = db['agency'].find({"guid"=>data[:intermediary]})

		#md5=Digest::MD5.hexdigest("#{data[:name]}#{data[]}www.superidea.com.cn")
		#md5=Digest::MD5.hexdigest("#{formal_data}www.superidea.com.cn")
		puts gpinfos.find({"pubid" => data["gpxxid"]}).count
		#{:result => 'Success'}.to_json
		{:result => 'Success',:id=>data["gpxxid"]}.to_json
		#puts data
	end

	#挂牌信息查询数据管理
	post '/new_gpinfosearch_pub' do 
		jdata = request.body.read
		puts jdata.inspect

		data = JSON.parse(jdata)

		puts data.inspect

		conn = Mongo::Connection.new
		db   = conn[DB_NAME]
		gpinfosearch = db['gpinfosearch']

		gpinfosearch.remove({"guid" => data["guid"]})
		id = gpinfosearch.insert(data)
		#md5=Digest::MD5.hexdigest("#{data[:name]}#{data[]}www.superidea.com.cn")
		#md5=Digest::MD5.hexdigest("#{formal_data}www.superidea.com.cn")
		puts gpinfosearch.find({"guid" => data["guid"]}).count
		{:result => 'Success'}.to_json
		#puts data
	end


	get '/test' do 
		"test api connection"
	end 

end 
configure do 
	set :show_exceptions, false
end

error do 
	{:result => 'Error'}.to_json
end


# test with
# curl -X POST  -d @test.txt http://127.0.0.1:4567/new_agency_pub -H "Content-Type: application/json; charset=UTF-8"
