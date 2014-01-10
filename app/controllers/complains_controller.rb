# encoding: UTF-8
#投诉
class ComplainsController < ApplicationController
  DISTRICT =  [
      ["江岸区局","江岸区房管局 82836730"],
      ["江汉区局","江汉区房管局 85721924"],
      ["硚口区局","硚口区房管局 83787377"],
      ["汉阳区局","汉阳区房管局 84765507"],
      ["武昌区局","武昌区房管局 88870504"],
      ["洪山区局","洪山区房管局 87525421"],
      ["青山区局","青山区房管局 50806121"],
      ["江夏区局","江夏区房管局 81818240"],
      ["东西湖区局","东西湖区房管局 83897117"],
      ["黄陂区局","黄陂区房管局 85901315"],
      ["新洲区局","新洲区房管局 89357187"],
      ["蔡甸区局","蔡甸区房管局 84943172"],
      ["汉南区局","汉南区房管局 8485620"],
      ["东湖高新技术开发区局","东湖高新技术开发区房管局 67880071"],
      ["武汉经济技术开发区局","武汉经济技术开发区房管局 84893064"],
      ["市中介协会","市中介协会 "]
      ]

  def index
  end

  def new
    @complain =Complain.new
    @district= DISTRICT
  end

  def create
    @complain = Complain.new(params[:complain])
    @district= DISTRICT
    
    verify_result = verify_complian(@complain)
    respond_to do |format|
      if verify_result=='1' && Complain.where(contract_no: @complain.contract_no).delete &&@complain.save 
        add_complain @complain
        format.html { redirect_to @complain, notice: '投诉提交成功,请等待处理。' }
        format.json { render json: @complain, status: :created, location: @complain }
      else
        if verify_result != '1' then 
          @complain.errors[:contract_no] = '合同编号或签约人名称不符'
        end
        format.html { render action: "new" }
        format.json { render json: @complain.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    contract_no = params[:contract_no]
    complain_by = params[:complain_by]
    contract_type = params[:contract_type]

    if contract_no.blank? or complain_by.blank?
      @result = nil
    else
      @result = verify_post contract_no, complain_by, contract_type
    end
    render :layout=>nil
  end

  def show
    @complain = Complain.find(params[:id])
  end

  def get_items
    contract_type = params[:contract_type]
    case contract_type
    when '委托租赁'
      @col = %w[1.1 1.2 2 3 4 5 6 7 8 9]
    when '委托买卖'
       @col = %w[1.1 1.2 2 3 4 5 6 7 8 9]
    when '居间买卖'
      @col = %w[1 2 3.1 3.2 3.3 4 5 6 7 8 9 10 11 12 13 14 15 16 17]
    when '居间租赁'
      @col = %w[1 2 3 4 5 6 7 8 9 10 11 12]
    end
    render :partial=> 'items'
  end

  private
    def verify_post  contract_no, complain_by, contract_type
      #todo add logic
      url = 'http://192.168.133.64:4567/checkcomplaints/Service1.asmx?WSDL'
      client = Savon.client(wsdl: url)
      response = client.call(:check_complaints, message: {:type=>contract_type, :hetbh =>contract_no, :name => complain_by })
      #client.http.headers.delete("SOAPAction")

      check_result = response.to_hash[:check_complaints_response][:check_complaints_result]
    end

    def add_complain  complain
      #todo add logic
      url = 'http://192.168.133.64:4567/checkcomplaints/Service1.asmx?WSDL'
      contract_no = complain.contract_no
      contract_type= complain.contract_type 
      complain_item = complain.complain_item.gsub /[\[\]\"]/, ''
      complain_by = complain.complain_by
      phone = complain.phone
      department = complain.complain_to
      content = complain.content

      client = Savon.client(wsdl: url)
      response = client.call(:add_complaint,
        message:{
                      "contract_no"=> contract_no,
                      "contract_type"=> contract_type, 
                      "complain_item" => complain_item, 
                      "complain_by" => complain_by,
                      "phone" => phone,
                      "content" => content,
                      "department"=> department
      })
      check_result = response.to_hash[:add_complaint_response][:add_complaint_result]
    end

    def verify_complian complain
      verify_post complain.contract_no, complain.complain_by, complain.contract_type
    end


end