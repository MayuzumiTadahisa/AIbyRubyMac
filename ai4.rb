require "moji"

#書き換え規則による文の生成プログラム
#書き換え規則Ａに従って文を生成します
#書き換え規則Ａ
#  規則①　＜文＞　　　　→　＜名詞句＞＜動詞句＞
#  規則②　＜名詞句＞　　→　＜形容詞句＞＜名詞＞は
#  規則③　＜名詞句＞　　→　＜名詞＞は
#  規則④　＜動詞句＞　　→　＜動詞＞
#  規則⑤　＜動詞句＞　　→　＜形容詞＞
#  規則⑥　＜動詞句＞　　→　＜形容動詞＞
#  規則⑦　＜形容詞句＞　→　＜形容詞＞＜形容詞句＞
#  規則⑧　＜形容詞句＞　→　＜形容詞＞

class Sakura
    def makeMorph (source)
        #全角文字の抽出
        letters = Array.new
        File.open(source) do |file|
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
        outname_n = "data/cutnav_n.txt"
        outname_v = "data/cutnav_v.txt"
        outname_a = "data/cutnav_a.txt"
        outname_d = "data/cutnav_d.txt"

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

    def initialize(sourceType = "nisendouka")
        source = "data/" + sourceType + ".txt"

        #元ファイルを形態素に分解
        makeMorph(source)

        #品詞の作成
        writeNav

        #名詞の読み込み
        @ns = Array.new
        filen = "data/cutnav_n.txt"
        File.open(filen) do |fn|
            fn.each_line do |ln|
                @ns << ln.chomp
            end
        end

        #動詞の読み込み
        @vs = Array.new
        filev = "data/cutnav_v.txt"
        File.open(filev) do |fv|
            fv.each_line do |lv|
                @vs << lv.chomp
            end
        end

        #形容詞の読み込み
        @as = Array.new
        filea = "data/cutnav_a.txt"
        File.open(filea) do |fa|
            fa.each_line do |la|
                @as << la.chomp
            end
        end

        #形容動詞の読み込み
        @ds = Array.new
        filed = "data/cutnav_d.txt"
        File.open(filed) do |fd|
            fd.each_line do |ld|
                @ds << ld.chomp
            end
        end

        @script = "" #会話の初期化
        @apCallCount = 0 #apの再帰カウンタ
    end

    def setn(message)
        if message != ""
            @n = message
        else
            #名詞の取得
            ni = Random.rand(@ns.length)
            @n = @ns[ni]
        end
    end

    def seta
        #形容詞の取得
        ai = Random.rand(@as.length)
        @a = @as[ai]
    end

    def setv
        #動詞の取得
        vi = Random.rand(@vs.length)
        @v = @vs[vi]
    end

    def setd
        #形容動詞の取得
        di = Random.rand(@ds.length)
        @d = @ds[di]
    end

    def ap #＜形容詞句＞
        #  規則⑦　＜形容詞句＞　→　＜形容詞＞＜形容詞句＞
        #  規則⑧　＜形容詞句＞　→　＜形容詞＞

        selectap = Random.rand(2)
        if selectap == 0
            #  規則⑦　＜形容詞句＞　→　＜形容詞＞＜形容詞句＞
            if @apCallCount < 5
                @apCallCount += 1
                ap #再帰呼び出し
            end
            @apCallCount = 0
            seta
            @script += @a
        else
            #  規則⑧　＜形容詞句＞　→　＜形容詞＞
            seta
            @script += @a
        end
    end

    def np (keyword)#＜名詞句＞
        #  規則②　＜名詞句＞　　→　＜形容詞句＞＜名詞＞は
        #  規則③　＜名詞句＞　　→　＜名詞＞は

        selectnp = Random.rand(2)
        case selectnp
        when 0
            #  規則②　＜名詞句＞　　→　＜形容詞句＞＜名詞＞は
            ap
            setn(keyword)
            @script += @n
        else 
            #  規則③　＜名詞句＞　　→　＜名詞＞は
            setn(keyword)
            @script += @n
        end
    end

    def vp #＜動詞句＞
        #  規則④　＜動詞句＞　　→　＜動詞＞
        #  規則⑤　＜動詞句＞　　→　＜形容詞＞
        #  規則⑥　＜動詞句＞　　→　＜形容動詞＞

        selectvp = Random.rand(3)
        case selectvp
        when 0
            #  規則④　＜動詞句＞　　→　＜動詞＞
            setv
            @script += @v
        when 1
            #  規則⑤　＜動詞句＞　　→　＜形容詞＞
            seta
            @script += @a
        else 
            #  規則⑥　＜動詞句＞　　→　＜形容動詞＞
            setd
            @script += @d
        end
    end

    def getScript(keyword)
        #  規則①　＜文＞　　　　→　＜名詞句＞＜動詞句＞

        @script = "" #会話の初期化
        np(keyword)
        @script += "は"
        vp
        @script += "。"
    end

    def getKeyword (message)
        #文字種毎に出力
        morphs = Array.new        
        letterType = 0
        putStr = ""
        message.each_char do |c|
            #文字種の判定
            thisType = 0
            case Moji.type(c).to_s
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
                    addMorph = Array.new
                    addMorph << letterType.to_s
                    addMorph << putStr
                    morphs <<  addMorph
                end
                putStr = ""
            end

            #出力文字の保存
            putStr += c
            letterType = thisType
        end

        #最終文字列の出力
        if letterType != 0 
            addMorph = Array.new
            addMorph << letterType.to_s
            addMorph << putStr
            morphs <<  addMorph
        end

        keyword = ""
        morphs.each do |e|
            ##dbg
            #puts "=DBG=" + e[0] + e[1]

            if e[0] == "2" || e[0] == "3" #漢字、カタカナをキーワードにする
                keyword = e[1]
                break
            end
        end

        if keyword == "" && morphs.length > 0
            i = Random.rand(morphs.length)
            keyword = morphs[i][1]
        end

        return keyword
    end


    def talk
        #オープニングメッセージ
        print "さくら：メッセージをどうぞ\n"
        print "あなた："

        #会話しましょう
        while str = STDIN.gets
            break if str.chomp == "bye"

            getScript(getKeyword(str.chomp))

            print "さくら：" + @script + "\n"
            print "あなた："
        end

        #エンディングメッセージ
        print "さくら：ばいば〜い\n"
    end
end

#sakura = Sakura.new("nisendouka");
sakura = Sakura.new("bocchan");
sakura.talk
