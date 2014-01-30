# encoding: UTF-8
class EstateController < ApplicationController
  
  def index
    @villa = params[:villa]
    @region = params[:region]
    @areaa = params[:areaa].to_i
    @areab = params[:areab].to_i
    @price1 = params[:price1].to_i
    @price2 = params[:price2].to_i
    if @areab == 0
      @areab = 10000
    end
    if @price2 == 0
      @price2 = 10000
    end

    @estates = Estate.in_publish(Date.today)
                     .by_villa(@villa)
                     .by_region(@region)
                     .by_area(@areaa, @areab)
                     .by_price(@price1, @price2)
                     .page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @estates }
    end


  end

  # GET /laws/1
  # GET /laws/1.json
  def show
    @estate = Estate.find(params[:id])

    @json = to_markers [@estate]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @estate }
    end
    @agency = Agency.where(:id => @estate.intermediary)
  end

  #map search
  def search 
    if (params[:from_lat].present?) then
      @wuhan = {:lat =>params[:from_lat], :lng=> params[:from_lng], :marker_title=> "您所在位置" }
      @limit = 5
      
      @estates =Estate.near(location: [@wuhan[:lat].to_f, @wuhan[:lng].to_f])
                      .max_distance(location: 50)
                      .limit(@limit)
                      .to_a
      @json = to_markers @estates
    else
      @wuhan = {:lat=>30.593087,:lng=>114.305357, :marker_title=> "您所在位置"}
      @limit = 5
      @json = [@wuhan]
    end
    
    render "search"
  end

  private 
    def  to_markers(collection, current=nil)
    Gmaps4rails.build_markers(collection) do |estate, marker|
      marker.lat estate.latitude
      marker.lng estate.longitude
      marker.title estate.address
      marker.infowindow "#{view_context.link_to  estate.address, estate_path(estate)}"
      if current and current === estate then
         marker.picture({
          :url => "http://maps.gstatic.cn/intl/zh-CN_cn/mapfiles/arrow.png",
          :width   => 32,
          :height  => 32
          })
      end
    end
  end
end