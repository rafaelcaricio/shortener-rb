module UrlHelpers

  def server_url
    @base_url ||= request.base_url
  end

  def link_to path
    "#{server_url}/#{path}"
  end

end
