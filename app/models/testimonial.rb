class Testimonial < ActiveRecord::Base

  enum delay: { did_not_show: 1, an_hour_late: 2, half_hour_late: 3, quarter_hour_late: 4, on_time: 5 }
  enum accuracy: { not_at_all_accurate: 1, a_little_accurate: 2, somewhat_accurate: 3, quite_accurate: 4, perfect: 5 }
  enum satisfaction: { not_at_all: 1, bad: 2, okay: 3, very_good:4, excellent: 5 }

  belongs_to :author, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :service

  validates :author, presence: true
  validates :receiver, presence: true
  validates :service, presence: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :text, presence: true

  after_create :update_service_rating

  private

  def update_service_rating
    service.update_column :rating, service.testimonials.sum(:rating).to_f / service.testimonials.count
  end
end
