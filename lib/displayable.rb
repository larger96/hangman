# frozen_string_literal: true

# Displays all text for the Hangman game
module Displayable
  BODYPARTS = ['O', '|', '~', '~', '/', '\\']
  
  def game_title
    puts "\t-------"
    puts "\tHANGMAN"
    puts "\t-------\n"
  end

  def how_to_play
    puts "\sHow to Play"
    puts "\s-----------"
    puts "\sThe aim of the game is to guess the secret word."
    puts "\sGuess one letter at a time and correct guesses will be revealed."
    puts "\sChoose your guesses carefully, a man's life is on the line..."
    puts
  end

  def choose_letter
    print "\n\sMake your choice >> "
  end

  def previous_letters
    print "\n\sPrevious guesses:"
    puts "\s#{@used_letters.join(' ')}"
  end

  def game_win
    puts "\n\sGame Over! You win!"
    puts "\sCorrect Word: #{@random_word}"
    exit
  end

  def game_lost
    puts "\n\sGame Over! You lose!"
    puts "\sCorrect Word: #{@random_word}"
    exit
  end
end
