class AssetsController < ApplicationController
  def new
  end

  def create
    @asset = Asset.new(:name => params[:name])
    @asset.attachment = params[:file]
    @asset.save!
    render :nothing => true
  end

  def index
    @assets = Asset.all.page params[:page]
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to action: 'index'
  end
end