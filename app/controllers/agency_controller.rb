# encoding: UTF-8
class AgencyController < ApplicationController
  def show
    if params[:id].present? then
      @agency = Agency.find( params[:id])
    else
      @agency = Agency.first
    end

    if @agency.join_to_id.nil? or @agency.join_to_id.blank? then 
      @joins_cnt = Agency.where({:join_to_id => @agency.guid}).count
    else
      @join_to = Agency.where({:guid => @agency.join_to_id}).first
    end
    awards = @agency.brokers.awards
    @award_brokers = @agency.brokers.where(:awards_array.in => awards)

    @near_bys = Agency.excludes(_id: @agency._id)
              .near(location: [@agency.latitude, @agency.longitude])
              .locable
              .limit(5)
              .to_a

    @all = @near_bys.dup <<  @agency
    @json =  to_markers @all, @agency

    respond_to do |format|
      format.html {render "detail"}
      format.json {render json: @agency}
    end
  end

  def show_by_name
    @name = params[:name].strip
    if @name.empty? then 
      redirect_to root_path
    else 
      @agencies = Agency.where(:bname => /#{@name}/).to_a
      @json = to_markers @agencies
      
      respond_to do |format|
        format.html { render "search_list" }
        format.json { render json: @agencies }
      end
    end
  end

  def show_joins
    @id = params[:id]
    @agency = Agency.find(@id)
    @agencies = Agency.where({:join_to_id => @agency.guid}).page params[:page]
    @json = to_markers @agencies
  end

  def by_area
    @area = params[:area]
    @agencies = Agency.where("area"=> @area).locable.page params[:page]
      #.where(:location.exists =>true )
      
    @json = to_markers @agencies
  end

  def index
    @awards = Agency.awards
    @awards_list = []
    @awards.each do |award|
      agencies= Agency.where(:awards_array.all => [award]).to_a
      @awards_list << {:award=> award, :agencies => agencies}
    end

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
    
    render "list"
  end

  def search 
    @inter_check = params[:intermediate].present?
    @proxy_check = params[:proxy].present?
    if (params[:from_lat].present?) then
      @wuhan = {:lat =>params[:from_lat], :lng=> params[:from_lng], :draggable=>true}
      @limit = params[:limit].to_i
      if @inter_check and @proxy_check then 
      @agencies = Agency.near(location: [@wuhan[:lat].to_f, @wuhan[:lng].to_f]).locable
                .limit(@limit )
                .to_a
      elsif @inter_check then 
        @agencies = Agency.inter.near(location:[@wuhan[:lat].to_f, @wuhan[:lng].to_f]).locable
                .limit(@limit )
                .to_a
      else
        @agencies = Agency.proxy.near(location:[@wuhan[:lat].to_f, @wuhan[:lng].to_f]).locable
                .limit(@limit )
                .to_a
      end
      @hash =to_markers(@agencies)
    else
      @wuhan = {:lat=>30.593087,:lng=>114.305357, :draggable=>true, :marker_title=> "您所在位置"}
      @limit = 5
      @inter_check, @proxy_check = true , true
      @hash = [@wuhan]
    end
    
    respond_to do |format|
      format.html { render "search" }
      format.json { render json: @agencies }
    end
  end

  private 
    def  to_markers(collection, current=nil)
      Gmaps4rails.build_markers(collection) do |agency, marker|
        marker.lat agency.latitude
        marker.lng agency.longitude
        marker.title agency.bname
        marker.infowindow "#{view_context.link_to  agency.bname, agency_path(agency) }"
        if current and current === agency then
           marker.picture({
            :url => "http://maps.gstatic.cn/intl/zh-CN_cn/mapfiles/arrow.png",
            :width   => 32,
            :height  => 32
            })
        end
      end
    end
end
