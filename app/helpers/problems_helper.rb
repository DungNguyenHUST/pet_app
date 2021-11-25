module ProblemsHelper
    def convert_diff(diff)
        str = ""
        if diff
            if diff.to_i == 1 || diff.to_s == t(:easy)
                str = t(:easy)
            elsif diff.to_i == 2 || diff.to_s == t(:average)
                str = t(:average)
            elsif diff.to_i == 3 || diff.to_s == t(:hard)
                str = t(:hard)
            else
                str = t(:easy)
            end
        end
        return str
    end
end
