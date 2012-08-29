module Models

  class ShortenedUrl < ActiveRecord::Base
    validates_format_of :original_url, with: /^https?:\/\/.*$/
    validates_uniqueness_of :original_url
    validates_presence_of :original_url
    has_many :access_to_url, :class_name => 'AccessToUrl', :dependent => :destroy, :foreign_key => 'shortened_url_id'

    def url
      self.id.to_s(36)
    end

    def analytics
      "#{self.id.to_s(36)}+"
    end
  end


  class AccessToUrl < ActiveRecord::Base
    validates_presence_of :browser_name
    belongs_to :shortened_url, :class_name => 'ShortenedUrl'
    before_create :normalize_user_agent

    def normalize_user_agent
      self.browser_name = case self.browser_name.downcase
        when /chrome/ then "chrome"
        when /firefox/ then "firefox"
        when /msie/ then "ie"
        else
          'others'
        end
    end
  end

end

