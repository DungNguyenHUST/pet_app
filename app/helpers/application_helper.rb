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
end
