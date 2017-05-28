filename = "nisendouka.txt"
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

gramsname = "grams.txt"

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

# gramのカウント
count = Hash.new(0)

#集計
File.open(gramsname) do |g|
    g.each_line do |grm|
        count[grm.chop] += 1
    end
end

#カウントの出力
countname = "gramcount.txt"
File.open("gramcount.txt","w") do |c|
    count.sort{|a,b|
        a[1] <=> b[1]
    }.reverse.each do |key,value|
        c.write "#{key}: #{value}\n"
    end
end