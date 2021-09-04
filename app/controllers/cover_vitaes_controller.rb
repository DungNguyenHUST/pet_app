class CoverVitaesController < ApplicationController
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index
        @cover_vitaes = CoverVitae.sample.all

        if(params.has_key?(:tab_id))
            @tab_id = params[:tab_id]
        else
            @tab_id = "default"
        end
    end

    def new
        @cover_vitae = CoverVitae.new

        @cv_copy = nil
        if (params.has_key?(:cv_sample_id))
            @cv_copy = CoverVitae.find(params[:cv_sample_id])
        end
    end

    def create
        @cover_vitae = CoverVitae.new(cover_vitae_param)

        if user_signed_in?
            @cover_vitae.user_id = current_user.id
        end

        if @cover_vitae.save
            if admin_signed_in?
                redirect_to admin_path(current_admin, tab_id: 'CoverVitaeID')
            end

            if user_signed_in?
                redirect_to user_path(current_user, tab_id: 'CoverVitaeID')
            end
        end
    end

    def show
        @cover_vitae = CoverVitae.find(params[:id])
    end

    def cover_vitae_param
        params.require(:cover_vitae).permit(:id, :title, :description, :detail, :category, :language, :style, :avatar, :sample, :user_id)
    end
end
