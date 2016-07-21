class VideoUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless video_url?(value)
      record.errors[attribute] << (options[:message] || 'must be a valid URL')
    end
  end

  def video_url?(url)
    return unless url && url.present?
    host = URI.parse(url).host.gsub('www.', '').gsub('.com', '')
    Video.providers.keys.include?(host)
  end
end
