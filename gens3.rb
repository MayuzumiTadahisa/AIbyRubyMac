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

sakura = Sakura.new("bocchan");
sakura.talk
