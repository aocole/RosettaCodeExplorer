#!/usr/bin/env ruby19
require 'sinatra'
require 'rdiscount'

HOME = File.realpath(File.dirname(__FILE__) + '/..')
ROSETTA = HOME + '/RosettaCode'

configure do
  set :public_folder, ROSETTA
end

get /(\/?)|(\/README.md)/ do
  if File.exist?(settings.public_folder + '/README.md')
    markdown :README, :views => settings.public_folder, :layout_engine => :erb
  end
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
