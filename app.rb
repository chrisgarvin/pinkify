require 'sinatra'
require 'RMagick'
include Magick

def get_image(name)
  "<img src='/images/#{name}.jpg' />"
end

get '/' do
  erb :index
end

post '/pinkified' do
  img = Magick::Image.read(params[:url])[0]
  @file_name = SecureRandom.uuid
  mono = img.quantize(256, Magick::GRAYColorspace)
  pink_img = mono.level_colors('black', '#c31e62', true)
  pink_img.write("public/images/#{@file_name}.jpg")
  erb :pinkified
end
