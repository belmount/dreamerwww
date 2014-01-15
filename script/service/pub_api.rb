# encoding: utf-8
# revision by feng.bai at 2014/01/15
# using mongoid instead of mongo
# move file to rails app script folder

require 'rubygems'
require 'sinatra'
require 'mongoid_spacial'
require 'mongoid_taggable_with_context'
require 'digest/md5'
require 'json'
require 'mongoid'
require 'sinatra/contrib'

Mongoid.load!(File.expand_path('../../../config/mongoid.yml/', __FILE__))
require File.expand_path('../../../app/models/agency', __FILE__)
require File.expand_path('../../../app/models/broker', __FILE__)
require File.expand_path('../../../app/models/estate', __FILE__)
require File.expand_path('../../../app/models/complain', __FILE__)

set :port, 5454
set :bind, '0.0.0.0'

before do
	content_type :txt
end

namespace '/api' do 
	# agency data update api
	# brokers data also be updated at same time
	# test with command below
  # curl -X POST  -d @api_test.txt http://127.0.0.1:5454/api/new_agency_pub -H "Content-Type: application/json; charset=UTF-8"
  # api_test.txt file is below test/fixture folder
	post '/new_agency_pub' do 
		orig_data = request.body.read
		data = JSON.parse(orig_data)

		brokers=data["brokers"].dup
		data.delete "brokers"

		target = Agency.where(guid: data["guid"]).first

		#not change old oid in mongodb
		if target.nil? then 
			target= Agency.create(data)
			logger.info "new agency published"
		else
			target.update_attributes(data);
			logger.info "agency updated"
		end
		logger.info target.brokers.count
		
		# remove all brokers first 	
		target.brokers.clear 
		# remove old uncompatible data
		Broker.delete_all(belong_to: data['guid'])

		brokers.each{|broker|
			target.brokers.create(broker)
		}

		logger.info Agency.where(bname: data["bname"]).count
		logger.info target.brokers.count
		{result: 'Success'}.to_json
	end

	#挂牌信息，转换字段名
	# curl -X POST  -d @api_test_gpinfos.txt http://localhost:5454/api/new_gpinfos_pub -H "Content-Type: application/json; charset=UTF-8"
	post '/new_gpinfos_pub' do 
		jdata = request.body.read
		data = JSON.parse(jdata)
		logger.info data.to_json

		# change hash key for update 
		# compatible with old api 
		# ref: http://stackoverflow.com/questions/4137824/how-to-elegantly-rename-all-keys-in-a-hash-in-ruby
		datas={
			pubid:    		data["gpxxid"], 	region: 		data["fwszqy"], 		villa: 						data["xqmc"],
	    type:     		data["fwxz"],     area: 			data["fwjzmj"],    	total_stage: 			data["fwzcs"], 
	    stage:    		data["lc"],       built_year: data["jznf"], 			rooms: 						data["fx"], 
	    orientation: 	data["cx"], 			traffic: 		data["jtzk"], 		 	structue: 				data["jg"], 
	    infracture:  	data["jbss"], 		price:  		data["fwnzrjg"],		price_per_square: data["dj"], 
	    end_at: 			data["zjfwjssj"],	pub_at:  		data["gpsj"], 			image_1: 					data["tu1"], 
	    # images is splited by | character
	    image_2: 			data["tu2"] , 		image_3: 		data["tu3"],				images:  					data["tu1"].split('|'), 
			location:  		data["location"],	totalprice: data["fwnzrjg"], 		exclusive:  			data["djwt"],
			broker_name:  data["zjr"], 			contactway: data["zjrlxfs"],		others:  					data["qtxx"], 
			contract:  		data["wthtid"], 	state:  		data["gpzt"], 			management:  			data["wyglqk"], 
			contracttypes:data["hetlx"],		brokerid:  	data["jjrid"], 			intermediary:  		data["jjjgid"], 
			address:  		data["fwzl"]
		}

		logger.info datas.inspect
		estate = Estate.where( pubid: datas[:pubid]).first
		if !estate then 
			estate = Estate.create(datas)
			logger.info 'estate new'
		else
			estate.update_attributes(datas)
			logger.info 'estate updated'
		end 

		# relation update
    broker = Broker.where(guid: datas[:brokerid]).first
    estate.broker = broker
    estate.save 

		logger.info Estate.where(pubid: datas[:pubid]).count
		{:result => 'Success',:id=>data["gpxxid"]}.to_json
	end

	# cancel publish
	# curl -X POST  -d @api_test_gpcx.txt http://localhost:5454/api/new_gpcx_pub -H "Content-Type: application/json; charset=UTF-8"
	post '/new_gpcx_pub' do 
		jdata = request.body.read
		data = JSON.parse(jdata)
		logger.info data.to_json

		estate = Estate.where( pubid: data['gpxxid']).first
		if estate then 
			estate.delete 
			{:result => 'Success',:id=>data["gpxxid"]}.to_json
		else
			status 400
		end
	end

	
=begin
	#md5=Digest::MD5.hexdigest("#{data[:name]}#{data[]}www.superidea.com.cn")
	#md5=Digest::MD5.hexdigest("#{formal_data}www.superidea.com.cn")
=end


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



