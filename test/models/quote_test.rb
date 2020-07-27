require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
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

    @quote = Quote.create!(content: "For it is so, by Robin Clark")

    quotes.each do |quote|
      quote.intentions += ["stoicism", "gratitude"]
      quote.save
    end
  end

  test "quote should be valid" do
    assert @quote.valid?
  end

  test "content should be present" do
    @quote.content = " "
    assert_not @quote.valid?
  end

  test "content should be at most 140 characters" do
    @quote.content = "a" * 181
    assert_not @quote.valid?
  end

  test "quote can have many journals" do
    @journal_quotes = @quote.journal_quotes.create!(journal: @journal_1)
    @journal_quotes = @quote.journal_quotes.create!(journal: @journal_2)
    assert_equal 2, @quote.journals.count
  end

  test "quote can have many intention tags" do
    @quote.intentions += ["stoicism"]
    @quote.save
    assert_equal ["stoicism"], @quote.intentions
  end

  test "quotes can be retrieved randomly in blocks of 10 by single intention tag and associated with a journal" do
    # Not testing for randomness
    assert_equal 40, Quote.intention_block("stoicism", @journal_1).count
    assert_equal 40, @journal_1.quotes.count
  end

  test "quotes retrieved 40 per intention and associated with a journal" do
    # Not testing for randomness
    Quote.block(["stoicism", "gratitude"], @journal_1)
    assert_equal 80, @journal_1.quotes.count
  end
end
