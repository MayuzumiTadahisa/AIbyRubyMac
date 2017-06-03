filename = "nisendouka.txt"

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
    grams.each do |gram|
        f.write gram + "\n"
    end
end

