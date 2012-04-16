class SkyrequestsController < ApplicationController

before_filter :skylogic_login
before_filter :get_string, :only => :create #avoid wrong inputs (strings)

  def index 
	@skyrequest = Skyrequest::Connector.all.first
  end

  def get_string #find letters in params[:value] string
	@value = params[:value]
	if @value.match('\D').present?
		redirect_to skyrequests_path
		flash[:error] = "Only Integers allowed."
	end
  end

  def create	
	if Skyrequest::Connector.all.present? #create new class variable or choose an existing one
		@skyrequest = Skyrequest::Connector.all.first
	else
		@skyrequest = Skyrequest::Connector.new
		@skyrequest.save_cache
	end
	@skyrequest.changeids #re-index cache
	@skyrequest.setindex #calculate index, range 0 to 5
   	@skylogic_data = @agent.call("tooway.account.getDetails", {"sai" => @value.to_s.gsub(/\s+/, "")}) #skylogic request with method and value
	@skylogic_data["value"] = @value #write form value into server response
	@skyrequest.save(@skylogic_data) #save response into cache
	@skyrequest.seterrors #rename integer errors into strings

	redirect_to skyrequests_path
  end

end
