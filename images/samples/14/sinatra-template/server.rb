require 'bundler'
Bundler.require

get '/hello/:name' do
  @name = params[:name]
  erb :index, locals: {my_var: 'my var value' }
end

get '/without/layout/hello/:name' do
  @name = params[:name]
  erb :index, locals: {my_var: 'my_var value' }, layout: false
end
