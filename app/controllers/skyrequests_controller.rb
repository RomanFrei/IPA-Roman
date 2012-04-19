class SkyrequestsController < ApplicationController

before_filter :skylogic_login
before_filter :get_string, :only => :create #avoid wrong inputs (strings)

  def index 
	@skyrequest = Skyrequest::Connector.all.first
  end

  def get_string #find letters in params[:value] string
	@sky_attributes = {}
	@value = params[:value]
	@value.delete!(" ")
	if @value.size == 12
		@sky_attributes.merge!("mac" => @value.to_s)
		@sky_method = "tooway.terminal.getDetails"
	elsif @value.size == 10
		@sky_attributes.merge!("sai" => @value.to_s)
		@sky_method = "tooway.account.getDetails"
	else
		flash[:error] = "You have to commit a 12 character MAC or a 10 character SAI"
		redirect_to skyrequests_path
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
		@skylogic_data = @agent.call(@sky_method.to_s, @sky_attributes) #skylogic request with method and value
		@skylogic_data["value"] = @value
		@skyrequest.save(@skylogic_data) #save response into cache
		@skyrequest.seterrors #rename integer errors into strings
		@skyrequest.skylogger(@skylogic_data, current_user.login, Time.now) #save server answer, username, and date in log file skylogic.log

	redirect_to skyrequests_path
  end

end
