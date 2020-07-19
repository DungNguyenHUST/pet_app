module ApplicationHelper
    def time_ago_in_words(from_time, include_seconds_or_options = {})
        distance_of_time_in_words(from_time, Time.now, include_seconds_or_options)
    end
end
