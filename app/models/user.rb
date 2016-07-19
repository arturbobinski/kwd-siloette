class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  enum role: [:customer, :dancer, :company, :admin]
  enum gender: [:male, :female]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  attr_accessor :accept_terms, :is_admin
  delegate :perform_name, :height, :weight, :bust, :ethnicity, :birth_date, :phone_number, to: :profile
  delegate :address, to: :location

  has_one :profile, dependent: :destroy
  has_one :location, as: :owner, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :role, inclusion: { in: User.roles.keys[0..-2] }, if: 'is_admin.blank?'
  validates :description, length: { maximum: 250 }
  validate :acceptance_terms, on: :create

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :location

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def slug_candidates
    [
      :name,
      [:name, :email],
    ]
  end

  def acceptance_terms
    return true if is_admin
    unless accept_terms && accept_terms == '1'
      errors.add :accept_terms, I18n.t('activerecord.errors.models.user.attributes.accept_terms.blank')
    end
  end
end
