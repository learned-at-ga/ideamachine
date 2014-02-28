require 'sinatra'
require 'data_mapper'

enable :sessions

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/ideamachine.db")  
  
class Idea  
  include DataMapper::Resource  
  property :id, Serial  
  property :idea_text, Text, :required => true
  property :good_idea, Boolean, :required => true, :default => false  
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
  
DataMapper.finalize.auto_upgrade!

get '/' do
 @ideas = Idea.all :order=> :id.desc
erb :home
end

post '/' do  
  i = Idea.new 
  i.idea_text = params[:idea_text] 
  i.created_at = Time.now  
  i.updated_at = Time.now  
  i.save
  redirect '/'   
end

get '/:id/delete' do
	i = Idea.get params[:id]
	i.destroy
	redirect '/'
end

