require 'sinatra/base'
require 'mongoid'
require 'mongoid_smart_tags'

class Blog < Sinatra::Base
	set :root, File.dirname(__FILE__)

	class Post
		# includes
		include Mongoid::Document
		include Mongoid::SmartTags
		include Mongoid::Timestamps
		# schema definition
		field :disable_comments, type: Boolean, default: false
		field :content
		field :title
		# indexes
		index({ title: 1 }, { unique: true })
		# relationships
		embeds_many :comments
		# validations
		validates :content, presence: true
		validates :title, presence: true
		# standard methods
		# custom methods
	end

	class Comment
		# includes
		include Mongoid::Document
		include Mongoid::Timestamps
		# schema definition
		field :author
		field :content
		field :email_address
		# indexes
		index({ title: 1 }, { unique: true })
		# relationships
		embedded_in :post
		# validations
		validates :author, presence: true
		validates :content, presence: true
		validates :email_address, format: { with: // }, presence: true
		# standard methods
		# custom methods
	end

	class User
		# custom methods
		def self.login()
		end
	end

	get '/' do
		@posts = Post.all
		erb :index
	end
	
	get '/post' do
		@post = Post.new
		erb :new
	end

	get '/reading' do
		@post = Post.find(params[:id])
		erb :show
	end

	post '/post' do
		@post = Post.new(params[:post])
		if @post.save
			redirect '/'
		else
			redirect '/post'
		end
	end
end