class Category < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 255 }

  scope :male, -> { where('kind < ?', 2) }
  scope :female, -> { where('kind > ?', 0) }

  def to_s
    name
  end
end
