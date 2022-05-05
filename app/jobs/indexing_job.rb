class IndexingJob < ApplicationJob
    @queue = :file_serve

    def perform(*args)
        CompanyJob.reindex
        # Company.reindex
        # Problem.reindex
        # User.reindex
        # UserAdward.reindex
        # UserCertificate.reindex
        # UserEducation.reindex
        # UserExperience.reindex
        # UserSkill.reindex
    end
end
