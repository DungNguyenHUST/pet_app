module CompanyApplyJobsHelper
    def convert_process_to_str(process)
        str = ""
        if process
            case process
            when -1
                str = I18n.t(:applied)
            when 0
                str = I18n.t(:new)
            when 1
                str = I18n.t(:contacting)
            when 2
                str = I18n.t(:interviewed)
            when 3
                str = I18n.t(:success)
            when 4
                str = I18n.t(:igorned)
            else
                
            end
        end

        return str
    end
end
