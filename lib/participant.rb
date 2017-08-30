class Participant
  attr_accessor :marker, :name, :score

  def initialize
    @marker = ""
    @name = ""
    @score = 0
  end

  def increment_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end
end
