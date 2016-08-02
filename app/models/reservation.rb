class Reservation < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true
  validates_datetime :start_at

  before_validation :set_ent_at

  scope :by_date, ->(time) { where(start_at: time..time.end_of_day) }

  private

  def set_ent_at
    self.end_at = start_at + 1.hour
  end
end
