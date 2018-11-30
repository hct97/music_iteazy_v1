class Liked < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
