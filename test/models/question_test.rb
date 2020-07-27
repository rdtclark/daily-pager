require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  def setup
    @user_1 = User.create!(email: "robin@example.com", password: "letmein")
    @user_2 = User.create!(email: "bob@example.com", password: "letmein")
    @journal_1 = @user_1.create_journal!(
      name: "Robins Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Times New Roman",
      font_2: "Arial"
    )

    @journal_2 = @user_2.create_journal!(
      name: "Bobs Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Times New Roman",
      font_2: "Arial"
    )

    @question = Question.create!(content: "Who am I?")

    questions.each do |question|
      question.intentions += ["stoicism", "gratitude"]
      question.save
    end
  end

  test "question should be valid" do
    assert @question.valid?
  end

  test "content should be present" do
    @question.content = " "
    assert_not @question.valid?
  end

  test "content should be at most 140 characters" do
    @question.content = "a" * 141
    assert_not @question.valid?
  end

  test "question can have many journals" do
    @journal_questions = @question.journal_questions.create!(journal: @journal_1)
    @journal_questions = @question.journal_questions.create!(journal: @journal_2)
    assert_equal 2, @question.journals.count
  end

  test "question can have many intention tags" do
    @question.intentions += ["stoicism"]
    @question.save
    assert_equal ["stoicism"], @question.intentions
  end

  test "questions can be retrieved randomly in blocks of 10 by single intention tag and associated with a journal" do
    # Not yet testing for randomness
    assert_equal 10, Question.intention_block("stoicism", @journal_1).count
    assert_equal 10, @journal_1.questions.count
  end

  test "questions retrieved 10 per intention and associated with a journal" do
    # Not yet testing for randomness
    Question.block(["stoicism", "gratitude"], @journal_1)
    assert_equal 20, @journal_1.questions.count
  end
end
