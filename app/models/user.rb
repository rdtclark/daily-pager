class User < ApplicationRecord
  include Clearance::User
  has_one :journal, dependent: :destroy
end
