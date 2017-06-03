filename = "data/nisendouka.txt"
gramlength = 2

grams = Array.new

File.open(filename) do |file|
    file.each_line do |line|
        line.each_char do |letter|
            if letter.bytesize > 1 && letter != "　"  
               grams.push(letter)
            end
        end
    end
end

gramsname = "data/grams.txt"

File.open(gramsname,"w") do |f|
    #文字配列を文字列長毎に組み合わせて出力
    i = 0
    while (i <= grams.length - gramlength)
        gram = ""
        (i..i + gramlength - 1).each do |j|
            gram += grams[j]
        end
        f.write gram + "\n"
        i = i + 1
    end
    #終了処理
    gram = ""
    (i..grams.length - 1).each do |k|
        gram += grams[k]
    end
    f.write gram
end

