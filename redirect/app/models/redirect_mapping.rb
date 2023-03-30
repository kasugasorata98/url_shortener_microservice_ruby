class RedirectMapping < ApplicationRecord
  validates :short_id, uniqueness: true
  validates :url_mapping_id, uniqueness: true
end
