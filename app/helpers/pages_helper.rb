module PagesHelper
    def get_domain_name(url)
        uri = url.split("/")[2].sub(/^www./,'').downcase
        return uri.to_s
    end
end
