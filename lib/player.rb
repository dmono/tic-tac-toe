require_relative 'participant'

class Player < Participant
  def set_name
    choice = nil
    loop do
      puts "Please enter your name:"
      choice = gets.chomp
      break unless choice.strip.empty?
      puts "Sorry, that is not a valid entry."
    end
    self.name = choice
  end

  def set_marker
    choice = nil
    loop do
      puts "Pick your marker: X or O"
      choice = gets.chomp.upcase
      break if %w(X O).include? choice
      puts "Sorry, that is not a valid choice."
    end
    self.marker = choice
  end
end
