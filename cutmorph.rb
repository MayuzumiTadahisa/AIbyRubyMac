require "moji"

filename = "data/nisendouka.txt"

#全角文字の抽出
grams = Array.new
File.open(filename) do |file|
    file.each_line do |line|
        line.each_char do |letter|
            if letter.bytesize > 1 && letter != "　"  
               grams.push(letter.chomp)
            end
        end
    end
end

outname = "data/cutmorph.txt"
File.open(outname,"w") do |f|
    #文字種毎に出力
    letterType = 0
    putStr = ""

    grams.each do |g|
        #文字種の判定
        thisType = 0
        case Moji.type(g).to_s
        when "ZEN_HIRA" #ひらがな
            thisType = 1
        when "ZEN_KANJI" #漢字
            thisType = 2
        when "ZEN_KATA" #カタカナ
            thisType = 3
        else #それ以外
            thisType = 0
        end

        #文字種ブレイク処理
        if putStr != "" && letterType != thisType  
            if letterType != 0 
                f.write putStr + "\n"
            end
            putStr = ""
            letterType = thisType
        end

        #出力文字の保存
        putStr += g
    end

    #最終文字列の出力
    if letterType != 0 
        f.write putStr + "\n"
    end
end
