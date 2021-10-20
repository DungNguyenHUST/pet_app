class CoverVitaesController < ApplicationController
    include CoverVitaesHelper
    before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy, :render_docx, :primary]

    def index
        @cover_vitaes = CoverVitae.sample.all.sort_by{|cv| count_copy_cover_vitae(cv)}.reverse
        @cover_vitaes = Kaminari.paginate_array(@cover_vitaes).page(params[:page]).per(12)
        
        @cover_vitaes_moderm = CoverVitae.sample.all.where(style: "Chuyên Nghiệp")
        @cover_vitaes_moderm = @cover_vitaes_moderm.page(params[:page]).per(12)

        @cover_vitaes_creative = CoverVitae.sample.all.where(style: "Sáng tạo")
        @cover_vitaes_creative = @cover_vitaes_creative.page(params[:page]).per(12)

        @cover_vitaes_simple = CoverVitae.sample.all.where(style: "Đơn giản")
        @cover_vitaes_simple = @cover_vitaes_simple.page(params[:page]).per(12)

        @cover_vitaes_pro = CoverVitae.sample.all.where(style: "Chuyên nghiệp")
        @cover_vitaes_pro = @cover_vitaes_pro.page(params[:page]).per(12)

        @cover_vitaes_vie = CoverVitae.sample.all.where(language: "Tiếng Việt")
        @cover_vitaes_vie = @cover_vitaes_vie.page(params[:page]).per(12)

        @cover_vitaes_eng = CoverVitae.sample.all.where(language: "Tiếng Anh")
        @cover_vitaes_eng =  @cover_vitaes_eng.page(params[:page]).per(12)

        @cover_vitaes_jap = CoverVitae.sample.all.where(language: "Tiếng Nhật")
        @cover_vitaes_jap = @cover_vitaes_jap.page(params[:page]).per(12)

        if(params.has_key?(:tab))
            @tab = params[:tab]
        else
            @tab = "default"
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
                redirect_to admin_path(current_admin, tab: 'AdminCoverVitaeID')
            end

            if user_signed_in?
                redirect_to user_path(current_user, tab: 'AdminCoverVitaeID')
            end
        end
    end

    def show
        @cover_vitae = CoverVitae.find(params[:id])
    end

    def edit
        @is_edit = params[:is_edit]
        @cover_vitae = CoverVitae.find params[:id]
    end

    def update
        @cover_vitae = CoverVitae.find params[:id]
        if(@cover_vitae.update(cover_vitae_param))
            flash[:success] = "Cập nhật thông tin thành công"
            redirect_to cover_vitae_path(@cover_vitae)
        else
            flash[:danger] = "Lỗi, không thể cập nhật thông tin"
        end
    end

    def render_docx
        @cover_vitae = CoverVitae.find(params[:id])
        respond_to do |format|
            format.html do
                if @cover_vitae.title
                    title = @cover_vitae.title
                else
                    title = "Cover_Vitae" + current_user.name
                end
                render docx: title + '.docx', content: @cover_vitae.detail
            end
        end
    end

    def primary
        @cover_vitae = CoverVitae.find params[:id]
        @other_created = CoverVitae.where(user_id: current_user.id).reject{|i| i.id == @cover_vitae.id}
        if @cover_vitae.primary
            @cover_vitae.update(:primary => false)
        else
            @cover_vitae.update(:primary => true)
            # Reset other CV
            @other_created.each do |cv|
                cv.update(:primary => false)
            end
        end
        respond_to do |format|
            format.html {}
            format.js
        end
    end

    def cover_vitae_param
        params.require(:cover_vitae).permit(:id, :title, :description, :detail, :category, :language, :style, :avatar, :sample, :user_id, :origin_id)
    end
end
