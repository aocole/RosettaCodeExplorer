require 'wikicloth'
# monkeypatch :-(
module WikiCloth
  class WikiBuffer
    def gen_heading(hnum,title)
      id = get_id_for(title.gsub(/\s+/,'_'))
      "<h#{hnum}><span class=\"mw-headline\" id=\"#{id}\">#{title}</span></h#{hnum}>\n"
    end
  end
end

class CustomLinkHandler < WikiCloth::WikiLinkHandler
  def url_for(page)
    "http://rosettacode.org/wiki/#{page}"
  end
end

