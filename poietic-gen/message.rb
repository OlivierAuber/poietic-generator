
require 'dm-core'
require 'json'

module PoieticGen
	class Message
		include DataMapper::Resource

		property :id,	Serial
		property :user_src,	Integer, :required => true
		property :user_dst,	Integer, :required => true
		property :content, String, :required => true
		property :stamp,	DateTime, :required => true


		def to_hash
			res = {
				:id => self.id,
				:user_src => self.user_src,
				:user_dst => self.user_dst,
				:content => self.content,
				:stamp => self.stamp
			}
			return res
		end

		def self.post src, dst, stamp, content
			begin
				msg = Message.create({
					:user_src => src,
					:user_dst => dst,
					:content => content,
					:stamp => stamp
				})
				msg.save
			rescue DataMapper::SaveFailureError => e
				puts e.resource.errors.inspect
				raise e
			end
		end
	end

end
