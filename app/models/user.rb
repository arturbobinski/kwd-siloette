class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  enum role: [:customer, :dancer, :company, :admin]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  attr_accessor :accept_terms, :is_admin

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :role, inclusion: { in: User.roles.keys[0..-2] }, if: 'is_admin.blank?'
  validate :acceptance_terms, on: :create

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
