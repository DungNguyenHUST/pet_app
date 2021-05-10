module ApplicationHelper
    def time_ago_in_words(from_time, include_seconds_or_options = {})
        distance_of_time_in_words(from_time, Time.now, include_seconds_or_options)
    end

    def since_date(end_time)
    	cal_date = (end_time - DateTime.now)/(24*60*60)
    end
end
