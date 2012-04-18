module Skyrequest

	class Connector
	attr_accessor :cache, :index, :counter

	@@skycaches = [] #class variable

		def initialize() #Sky::Connector.new
			@cache = {}
			@index = 0
			@counter = -1
		end

		def save_cache #save variables after new controller action
			@@skycaches << self
		end

		def cache
			return @cache
		end
		
		def save(data) #write skylogic answer into cache
			@cache[0] = data
		end

		def seterrors #rename integer errors into strings
			unless @cache.empty?
				case @cache[0]["status"]
					when 0
						@cache[0]["status"] = "OK"
					when 1
						@cache[0]["status"] = "Warning"
					when 2
						@cache[0]["status"] = "Error"
					else
						@cache[0]["status"] = "Unknown Status"
				end
			end
		end

		def self.all #debug
			return @@skycaches
		end

		def changeids #newest request always on top
			unless @cache.empty?
				@temp_cache = {}
				@max_cache = @cache.count
				@keys = 0
				while @keys < @max_cache #write cache into temp_cache
					@temp_cache[@keys] = @cache[@keys]
					@keys += 1
				end
				while @keys > -1 #write temp_cache back into cache but increase index by 1
					@cache[@keys] = @temp_cache[@keys-1]
					@keys -= 1
				end
				@cache.delete(7) #don't let cache get bigger than 7
			end
		end
	end
end
