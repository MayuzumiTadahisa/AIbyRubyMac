require "moji"

class Sakura
    #initializeメソッド
    def initialize(talkType = "nisendouka")
        @talkType = talkType

        gramFile = "data/make_" + talkType + ".txt"

        #Arrayへの読み込み
        @gramArray = Array.new
        @initGram = Array.new
        File.open(gramFile) do |grams|
            grams.each_line do |line|
                column = line.chomp.split(",")
                @gramArray << column
                @initGram << column[1]
            end
        end

        ##debug
        #@gramArray.each do |e| 
        #    puts e[0] + e[1]
        #end
    end

    #メッセージから候補配列を作成するメソッド
    def getThisGrams(message = "")
        ##debug
        #puts "=DBG= message:" + message

        @thisGrams = Array.new
        @gramArray.each do |g|
            if g[0] == message
                @thisGrams << g[1]
            end
        end

        if @thisGrams.length == 0 || message == ""
            @thisGrams = @initGram
        end

        ##debug
        #puts "=DBG= 候補文字列数："  + @thisGrams.length.to_s
    end

    def getScript(message = "")
        @script = ""

        #先頭の文字から処理開始
        @script += message

        #文字列取得ループ
        loop do
            if message == "。"
                break
            end

            getThisGrams(message)
            i = Random.rand(@thisGrams.length)
            message = @thisGrams[i][0]
            @script += message
        end
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
