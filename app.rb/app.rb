require 'sinatra'
require 'dm-core'
DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})

class BlogPost
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :prompt, String
end

class Collaborator
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :email, String
end

class Words
  include DataMapper::Resource
  property :id, Serial
  property :prompt,String
end

DataMapper.finalize


get '/' do
    erb:front
end

get '/name' do
    erb:name 
end

post '/blog/save' do
  
  @like = BlogPost.last(:prompt => params[:prompt])
  
  myPost=BlogPost.new
  myPost.title=params[:title]
  myPost.body=params[:body]
  myPost.prompt=params[:prompt]
  
  if (myPost.save)
    @message="Your post was saved!"
  else
   @message="Your post was NOT saved!"
  end
  
  if @like
    erb :blog_save  
  else
    erb :no_blog_post_yet
  end
  
  
end

post '/savename' do
user=Collaborator.new
user.name=params[:name]
user.save
  if (user.save)
    @message="You've been Saved!" 
  else
   @message="Please try again"  
  end 
    erb :save_name
end

get '/blog/new' do
@random=  Words.first(:offset => rand(Words.count))
  erb:blog_new
end

get '/words_make' do
    erb :words_make
end

post '/word/save' do
  subject=Words.new
  subject.prompt=params[:prompt]
  subject.save
    erb:word_save
end

get '/blog' do
  @posts = BlogPost.all (:order => [:id.desc])
    erb:blog
end

get '/words' do

  @posts= BlogPost.all(:prompt => params[:search])
  
  if @posts.size > 0
    erb :words
  else
    erb :no_words
  end
end

get '/words/search' do
  @words= Words.all
  erb :word_search
end

get '/blog/:id' do
  @post=BlogPost.get(params[:id])
    erb:post
end

