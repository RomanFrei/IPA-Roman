class SkyrequestsController < ApplicationController

before_filter :skylogic_login

  def index 
	@skyrequest = Skyrequest::Connector.all.first
  end

  def create	
	if Skyrequest::Connector.all.present?
		@skyrequest = Skyrequest::Connector.all.first
	else
		@skyrequest = Skyrequest::Connector.new
		@skyrequest.save_cache
	end

	@skyrequest.setindex
    @skylogic_data = @agent.call("tooway.account.getDetails", {"sai" => params[:value].to_s})
	@skylogic_data["value"] = params[:value]

	@skyrequest.save(@skylogic_data)
	@skyrequest.seterrors

	redirect_to skyrequests_path
  end

end
