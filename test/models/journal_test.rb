require 'test_helper'

class JournalTest < ActiveSupport::TestCase

  def setup
    @user = User.create!(email: "robin@example.com", password: "letmein")
    @journal = @user.create_journal!(
      name: "Robins Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Jost 400 Book",
      font_2: "Fira Sans Semi Bold"
    )
  end

  test "journal should be valid" do
    assert @journal.valid?
  end

  test "user id should be present" do
    @journal.user_id = nil
    assert_not @journal.valid?
  end

  test "name should be present" do
    @journal.name = "  "
    assert_not @journal.valid?
  end

  test "font_1 should be present" do
    @journal.font_1 = "  "
    assert_not @journal.valid?
  end

  test "font_2 should be present" do
    @journal.font_2 = "  "
    assert_not @journal.valid?
  end

  test "size should be present" do
    @journal.size = "  "
    assert_not @journal.valid?
  end

  test "name should be at most 60 characters" do
    @journal.name = "a" * 61
    assert_not @journal.valid?
  end
end

