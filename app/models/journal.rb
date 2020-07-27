class Journal < ApplicationRecord
  belongs_to :user
  validates :user_id, :name, :font_1, :font_2, :size, presence: true
  validates :name, length: { maximum: 60 }
  ###

  has_many :journal_quotes, dependent: :delete_all
  has_many :journal_questions, dependent: :delete_all
  has_many :journal_challenges, dependent: :delete_all
  has_many :journal_prompts, dependent: :delete_all

  has_many :questions, through: :journal_questions
  has_many :quotes, through: :journal_quotes
  has_many :prompts, through: :journal_prompts
  has_many :challenges, through: :journal_challenges

  has_one_attached :journal_pdf, dependent: :purge_later
  has_one_attached :journal_pdf_preview, dependent: :purge_later

  taggable_array :intentions

  def price
    22.00
  end

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

  def cached_questions
    Rails.cache.fetch([self, "journal_questions"]) { questions.to_a }
  end

  def cached_quotes
    Rails.cache.fetch([self, "journal_quotes"]) { quotes.to_a }
  end

  def cached_prompts
    Rails.cache.fetch([self, "journal_prompts"]) { prompts.to_a }
  end

  def cached_challenges
    Rails.cache.fetch([self, "journal_challenges"]) { challenges.to_a }
  end

  def cached_intentions
    Rails.cache.fetch([self, "journal_challenges"]) { intentions }
  end
  
  def cached_font_1
    Rails.cache.fetch([self, "journal_font_1"]) { font_1.to_s }
  end

  def cached_font_2
    Rails.cache.fetch([self, "journal_font_2"]) { font_2.to_s }
  end

  # needs test
  PAGE_SIZES = ["Personal","A5"]
  FONT_CHOICES = [
    "Fira Sans Book",
    "Fira Sans Italic",
    "Fira Sans Semi Bold",
    "Inria Serif Regular",
    "Inria Serif Light Italic",
    "Inria Sans Bold",
    "Jost 400 Book",
    "Jost 400 Book Italic",
    "Jost 600 Semi"
  ]

  # create pdf in background job
  def generate
    GenerateJournal.perform_async(id)
  end


end
