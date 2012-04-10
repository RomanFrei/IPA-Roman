require "skylogic/version"
require 'mechanize'
require "xmlrpc/client"

module Sky
  
	class Connector
				
		def initialize
			YAML::load(File.open(Rails.root + "config/skylogic.yml")).each do |key, val|
				instance_variable_set("@#{key}", val)
			end
			@agent = Mechanize.new
			@page = @agent.get('https://external.skylogicnet.com/dana-na/auth/url_8/login.cgi')
		end
				
		def login
			login_form = @page.form('frmLogin')
			login_form.tz_offset = @tz_offset.to_i
			login_form.username = @username.to_s
			login_form.password = @password.to_s
			login_form.realm = @realm.to_s
			@page = @agent.submit(login_form, login_form.buttons.first)
			
			if @page.form('frmConfirmation')
				puts "already logged in"
				confirm_form = @page.form('frmConfirmation')
				@page = @agent.submit(confirm_form, confirm_form.button('btnContinue'))
				@page = @agent.get("https://external.skylogicnet.com:11005/?q=node&destination=node")
			else
				@page = @agent.get("https://external.skylogicnet.com:11005/?q=node&destination=node")
			end
		end
		
		def page #Test-Function
			@page = @agent.get("https://external.skylogicnet.com/dana/home/index.cgi")
		end
				
		def call(method, *args)
			server = XMLRPC::Client.new("external.skylogicnet.com", "/xmlrpc.php", "11005", nil, nil, nil, nil, true, nil)
			server.set_debug
			server.cookie = @agent.cookies.collect {|cookie| cookie.to_s}.join("; ")
			result = server.call(method, *args)
				
		end
		
	end
	
end
