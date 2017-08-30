# frozen_string_literal: true
require_relative 'participant'

class Computer < Participant
  COMPUTER_NAMES = %w(Jon Arya Sansa Robb Ned Catelyn Bran
                      Daenerys Rickon).freeze

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def assign_marker(opponent)
    self.marker = opponent.marker == 'X' ? 'O' : 'X'
  end
end
