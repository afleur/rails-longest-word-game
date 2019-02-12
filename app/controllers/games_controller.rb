require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess]
    @grid = params[:grid]
    if included?(@guess, @letters) == true
      if english_word?(@guess) == true
        @message = "Congratulations! \'#{@guess.upcase}'\ is an English word"
      else
        @message = "Sorry but \'#{@guess.upcase}'\ is not an English word"
      end
    else
      @message = "Sorry but \'#{@guess.upcase}'\ can't be built out of #{@grid}"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end

def included?(guess, letter)
  guess.chars.all? { |letter| guess.count(letter) <= letter.count(letter) }
end
