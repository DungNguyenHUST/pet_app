module CoverVitaesHelper
    def count_copy_cover_vitae(cv)
        if cv
            count = CoverVitae.where(origin_id: cv.id).count
            return count
        end
    end
end
