class Reservation < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true
  validates_datetime :start_at

  before_validation :set_ent_at

  scope :by_date, ->(date) { where('DATE(start_at) = ?', date) }

  private

  def set_ent_at
    self.end_at = start_at + 1.hour
  end
end
