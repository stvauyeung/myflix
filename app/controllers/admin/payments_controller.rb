class Admin::PaymentsController < AdminsController
	def index
		@payments = Payment.last(10).reverse
	end
end