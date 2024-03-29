class EmployerBillsController < ApplicationController
	include EmployersHelper 
    before_action :require_employer_login, only: [:index, :new, :create, :show, :edit, :update, :destroy]

	def index 
		@employer = current_employer
		@employer_bills = @employer.employer_bills
	end

	def new
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_bill = Employerbill.new
	end

	def create
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_bill = @employer.employer_bills.build(employer_bill_param)
		if @employer_bill.save
            flash[:success] = I18n.t(:send_success)
        end
        redirect_to employer_help_path(tab: 'BillingHelpID')
	end

	def edit
		@employer = Employer.friendly.find params[:employer_id]
		@employer_bill = @employer.employer_bills.find(params[:id])
	end

	def update
		@employer = Employer.friendly.find params[:employer_id]
		@employer_bill = @employer.employer_bills.find(params[:id])
		if @employer_bill.update(employer_bill_param)
            if admin_signed_in? # confirm employer payment
                if(@employer_bill.confirmed == true)
                    remain_cost = @employer_bill.total_cash.to_i + @employer_bill.employer.remain_cost.to_i
					if @employer.limit_cost == 0 # Set defaut cost setting
						@employer_bill.employer.update(:remain_cost => remain_cost, 
														:limit_cost => remain_cost,
														:use_cost_seq => 0,
														:cost_status => 1)
					elsif auth_used_cost_of_employer(@employer) == false # Only set cost
						@employer_bill.employer.update(:remain_cost => remain_cost)
					else # Auto start ads
						@employer_bill.employer.update(:remain_cost => remain_cost,
														:cost_status => 1)
					end
                    flash[:success] = I18n.t(:confirm_success)
                end
                redirect_to admin_path(current_admin, tab: "AdminEmployerBillID")
            end
        end
	end
	
	def destroy
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_bill = @employer.employer_bills.find(params[:id])
		@employer_bill.destroy
	end

	def show
		@employer = Employer.friendly.find(params[:employer_id])
		@employer_bill = @employer.employer_bills.find(params[:id])
	end

	private

	def employer_bill_param
		params.require(:employer_bill).permit(:id, :employer_id, :bill_image, :confirmed, :total_cash)
	end
end
