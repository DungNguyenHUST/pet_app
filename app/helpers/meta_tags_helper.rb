module MetaTagsHelper
    def meta_title
      content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
    end

    def meta_separator
      content_for?(:meta_separator) ? content_for(:meta_separator) : DEFAULT_META["meta_separator"]
    end

    def meta_product_name
      content_for?(:meta_product_name) ? content_for(:meta_product_name) : DEFAULT_META["meta_product_name"]
    end
  
    def meta_description
      content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
    end

    def meta_key_word
      content_for?(:meta_key_word) ? content_for(:meta_key_word) : DEFAULT_META["meta_key_word"]
    end
  
    def meta_image
      meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"])
    end
end