#!/usr/bin/env ruby19
require 'sinatra'
require 'json'

HOME = File.realpath(File.dirname(__FILE__) + '/..')
ROSETTA = HOME + '/RosettaCode'

require 'rdiscount'
get '/?' do
  table
end

get '/Lang/:lang/:task.:format' do
  puts "format is #{params[:format].inspect}"
  if params[:format] == 'json'
    puts "JSON format"
    layout false
    headers['Content-Type'] = 'application/json'
    load_samples(params[:lang], params[:task]).to_json
  else
    puts "plain format"
    @files = Dir.glob(ROSETTA + '/' + File.join('Lang', params[:lang], params[:task], '*')).collect{|f|f.sub(/^#{ROSETTA}/,'')}.sort
    erb :language_task
  end
end

def langs
  @langs ||= begin
    YAML.load_file(File.join(ROSETTA, 'Meta', 'Lang.yaml')).values
  end
end

def tasks
  @tasks ||= begin
    YAML.load_file(File.join(ROSETTA, 'Meta', 'Task.yaml')).values
  end
end

require 'wikicloth'
def task_desc(task)
  text = File.read File.join(ROSETTA, 'Task', task, '0DESCRIPTION')
  wiki = WikiCloth::Parser.new({:data => text})
  wiki.to_html
end

def table
  erb :table
end 

def readme
  filename = File.join(ROSETTA, 'README.md')
  if File.exist?(filename)
    markdown File.read(filename)
  else
    ''
  end
end

def load_samples(lang, task)
  filenames = Dir.glob(File.join(ROSETTA, 'Lang', lang, task, '*'))
  samples = filenames.collect do |filename|
    File.read filename
  end
end