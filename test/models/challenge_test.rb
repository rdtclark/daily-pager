require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
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

    @challenge = Challenge.create!(content: "Do 25 Start Jumps, go!")

    challenges.each do |challenge|
      challenge.intentions += ["stoicism", "gratitude"]
      challenge.save
    end
  end

  test "challenge should be valid" do
    assert @challenge.valid?
  end

  test "content should be present" do
    @challenge.content = " "
    assert_not @challenge.valid?
  end

  test "content should be at most 140 characters" do
    @challenge.content = "a" * 141
    assert_not @challenge.valid?
  end

  test "challenge can have many journals" do
    @journal_challenges = @challenge.journal_challenges.create!(journal: @journal_1)
    @journal_challenges = @challenge.journal_challenges.create!(journal: @journal_2)
    assert_equal 2, @challenge.journals.count
  end

  test "challenge can have many intention tags" do
    @challenge.intentions = ["stoicism"]
    @challenge.save
    assert_equal ["stoicism"], @challenge.intentions
  end

  test "challenges can be retrieved randomly in blocks of 10 by single intention tag and associated with a journal" do
    # Not testing for randomness
    assert_equal 10, Challenge.intention_block("stoicism", @journal_1).count
    assert_equal 10, @journal_1.challenges.count
  end

  test "challenges retrieved 10 per intention and associated with a journal" do
    # Not testing for randomness
    Challenge.block(["stoicism", "gratitude"], @journal_1)
    assert_equal 20, @journal_1.challenges.count
  end
end
