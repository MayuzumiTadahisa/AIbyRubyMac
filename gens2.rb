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
    def initialize
        #名詞の読み込み
        @ns = Array.new
        filen = "cutnav_n.txt"
        File.open(filen) do |fn|
            fn.each_line do |ln|
                @ns << ln.chomp
            end
        end

        #動詞の読み込み
        @vs = Array.new
        filev = "cutnav_v.txt"
        File.open(filev) do |fv|
            fv.each_line do |lv|
                @vs << lv.chomp
            end
        end

        #形容詞の読み込み
        @as = Array.new
        filea = "cutnav_a.txt"
        File.open(filea) do |fa|
            fa.each_line do |la|
                @as << la.chomp
            end
        end

        #形容動詞の読み込み
        @ds = Array.new
        filed = "cutnav_d.txt"
        File.open(filed) do |fd|
            fd.each_line do |ld|
                @ds << ld.chomp
            end
        end

        @script = "" #会話の初期化
        @apCallCount = 0 #apの再帰カウンタ
    end

    def setn
        #名詞の取得
        ni = Random.rand(@ns.length)
        @n = @ns[ni]
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

    def np #＜名詞句＞
        #  規則②　＜名詞句＞　　→　＜形容詞句＞＜名詞＞は
        #  規則③　＜名詞句＞　　→　＜名詞＞は

        selectnp = Random.rand(2)
        case selectnp
        when 0
            #  規則②　＜名詞句＞　　→　＜形容詞句＞＜名詞＞は
            ap
            setn
            @script += @n
        else 
            #  規則③　＜名詞句＞　　→　＜名詞＞は
            setn
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

    def getScript(message)
        #  規則①　＜文＞　　　　→　＜名詞句＞＜動詞句＞

        @script = "" #会話の初期化
        np
        @script += "は"
        vp
        @script += "。"
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
