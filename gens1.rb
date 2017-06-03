#書き換え規則による文の生成プログラム
#書き換え規則Ａに従って文を生成します
#書き換え規則Ａ
#  規則①　＜文＞→＜名詞句＞＜動詞句＞
#  規則②　＜名詞句＞→＜名詞＞は
#  規則③　＜動詞句＞→＜動詞＞

class Sakura
    def initialize
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
    end

    def getScript(message)
        #名詞の取得
        ni = Random.rand(@ns.length)
        n = @ns[ni]

        #動詞の取得
        vi = Random.rand(@vs.length)
        v = @vs[vi]

        @script = n + "は" + v + "。"
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
