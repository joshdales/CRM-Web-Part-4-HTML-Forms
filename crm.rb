require_relative "contact"
require "sinatra"
require "pry"

get '/' do
  erb :index
end

get '/contacts' do
  @contacts = Contact.all
  # binding.pry
  if params["search"]
    if @contact = Contact.find_by(first_name: params["search"])
      erb :show_contact
    elsif @contact = Contact.find_by(last_name: params["search"])
      erb :show_contact
    elsif @contact = Contact.find_by(email: params["search"])
      erb :show_contact
    end
  else
    erb :contacts
  end
end

get '/contacts/new' do
  erb :new
end

get '/contacts/:id' do
  @contact = Contact.find_by({id: params[:id].to_i})
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get '/contacts/:id/edit' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
  erb :edit_contact
end

get '/contacts/:id/delete' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    erb :delete_contact
  else
    raise Sinatra::NotFound
  end
  erb :delete_contact
end

post '/contacts' do
  Contact.create(
    first_name: params[:first_name],
    last_name:  params[:last_name],
    email:      params[:email],
    note:       params[:note]
  )
  redirect to('/contacts')
end

get '/search' do
  erb :search
end

put '/contacts/:id' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    @contact.update(
      first_name: params[:first_name],
      last_name:  params[:last_name],
      email:      params[:email],
      note:       params[:note]
    )
    redirect to('/contacts')
  else
    raise Sinatra::NotFound
  end
end

delete '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    @contact.delete
    redirect to ('/contacts')
  else
    raise Sinatra::NotFound
  end
end

after do
  ActiveRecord::Base.connection.close
end
