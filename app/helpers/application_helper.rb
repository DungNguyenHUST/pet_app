module ApplicationHelper
    def time_ago_in_words(from_time, include_seconds_or_options = {})
        distance_of_time_in_words(from_time, Time.now, include_seconds_or_options)
    end

    def since_date(end_time)
    	cal_date = (end_time - DateTime.now)/(24*60*60)
    end
    
    def find_owner_user(object)
        @owner_user = nil
        if object.user_id.present?
            @owner_user = User.find_by(id: object.user_id)
        end
        return @owner_user
    end

    def find_owner_employer(object)
        @owner_employer = nil
        if object.user_id.present?
            @owner_employer = Employer.find_by(id: object.user_id)
        end
        return @owner_employer
    end

    def find_trigger_user(object)
        @trigger_user = nil
        if object.trigger_user_id.present?
            @trigger_user = User.find_by(id: object.trigger_user_id)
        end
        return @trigger_user
    end

    def find_user_color(user_name)
        color_type = 0
        if user_name.present?
            case user_name[0].upcase
            when "A","Ă","Â"
                color_type = 1
            when "B","C","D"
                color_type = 2
            when "Đ","E","Ê","F"
                color_type = 3
            when "G","H","I","J","K"
                color_type = 4
            when "L","M","N"
                color_type = 5
            when "O","Ô","Ơ"
                color_type = 6
            when "P","Q","R"
                color_type = 7
            when "S","T","U","Ư"
                color_type = 8
            when "V","X","Y","Z"
                color_type = 9
            else
                color_type = 0
            end
        else
            color_type = 0 
        end
        
        return color_type
    end

    def convert_number_to_human(number)
        number_in_human = ""

        case number
        when 0..999
            number_in_human = number.to_s
        when 1000..999999
            number_in_human = number_to_human(number, :format => '%n%u', :units => { :thousand => 'k' })
        when 1000000..999999990
            number_in_human = number_to_human(number, :format => '%n%u', :units => { :million => 'm' })
        when 1000000000..999999999999
            number_in_human = number_to_human(number, :format => '%n%u', :units => { :million => 'b' })
        else
            number_in_human = number_to_human(number, :format => '%n%u', :units => { :trillion => 't' })
        end

        return number_in_human
    end

    def convert_vie_to_eng(str)
        if str.nil?
            return ''
        else
            new_str = str.downcase.to_s
            new_str.gsub! /[àáạãảâậấẫầẩăặắằẵẳ]/, "a"
            new_str.gsub! /[đ]/, "d"
            new_str.gsub! /[èéẹẽẻêềếệễể]/, "e"
            new_str.gsub! /[óòọõỏôốồộỗổơớợỡờở]/, "o"
            new_str.gsub! /[úùụũủưứựừữử]/, "u"
            new_str.gsub! /[íịìĩỉ]/, "i"
            new_str.gsub! /[ýỵỹỳỷ]/, "y"
            new_str.gsub! /[-,.!@#$%^^&*():'"?<>]/, ""
            new_str.squish!
            return new_str
        end
    end

    def convert_flash_message(name)
        if name == "danger" || name == "error" || name == "alert" || name == "warning"
            new_name = "danger"
        else
            new_name = "success"
        end
        return new_name
    end

    def check_exist_url(url)
        url = URI.parse(url) rescue false
        return url
        # if url
        #     req = Net::HTTP.new(url.host, url.port)
        #     res = req.request_head(url.path)
        # end
        
        # if res.present?
        #     return true
        # else
        #     return false
        # end
    end
end
