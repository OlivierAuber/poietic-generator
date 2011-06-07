
require 'poietic-gen/update_request'
require 'poietic-gen/zone'
require 'poietic-gen/user'

require 'poietic-gen/allocation/spiral'
require 'poietic-gen/allocation/random'

module PoieticGen

	#
	# A class that manages the global drawing
	#
	class Board

		attr_reader :config

		ALLOCATORS = {
			"spiral" => PoieticGen::Allocation::Spiral,
			"random" => PoieticGen::Allocation::Random,
		}


		def initialize config
			puts "Board/initialize: using allocator %s" % config.allocator
			@config = config
			@allocator = ALLOCATORS[config.allocator].new config
			pp @allocator
		end


		#
		# Get access to zone with given index
		#
		def [] idx
			return @allocator[idx]
		end

		#
		# make the user join the board
		#
		def join user
				zone = @allocator.allocate
				zone.user = user
				user.zone = zone.index
		end

		#
		# disconnect user from the board
		#
		def leave user

		end


		def update_data user, drawing
			zone = @allocator[user.zone]
			zone.apply drawing
		end
	end

end

