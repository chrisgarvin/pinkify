require 'sinatra'
require 'RMagick'
include Magick

def get_image(name)
  "<img src='#{path + name}.jpg' />"
end

def path(pre = nil)
  Sinatra::Base.development? ? "#{pre}/images/" : "/tmp/"
end

get '/' do
  erb :index
end

post '/pinkified' do
  img = Magick::Image.read(params[:url])[0]
  @file_name = SecureRandom.uuid
  mono = img.quantize(256, Magick::GRAYColorspace)
  pink_img = mono.level_colors('black', '#c31e62', true)
  pink_img.write("#{path('public') + @file_name}.jpg")
  erb :pinkified
end
