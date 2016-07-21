module VideosHelper

  def youtube_embed(youtube_url)
    youtube_id = youtube_url.split('=').last
    content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}")
  end

  def vimeo_embed(vimeo_url)
    vimeo_id = vimeo_url.split('/').last
    content_tag(:iframe, nil, src: "//player.vimeo.com/video/#{vimeo_id}")
  end
end
