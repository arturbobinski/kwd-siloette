class Payment < ActiveRecord::Base

  include AASM
  include TokenGenerator

  extend FriendlyId
  friendly_id :token, slug_column: :token, use: [:slugged, :finders]

  belongs_to :booking
end
