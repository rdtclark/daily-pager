require 'test_helper'

class PromptTest < ActiveSupport::TestCase
  def setup
    @user_1 = User.create!(email: "robin@example.com", password: "letmein")
    @user_2 = User.create!(email: "bob@example.com", password: "letmein")
    @journal_1 = @user_1.create_journal!(
      name: "Robins Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Jost 400 Book",
      font_2: "Fira Sans Semi Bold"
    )

    @journal_2 = @user_2.create_journal!(
      name: "Bobs Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Jost 400 Book",
      font_2: "Fira Sans Semi Bold"
    )

    @prompt = Prompt.create!(content: "Who do I need to be to get what I want in 6 months?")

    prompts.each do |prompt|
      prompt.intentions += ["stoicism", "gratitude"]
      prompt.save
    end
  end

  test "prompt should be valid" do
    assert @prompt.valid?
  end

  test "content should be present" do
    @prompt.content = " "
    assert_not @prompt.valid?
  end

  test "content should be at most 140 characters" do
    @prompt.content = "a" * 141
    assert_not @prompt.valid?
  end

  test "prompt can have many journals" do
    @journal_prompts = @prompt.journal_prompts.create!(journal: @journal_1)
    @journal_prompts = @prompt.journal_prompts.create!(journal: @journal_2)
    assert_equal 2, @prompt.journals.count
  end

  test "prompt can have many intention tags" do
    @prompt.intentions = ["stoicism"]
    @prompt.save
    assert_equal ["stoicism"], @prompt.intentions
  end

  test "prompts can be retrieved randomly in blocks of 10 by single intention tag and associated with a journal" do
    # Not testing for randomness
    assert_equal 10, Prompt.intention_block("stoicism", @journal_1).count
    assert_equal 10, @journal_1.prompts.count
  end

  test "prompts retrieved 10 per intention and associated with a journal" do
    # Not testing for randomness
    Prompt.block(["stoicism", "gratitude"], @journal_1)
    assert_equal 20, @journal_1.prompts.count
  end
end
