require 'test_helper'

class JournalPdfTest < ActiveSupport::TestCase

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
    challenges.each do |challenge|
      challenge.journal_challenges.create!(journal: @journal)
    end
    quotes.each do |quote|
      quote.journal_quotes.create!(journal: @journal)
    end
    prompts.each do |prompt|
      prompt.journal_prompts.create!(journal: @journal)
    end
  end

  test "adding questions" do
    pdf = JournalTemplatePdf.new(@journal)
    pdf.output_journal
    rendered_pdf = pdf.render
    pdf_analysis = PDF::Inspector::Text::analyze(rendered_pdf)
    assert_equal true, pdf_analysis.strings.include?('question_1')
  end

  # test "adding challenges" do
  #   pdf = JournalTemplatePdf.new(@journal)
  #   pdf.output_journal
  #   rendered_pdf = pdf.render
  #   pdf_analysis = PDF::Inspector::Text::analyze(rendered_pdf)
  #   assert_equal true, pdf_analysis.strings.include?('challenge_1')
  # end
  
  # test "adding quotes" do
  #   pdf = JournalTemplatePdf.new(@journal)
  #   pdf.output_journal
  #   rendered_pdf = pdf.render
  #   pdf_analysis = PDF::Inspector::Text::analyze(rendered_pdf)
  #   assert_equal true, pdf_analysis.strings.include?('quote_1')
  # end

  # test "adding prompts" do
  #   pdf = JournalTemplatePdf.new(@journal)
  #   pdf.output_journal
  #   rendered_pdf = pdf.render
  #   pdf_analysis = PDF::Inspector::Text::analyze(rendered_pdf)
  #   assert_equal true, pdf_analysis.strings.include?('prompt_1')
  # end

  # currently retruns {:name=>:"c42e9a+Jost-Book", :size=>15} as font
  # test "adding user selected fonts" do
  #   # test each font to check pdf is valid
  #   # test corrent font appeears in the pdf
  #   pdf = JournalTemplatePdf.new(@journal)
  #   pdf.output_journal
  #   rendered_pdf = pdf.render
  #   pdf_analysis = PDF::Inspector::Text::analyze(rendered_pdf)
  #   p pdf_analysis.font_settings.first
  #   assert_equal true, pdf_analysis.font_settings.include?("c42e9a+Jost-Book")
  # end
end
