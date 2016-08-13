class Testimonial < ActiveRecord::Base

  belongs_to :author, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :service

  validates :author, presence: true
  validates :receiver, presence: true
  validates :service, presence: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :delay, inclusion: { in: 1..5 }, allow_blank: true
  validates :accuracy, inclusion: { in: 1..5 }, allow_blank: true
  validates :satisfaction, inclusion: { in: 1..5 }, allow_blank: true
  validates :text, presence: true

  after_create :update_service_rating

  private

  def update_service_rating
    service.update_column :rating, (service.rating + rating) / 2
  end
end
