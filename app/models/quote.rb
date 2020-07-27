class Quote < ApplicationRecord
  has_many :journal_quotes
  has_many :journals, through: :journal_quotes
  validates :content, presence: true
  validates :content, length: { maximum: 180 }
  taggable_array :intentions
  scope :random, -> { order(Arel::Nodes::NamedFunction.new('RANDOM', [])) }

  # takes a single intention to create 10 random questions associated with
  # a journal object
  def self.intention_block(intention, journal)
    quotes = self.with_any_intentions(intention).random.limit(40)
    quotes.each do |quote|
      quote.journal_quotes.create!(journal: journal)
    end
  end

  # can take multiple intentions and create a question block
  # associated to the correct journal object
  def self.block(intentions, journal)
    quotes_array = []
    intentions.each do |intention|
      quotes = self.with_any_intentions(intention).random.limit(40)
      quotes.each do |quote|
        q = { quote_id: quote.id, 
                  journal_id: journal.id,
                  created_at: Time.now,
                  updated_at: Time.now }
        quotes_array << q
      end
    end
    JournalQuote.insert_all(quotes_array)
  end
end
