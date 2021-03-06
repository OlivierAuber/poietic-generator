##############################################################################
#                                                                            #
#  Poietic Generator Reloaded is a multiplayer and collaborative art         #
#  experience.                                                               #
#                                                                            #
#  Copyright (C) 2011-2013 - Gnuside                                         #
#                                                                            #
#  This program is free software: you can redistribute it and/or modify it   #
#  under the terms of the GNU Affero General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or (at     #
#  your option) any later version.                                           #
#                                                                            #
#  This program is distributed in the hope that it will be useful, but       #
#  WITHOUT ANY WARRANTY; without even the implied warranty of                #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero  #
#  General Public License for more details.                                  #
#                                                                            #
#  You should have received a copy of the GNU Affero General Public License  #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.     #
#                                                                            #
##############################################################################

require 'dm-core'
require 'json'

module PoieticGen
	class Event
		include DataMapper::Resource

		@debug = true

		property :id,	Serial
		property :type,	String, :required => true
		property :desc, String, :required => true
		property :timestamp, Integer, :required => true


		def self.create_join uid, uzone
			event = Event.create({
				:type => 'join',
				:desc => JSON.generate({ :user => uid, :zone => uzone }),
				:timestamp => Time.now.to_i
			})
			event.save
		end

		def self.create_leave uid, leave_time, uzone
			event = Event.create({
				:type => 'leave',
				:desc => JSON.generate({ :user => uid, :zone => uzone }),
				:timestamp => leave_time
			})
			event.save
		end

		def to_hash board
			desc = JSON.parse( self.desc )
			user = User.first( :id => desc['user'] )

			rdebug "Event/to_hash desc"
			pp desc
			pp user

			res_desc = {
				:user => user.to_hash,
			  :zone => board[desc['zone']].to_desc_hash
			}
			res = {
				:id => self.id,
				:type => self.type,
				:desc => res_desc,
				:stamp => self.timestamp
			}
			return res
		end
	end

end
