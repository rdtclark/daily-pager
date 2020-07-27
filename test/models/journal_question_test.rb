require 'test_helper'

class JournalQuestionTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "robin@example.com", password: "letmein")
    @journal = @user.build_journal(
      name: "Robins Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Times New Roman",
      font_2: "Arial"
    )
    @question_1 = Question.create!(content: "Who am I?")
    @question_2 = Question.create!(content: "What am I?")
  end
end
