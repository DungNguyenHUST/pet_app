class CoverVitaesController < ApplicationController
    before_action :require_admin_login, only: [:new, :create, :edit, :update, :destroy]
    
    def index
        @cover_vitaes = CoverVitae.all
    end

    def new
        @cover_vitae = CoverVitae.new
    end

    def create
        @cover_vitae = CoverVitae.new(cover_vitae_param)
        if @cover_vitae.save
            redirect_to admin_path(current_admin, tab_id: 'CoverVitaeID')
        end
    end

    def show
        @cover_vitae = CoverVitae.find(params[:id])
    end

    def cover_vitae_param
        params.require(:cover_vitae).permit(:id, :title, :description, :detail, :category, :language, :style, :avatar)
    end
end
