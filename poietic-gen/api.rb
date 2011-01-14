
require 'sinatra'

require 'poietic-gen/page'
require 'poietic-gen/session'

# FIXME:
# lancer un timer qui nettoie les participants déconnectés
# toutes les 300 secondes

module PoieticGen

	class Api < Sinatra::Base
		set :static, true
		set :public, File.expand_path( File.dirname(__FILE__) + '/../static' )
		set :views, File.expand_path( File.dirname(__FILE__) + '/../views' )

		mime_type :ttf, "application/octet-stream"
		mime_type :eot, "application/octet-stream"
		mime_type :otf, "application/octet-stream"
		mime_type :woff, "application/octet-stream"

		#
		#
		#
		get '/' do 
			@page = Page.new "Indew"
			erb :page_index
		end

		#
		#
		#
		get '/session/draw' do
			@page = Page.new "Session"
			erb :page_draw
		end

		#
		# creer une session
		# on attribue un id 'participant' au client
		get '/session/join' do

			redirect '/session/draw'
		end

		#
		#
		#
		get '/session/leave' do
			redirect '/'
		end

		#
		# display global activity on this session
		#
		get '/session/view' do
			@page = Page.new "Indew"
			erb :page_view
		end


		# 
		# Update connection to current session
		#
		get '/session/update' do
			# le participant <user-id> doit renouveller son bail avant 300
			# secondes sinon on le considere déconnecté
		end

		# 
		# Join session and get local <user-id>
		#
		get '/session/:idx/join' do 
			# joindre une session
			# rediriger vers la session
		end


		# 
		# Send message to the chat
		#
		put '/session/:idx/chat' do
			#
		end

		# 
		# Get latest messages from chat
		#
		get '/session/:idx/chat' do 
			#
		end

	end
end

# un moyen d'envoyer un paquet de données
#
# recevoir le dernier paquet de données depuis la date X
# 
