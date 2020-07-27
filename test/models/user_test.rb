require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "bob@example.com", password: "letmein")
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "associated journals should be destroyed" do
    @user.save
    @journal = @user.create_journal!(
      name: "Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Times New Roman",
      font_2: "Arial"
    )
    assert_difference 'Journal.count', -1 do
      @user.destroy
    end
  end

end
