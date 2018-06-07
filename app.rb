require 'sinatra'
require 'rmagick'
include Magick
require 'aws-sdk-s3'
require 'dotenv'
Dotenv.load

def get_image(name)
  "<img src='https://#{ENV['BUCKET']}.s3.amazonaws.com/#{name}' />"
end

get '/' do
  erb :index
end

post '/pinkified' do
  img = Magick::Image.read(params[:image][:tempfile].path)[0]
  img.format = 'PNG'
  @file_name = SecureRandom.uuid
  mono = img.quantize(256, Magick::GRAYColorspace).resize_to_fit(500, 500)
  pink_img = mono.level_colors('black', '#c31e62', true)

  Aws.config.update({
    credentials: Aws::Credentials.new(ENV['AWS_KEY'], ENV['AWS_SECRET'])
  })
  client = Aws::S3::Client.new(region: 'us-west-1')

  client.put_object({
    bucket: ENV['BUCKET'],
    key: @file_name,
    body: pink_img.to_blob,
    acl: 'public-read'
  })

  erb :pinkified
end
