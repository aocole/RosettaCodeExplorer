#!/usr/bin/env ruby19
require 'sinatra'

HOME = File.realpath(File.dirname(__FILE__) + '/..')
ROSETTA = HOME + '/RosettaCode'

configure do
  set :public_folder, ROSETTA
end

get '/?' do
  require 'rdiscount'
  if File.exist?(settings.public_folder + '/README.md')
    markdown :README, :views => settings.public_folder, :layout_engine => :erb
  else
    ''
  end + table
end

get '/Lang/:lang/:task' do
  @files = Dir.glob(ROSETTA + '/' + File.join('Lang', params[:lang], params[:task], '*')).collect{|f|f.sub(/^#{ROSETTA}/,'')}.sort
  erb :language_task
end

template :layout do
<<TEMPLATE
  <!DOCTYPE html>
  <html>
  <head>
    <title>Rosetta Code Interactive</title>
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
  </head>
  <body>
    <div class="container">
      <%=yield%> <br/>
    </div>
  </body>
  </html>
TEMPLATE
end

def langs
  @langs ||= begin
    Dir.glob(ROSETTA + '/Lang/*/').collect do |name|
      File.basename name
    end
  end.sort
end

def tasks
  @tasks ||= begin
    Dir.glob(ROSETTA + '/Task/*/').collect do |name|
      File.basename(name)
    end
  end.sort
end  

def table
  erb :table
end 