require 'yaml'
class Hangman
    attr_reader :valid_words, :secret_word
    attr_accessor :visible_word, :chances, :letters

    def initialize
        valid_words = []
        wrong_letters = []
        
        File.readlines("../5desk.txt").each do |line|
            if line.chomp.length > 4 && line.chomp.length < 13
                valid_words.push(line.chomp)
            end
        end
        @valid_words = valid_words
        @secret_word = valid_words.sample.downcase
        @visible_word = "_" * secret_word.length
        @chances = 10
        @wrong_letters = wrong_letters
        @letters = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    end
    
    def guess_ltr(secret_arr)
        puts "Guess the word using one letter at a time! if you would like to save, enter '$'."
        # put in save/load later, guessed is the input. if guess is $ or # save/load, elsif check if input matches a letter in secretwrd, then update visible with the character in the correct location(s)
        input = gets.chomp.downcase
        checker = false

        secret_arr.each_with_index do |letter,i|
            if input == letter
                @visible_word[i] = input
                checker = true

            elsif input == "$"
                save_game
                checker = true
                break

            elsif input == "#"
                load_game
                checker = true
                break
            end

            
        end

        if checker == false
            @chances -= 1
            puts "No matches, you have #{@chances} attempt(s) remaining."
            @wrong_letters.push(input)
            puts "letters used: #{@wrong_letters.join(", ")}"
        end

        

    end
    
    def play
        puts "would you like to load a save? y/n"
        loadyn = gets.chomp.downcase

        if loadyn == "y" then load_game end

        secret_arr = @secret_word.split(//)

        until @chances == 0 || @visible_word == @secret_word 
            puts "#{@visible_word}"
            guess_ltr(secret_arr)
        end
        puts @visible_word
        puts "the word was: #{@secret_word}"
    end


    def save_game
        puts "Please enter a name for your save."
        @filename = gets.chomp
        
        File.open("../saved_games/#{@filename}.yaml", "w") do |f|
            f.puts self.to_yaml
        end
        puts "Game Saved"

    end

    def load_game
        directory = "../saved_games"
        files = Dir.foreach("#{directory}").select { |x| File.file?("#{directory}/#{x}") }
        
        
        puts "pick a file to load!"
        print "#{files.join("\n")}\n"
        
        @filename = gets.chomp

        data = YAML.load(File.open("../saved_games/#{@filename}.yaml", "r"))
        @secret_word = data[:secret_word]
        @visible_word = data[:visible_word]
        @wrong_letters = data[:wrong_letters]
        @chances = data[:chances]
    end

    def to_yaml
        YAML.dump({
            :secret_word => @secret_word,
            :visible_word => @visible_word,
            :wrong_letters => @wrong_letters,
            :chances => @chances
        }) 
    end
end


game = Hangman.new
game.play
