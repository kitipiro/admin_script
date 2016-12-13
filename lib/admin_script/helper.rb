require 'redcarpet'
require 'coderay'
require 'nokogiri'

module AdminScript
  module Helper
    def markdown(text)
      options = { autolink: true,
                  gh_blockcode: true,
                  hard_wrap: true,
                  no_intraemphasis: true,
                  fenced_code: true,
                  filter_html: true }
      #マークダウン
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown.render(text).html_safe
    end

    def coderay(code)
      text = markdown(code)
      doc = Nokogiri::HTML(text)
      doc.search("//pre[@lang]").each do |pre|
        pre.replace CodeRay.scan(pre.text.rstrip, pre[:lang]).div(:line_numbers => :table)
      end
      doc.to_html.html_safe
    end
  end
end
