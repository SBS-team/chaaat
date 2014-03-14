module MessageHelper
  def sensible_sanitize(html, options)
    if options.include? :not_tags
      options[:tags] = ActionView::Base.sanitized_allowed_tags - options[:not_tags]
    end
    sanitize html, options
  end
end
