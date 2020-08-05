# frozen_string_literal: true

require_relative 'displayable.rb'

# Creates a new Hangman game
class Hangman
  include Displayable

  attr_accessor :random_word

  def initialize
    @random_word = ''
    @dashes = ''
    @bad_guess = 0
  end

  def pick_random_word
    until @random_word.chomp.length >= 5 && @random_word.chomp.length <= 12 
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
    @@used_letters.push(guess)
    if letters_match?(guess)
      change_dashes(guess)
    else
      hang_man
    end
  end

  def letters_match?(guess)
    @random_word.include?(guess)
  end

  def change_dashes(guess)
    @dashes.each_with_index do |_dash, index|
      @dashes[index] = guess if @random_word[index] == guess
    end
    next_round
  end

  def hang_man
    @@man[@bad_guess] = @@bodypart[@bad_guess]
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

  def start
    system 'clear'
    game_title
    how_to_play
    noose
    pick_random_word
    create_dashes
    make_guess
  end
end

Hangman.new.start
