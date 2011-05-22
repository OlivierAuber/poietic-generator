
require 'poietic-gen/palette'
require 'poietic-gen/database'


module PoieticGen


	ZONE_INIT = []

	#
	# manage a pool of users
	#
	class Manager
		def initialize config
			@config = config
			# a 16-char long random string
			@session_id = (0...16).map{ ('a'..'z').to_a[rand(26)] }.join

			@palette = Palette.new
			@width = 32
			@height = 32

			@users = []

			# total count of users seen
			@users_seen = 0

			@zones = [ ZONE_INIT ]
		end


		#
		# generates an unpredictible user id based on session id & user counter
		#
		def join req_user_id, req_session, req_user_name

			# FIXME: prevent session from being stolen...
			STDERR.puts "requesting id=%s, session=%s, name=%s" \
				% [ req_user_id, req_session, req_user_name ]

			user = nil
			now = DateTime.now
			param_request = {
			   	:id => req_user_id,
				:session => @session_id 
			}
			param_create = { 
				:session => @session_id,
				:name => ( req_user_name || 'anonymous' ),
				:created_at => now,
				:expires_at => (now + Rational(User::MAX_IDLE, 60 * 60 * 24 ))
			}

			if req_session != @session_id then
				STDERR.puts "User is requesting a different session"
				# create new
				user = User.create param_create
			else
				STDERR.puts "User is in session"
				user = User.first_or_create param_request, param_create

				if ( (now - user.expires_at) > 0  ) then
					STDERR.puts "User session expired"
					# create new if session expired
					user = User.create param_create
				end
			end

			# update expiration time
			user.expires_at = (now + Rational(User::MAX_IDLE, 60 * 60 * 24 )) 
			user.save

			# FIXME: allocate zone  (or reallocate zone)
			# FIXME: send matrix status of user zone

			return user
		end


		def leave user_id
			zone_idx = @users[user_id].zone

			self.zone_free zone_idx
		end

		def zone_free zone_idx
			zone = @zones[zone_idx]
			zone.user = nil
		end

		#
		# allocates a zone for a new user
		# uses the minimal index zone if it exists
		# or creates one if necessary
		#
		def zone_alloc user_id
			zone_result = nil

			zones_free = @zones.select do |zone_item|
				zone_item.user.nil? 
			end
			if zones_free.empty? then
				self.expand!
			end

			zone = zones_free.first
			zone.user = user_id
			return zone
		end

		#
		# expend map creating new allocatable zones
		#
		def world_expand
			# choose a side (using a spiral growth)
			# expand that side
			zone_past = @zones.last

			zone_present = Zone.create_next zone_past
			zone_future = Zone.create_next zone_past

			# if the following collides, then keep the same vector
			res = @zones.select do |zone_item|
				( zone_item.position <=> zone_future ) == 0
			end
			unless res.empty? then
				#collision with existing zone coordinates
				zone_present.vector = zone_past.vector
			end
			@zones << zone_present
		end

		#
		# reduce map removing unused zones from the border
		#
		def world_reduce
			while true
				zone = @zones.last
				break if @zones.last
			end
		end

		# post
		#  * <user-id> changes
		#
		# returns 
		#  * latest content since last update
		def sync user_id
			# 
			#draw user

			return
		end

		#
		# Relocate user offset
		def draw user_id, change

		end
	end
end
