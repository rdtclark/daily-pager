require 'test_helper'

class JournalsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(email: "robin@example.com", password: "letmein")
    @journal = @user.create_journal!(
      name: "Robins Intention Journal 2020",
      processing: false,
      size: "A5",
      font_1: "Jost 400 Book",
      font_2: "Fira Sans Semi Bold"
    )
    questions.each do |question|
      question.journal_questions.create!(journal: @journal)
    end
  end

  test "should get new" do
    get new_journal_path(as: @user)
    assert_response :success
    assert_template 'journals/new'
  end

  # Need to look at how to test ActiveStorage
  # in development and production

  # test "should create a journal pdf" do
  #   # test creating journal pdf with bg job
  # end

  # This test should pass when page is reloading upon bg completion
  # test "should get show" do
  #   get new_journal_path(as: @user)
  #   get journal_path(@journal)
  #   assert_response :success
  #   assert_template 'journals/show'
  # end

  # test "should open a journal pdf" do
  # this test will need to be updated to factor in waiting for the bg job to finish
  #   get new_journal_path(as: @user)
  #   get journal_path(@journal, format: "pdf")
  #   assert_response :success
  # end
end
