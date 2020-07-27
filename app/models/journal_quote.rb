class JournalQuote < ApplicationRecord
  belongs_to :journal
  belongs_to :quote
end
