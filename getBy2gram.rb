class Sakura
    #initializeメソッド
    def initialize(talkType = "nisendouka")
        @talkType = talkType

        gramFile = "grams.txt"

        #Arrayへの読み込み
        @gramArray = Array.new
        @initGram = Array.new
        File.open(gramFile) do |grams|
            grams.each_line do |line|
                @gramArray << line.chop
                @initGram << line[0]
            end
        end

        ##debug
        #@gramArray.each do |e| 
        #    puts e
        #end
    end

    #メッセージから候補配列を作成するメソッド
    def getThisGrams(letter = " ")
        @thisGrams = Array.new
        @gramArray.each do |g|
            if g[0] = letter[0]
                @thisGrams << g[1]
            end
        end

        if @thisGrams.length == 0 || letter = " "
            @thisGrams = @initGram
        end

        ##debug
        #puts "=DBG= 候補文字列数：" @thisGrams.length
    end

    def getScript(message = " ")
        @script = ""

        #先頭の文字から処理開始
        letter = message[0]
        @script += letter

        #文字列取得ループ
        loop do
            if letter == "。"
                break
            end

            getThisGrams(letter)
            i = Random.rand(@thisGrams.length)
            letter = @thisGrams[i][0]
            @script += letter
        end
    end

    def talk
        #オープニングメッセージ
        print "さくら：メッセージをどうぞ\n"
        print "あなた："

        #会話しましょう
        while str = STDIN.gets
            break if str.chomp == "bye"

            getScript(str.chomp)

            print "さくら：" + @script + "\n"
            print "あなた："
        end

        #エンディングメッセージ
        print "さくら：ばいば〜い\n"

    end
end

sakura = Sakura.new();
sakura.talk
