#!/usr/bin/env ruby19
require 'sinatra'
require 'json'
require_relative 'lib/my_wikicloth'

HOME = File.realpath(File.dirname(__FILE__) + '/..')
ROSETTA = HOME + '/RosettaCode'

require 'rdiscount'
get '/?' do
  table
end

require 'pygments.rb'
get '/Lang/:lang/:task.:format' do
  if params[:format] == 'json'
    layout false
    load_samples(params[:lang], params[:task]).collect do |f|
      begin
        f[:text] = Pygments.highlight(f[:text], :lexer => params[:lang].to_s.downcase)
      rescue MentosError => e
        # no syntax highlighter found for this language
        f[:text] = "<pre>#{f[:text]}</pre>"
      end
      f
    end.to_json
  else
    @files = Dir.glob(ROSETTA + '/' + File.join('Lang', params[:lang], params[:task], '*')).collect{|f|f.sub(/^#{ROSETTA}/,'')}.sort
    erb :language_task
  end
end

get '/js/minor_tasks.js' do
  minor_tasks = tasks - major_tasks
  json = "RCI.minor_tasks = " << minor_tasks.collect do |task|
    task['counts'] = langs.collect do |lang|
      num_samples(lang, task)
    end
    task
  end.to_json
  headers['Content-Type'] = 'text/javascript'
  return json
end

get '/info/:type/:name' do
  info params[:type], params[:name]
end

def langs
  @langs ||= begin
    YAML.load_file(File.join(ROSETTA, 'Meta', 'Lang.yaml')).values
  end
end

def major_langs
  @top_langs ||= begin
    langs.each do |lang|
      lang['size'] = Dir.entries(File.join(ROSETTA, 'Lang', lang['path'])).size - 2
    end
    langs.sort{|a,b|b['size'] <=> a['size']}[0..19]
  end
end

def major_tasks
  @top_tasks ||= begin
    tasks.each do |task|
      task['size'] = Dir.entries(File.join(ROSETTA, 'Task', task['path'])).size - 2
    end
    tasks.sort{|a,b|b['size'] <=> a['size']}[0..19]
  end
end

def tasks
  @tasks ||= begin
    YAML.load_file(File.join(ROSETTA, 'Meta', 'Task.yaml')).values
  end
end

def info(type, name)
  text = File.read File.join(ROSETTA, type, name, '00DESCRIPTION')
  wiki = WikiCloth::Parser.new({
    :link_handler => CustomLinkHandler.new,
    :data => text,
    :noedit => true
  })
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
  filenames = Dir.glob(File.join(ROSETTA, 'Task', task, lang, '*'))
  samples = filenames.sort.collect do |filename|
    {
      :text => File.read(filename),
      :filename => File.basename(filename),
      :path => filename.sub(ROSETTA, '')
    }
  end
end

def num_samples(lang, task)
  Dir.glob([ROSETTA, 'Lang', lang['path'], task['path'], '*'].join('/')).size
end
