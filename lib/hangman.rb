# frozen_string_literal: true

require_relative 'displayable.rb'
require_relative 'serializable.rb'

# Creates a new Hangman game
class Hangman
  include Displayable
  include Serializable

  attr_accessor :random_word, :dashes, :bad_guess

  def initialize
    @random_word = ''
    @dashes = ''
    @bad_guess = 0
    @man = Array.new(6, ' ')
    @used_letters = Array.new
  end

  def pick_random_word
    until @random_word.chomp.length.between?(5, 12)
      @random_word = File.readlines('5desk.txt').sample.chomp.downcase
    end
    @random_word
  end

  def create_dashes
    @dashes = Array.new(@random_word.length, '_')
    puts "\s\s#{@dashes.join(' ')}"
  end

  def make_guess
    previous_letters
    choose_letter
    guess = gets.chomp.downcase
    unless guess == 'save'
      @used_letters.push(guess)
      letters_match?(guess)
    else
      save_game
    end
  end

  def letters_match?(guess)
    if @random_word.include?(guess)
      change_dashes(guess)
    else
      hang_man
    end
  end

  def change_dashes(guess)
    @dashes.each_with_index do |_dash, index|
      @dashes[index] = guess if @random_word[index] == guess
    end
    next_round
  end

  def hang_man
    @man[@bad_guess] = BODYPARTS[@bad_guess]
    @bad_guess += 1
    next_round
  end

  def next_round
    system 'clear'
    game_title
    how_to_play
    noose
    puts "\s\s#{@dashes.join(' ')}"
    is_game_over
  end

  def is_game_over
    if @dashes.include?('_') && @bad_guess < 6
      make_guess
    elsif @bad_guess == 6
      game_lost
    else
      game_win
    end
  end

  def noose
    puts "\s\s\s\s_____"
    puts "\s\s\s\s|   !"
    puts "\s\s\s\s|   #{@man[0]}"
    puts "\s\s\s\s|  #{@man[2]}#{@man[1]}#{@man[3]}"
    puts "\s\s\s\s|  #{@man[4]} #{@man[5]}"
    puts "\s\s\s\s|_______"
    puts
  end

  def start
    system 'clear'
    check_load
    game_title
    how_to_play
    noose
    pick_random_word
    create_dashes
    make_guess
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exists?('saved_games')
    saved_game = 'saved_games/saved_game'
    File.open(saved_game, 'w') { |file| file.puts self.serialize }
    puts "\n Game saved! Come back soon!"
    exit
  end

  def load_game
    saved_game = 'saved_games/saved_game'
    data = File.read(saved_game)
    unserialize(data)
    puts "\n Welcome back!"
    restore_hangman
    next_round
  end

  def restore_hangman
    i = 0
    until i == @bad_guess - 1
      @man[i] = BODYPARTS[i]
      i += 1
    end
  end

  def remove_save
    saved_game = 'saved_games/saved_game'
    File.delete(saved_game) if File.exists? saved_game
    puts "\sFile deleted."
    sleep 2
    system 'clear'
  end

  def check_load
    if File.exists?('saved_games/saved_game')
      print "\sDo you want to load a saved game? (Y/N):"
      input = gets.chomp.upcase
      if input == 'Y'
        load_game
      else
        print "\sRemove existing save file? (Y/N):"
        input = gets.chomp.upcase
        remove_save if input == 'Y'
      end
    end
  end
end

Hangman.new.start
