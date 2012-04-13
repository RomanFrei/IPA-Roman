module Skyrequest

	class Connector
	attr_accessor :cache, :index, :counter

	@@skycaches = []

		def initialize()
			@cache = {}
			@index = 0
			@counter = -1
		end

		def save_cache
			@@skycaches << self
		end

		def cache
			return @cache
		end
		
		def setindex
			@counter += 1
			@index = @counter % 6
		end

		def save(data)
			@cache[@index] = data
		end
	
		def seterrors
			unless @cache.empty?
			case @cache[@index]["status"]
				when 0
					@cache[@index]["status"] = "OK"
				when 1
					@cache[@index]["status"] = "Warning"
				when 2
					@cache[@index]["status"] = "Error"
				else
					@cache[@index]["status"] = "Unknown Status"
			end
			end
		end

		def self.all
			return @@skycaches
		end
	end
end
