class Admin::PaymentsController < AdminsController
	before_filter :require_admin
	
	def index
		@payments = Payment.last(10).reverse
	end
end