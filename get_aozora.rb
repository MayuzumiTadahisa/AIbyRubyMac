require "open-uri"
require 'cgi/util'

class GetAozora
    def initialize(cd_author,cd_writing,titlename)
        url = "http://www.aozora.gr.jp/cards/" + cd_author + "/files/" + cd_writing + ".html"
        htmlfile = "data/" + titlename + ".html"

        File.open(htmlfile,"wb") do |f|
            text = open(url, "r:shift_jis").read
            f.write text.encode("utf-8")
        end

        textfile = "data/" + titlename + ".txt"

        html = File.read(htmlfile)

        File.open(textfile, "w") do |f|
            in_header = true
            html.each_line do |line|
                if in_header && /<div class="main_text">/ !~ line
                    next
                else
                    in_header = false
                end
                break if /<div class="bibliograhical_information">/ =~ line
                line.gsub!(/<[^>]+>/, '')
                esc_line = CGI.unescapeHTML(line)
                f.write esc_line
            end
        end
    end
end

#aozora = GetAozora.new("001779","56647_58167","nisendouka")
aozora = GetAozora.new("000148","752_14964","bocchan")

