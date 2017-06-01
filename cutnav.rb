require "moji"

class Nav
    def initialize (filename = "nisendouka.txt")
        #全角文字の抽出
        letters = Array.new
        File.open(filename) do |file|
            file.each_line do |line|
                line.each_char do |letter|
                    if letter.bytesize > 1 && letter != "　"  
                        letters.push(letter.chomp)
                    end
                end
            end
        end

        #文字種毎に出力
        @morph = Array.new
        letterType = 0
        putStr = ""

        letters.each do |l|
            #文字種の判定
            thisType = 0
            case Moji.type(l).to_s
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
                    @morph << [letterType,putStr]
                end
                putStr = ""
                letterType = thisType
            end

            #出力文字の保存
            putStr += l
        end

        #最終文字列の出力
        if letterType != 0 
            @morph << [letterType,putStr]
        end
    end

    def writeNav
        #出力ファイルの定義
        outname_n = "cutnav_n.txt"
        outname_v = "cutnav_v.txt"
        outname_a = "cutnav_a.txt"
        outname_d = "cutnav_d.txt"

        #出力ファイルのオープン
        filen = File.open(outname_n,"w")
        filev = File.open(outname_v,"w")
        filea = File.open(outname_a,"w")
        filed = File.open(outname_d,"w")

        svType = 0   #直前morphの文字種
        svMorph = "" #直前morphの退避領域
        @morph.each do |ma|
            #
            if ma[0] == 1
                if svType == 2 #直前が漢字
                    if ma[0] == 1  #今回がひらがなの場合、動詞、形容詞、形容動詞の判定
                        case ma[1][0]
                        when "う" 
                            filev.write svMorph + ma[1][0] + "\n"
                        when "い"
                            filea.write svMorph + ma[1][0] + "\n"
                        when "だ"
                            filed.write svMorph + ma[1][0] + "\n"
                        end
                    end
                end
            else #漢字、カタカナの場合は名詞の書き出し
                filen.write ma[1] + "\n"
            end
            svType = ma[0]
            svMorph = ma[1]
        end

        #出力ファイルのクローズ
        filen.close
        filev.close
        filea.close
        filed.close
    end
end

nav = Nav.new()
nav.writeNav
