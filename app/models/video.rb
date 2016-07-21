class Video < ActiveRecord::Base

  acts_as_paranoid

  enum provider: %i(youtube vimeo)

  belongs_to :owner, polymorphic: true

  validates :provider, presence: true
  validates :link, presence: true, video_url: true

  before_validation :video_provider

  private

  def video_provider
    return if self.link.nil? || self.link.empty?
    host = URI.parse(self.link).host.gsub('www.','')
    self.provider = :youtube if host.eql?('youtube.com') || host.eql?('youtu.be')
    self.provider = :vimeo if host.eql?('vimeo.com') || host.eql?('player.vimeo.com')
  end
end
