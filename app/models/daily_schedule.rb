class DailySchedule < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true
  validates :wday, presence: true, inclusion: { in: 0..6 }
  validates_uniqueness_of :wday, scope: :user_id
  validates :start_slot, presence: true, inclusion: { in: 0..23 }, if: 'active'
  validates :end_slot, presence: true, inclusion: { in: 0..23 }, numericality: { greater_than: :start_slot }, if: 'active'

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
