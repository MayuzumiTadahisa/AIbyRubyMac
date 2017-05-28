require "open-uri"

url = "http://www.aozora.gr.jp/cards/001779/files/56647_58167.html"
filename = "nisendouka.html"

File.open(filename,"wb") do |f|
    text = open(url, "r:shift_jis").read
    f.write text.encode("utf-8")
end