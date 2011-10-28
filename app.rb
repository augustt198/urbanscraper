require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'

helpers do
  def get_definition(term)
    # pull it into nokogiri
    doc = Nokogiri::HTML(open('http://www.urbandictionary.com/define.php?term=' + term))
 
    # run the xpath
    result = doc.xpath("/html[1]/body[1]/div[3]/div[1]/table[1]/tr[1]/td[2]/div[1]/table[1]/tr[2]/td[2]/div[@class='definition']/node()")
 
    definition = String.new
    result.each { |e| definition << e }
  
    definition
  end

  def get_example(term)
    # pull it into nokogiri
    doc = Nokogiri::HTML(open('http://www.urbandictionary.com/define.php?term=zomg'))

    # run the xpath
    result = doc.xpath("/html[1]/body[1]/div[3]/div[1]/table[1]/tr[1]/td[2]/div[1]/table[1]/tr[2]/td[2]/div[@class='example']/node()")
     
    example = String.new
    result.each { |e| example << e })

    example
  end
end

get '/' do
  erb :home
end

get '/define/:term.json' do
  data = Hash[
    "word" => params[:term], # term requested
    "timestamp" => Time.now.to_i, # the timestamp of the definition
    "status" => 200, # status of the request
    "url" => "" # the url for the definition
  ]
  
  data[:definition] = get_definition(params[:term])
  data[:example] = get_example(params[:term])

  content_type :text
  data.to_json
end
