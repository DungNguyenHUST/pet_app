module ApplicationHelper
    def time_ago_in_words(from_time, include_seconds_or_options = {})
        distance_of_time_in_words(from_time, Time.now, include_seconds_or_options)
    end

    def since_date(end_time)
    	cal_date = (end_time - DateTime.now)/(24*60*60)
    end
    
    def find_owner_user(object)
        User.all.each do |user|
            if object.user_id == user.id
                @owner_user = user
                break
            end
        end
        return @owner_user
    end

    def find_trigger_user(object)
        User.all.each do |user|
            if object.trigger_user_id == user.id
                @trigger_user = user
                break
            end
        end
        return @trigger_user
    end

    def find_user_color(user_name)
        color_type = 0
        case user_name[0]
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

            return color_type
    end
end
