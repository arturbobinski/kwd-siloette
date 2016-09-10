class Category < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 255 }

  scope :male, -> { where(kind: [0, 1]) }
  scope :female, -> { where(kind: [0, 2]) }
  scope :transgender, -> { where(kind: [0, 3]) }

  def to_s
    name
  end
end
