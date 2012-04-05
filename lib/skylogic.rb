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
		login_form.tz_offset = @tz_offset
	end

    end
end

