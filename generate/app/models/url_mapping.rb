class UrlMapping < ApplicationRecord
  validates :short_id, uniqueness: true
end
