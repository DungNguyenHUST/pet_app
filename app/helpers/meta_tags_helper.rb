module MetaTagsHelper
    def meta_title
      content_for?(:meta_title) ? content_for(:meta_title) : I18n.t(:meta_title_default)
    end

    def meta_separator
      content_for?(:meta_separator) ? content_for(:meta_separator) : DEFAULT_META["meta_separator"]
    end

    def meta_product_name
      content_for?(:meta_product_name) ? content_for(:meta_product_name) : DEFAULT_META["meta_product_name"]
    end
  
    def meta_description
      content_for?(:meta_description) ? content_for(:meta_description) : I18n.t(:meta_description_default)
    end

    def meta_key_word
      content_for?(:meta_key_word) ? content_for(:meta_key_word) : I18n.t(:meta_key_word_default)
    end
  
    def meta_image
      meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"])
    end

    def meta_robots
      meta_robots = (content_for?(:meta_robots) ? content_for(:meta_robots) : DEFAULT_META["meta_robots"])
    end
end