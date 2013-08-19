module StripeWrapper
	class Charge
		attr_reader :response, :status

		def initialize(response, status)
			@response = response
			@status = status
		end

		def self.create(options={})
			StripeWrapper.set_api_key 
			begin
				response = Stripe::Charge.create(
					amount: options[:amount],
					currency: 'usd',
					card: options[:card],
					description: options[:description])
				new(response, :success)
			rescue Stripe::CardError => e
				new(e, :error)
			end
		end

		def failed?
			status == :error
		end

		def error_message
			response.message
		end
	end

	def self.set_api_key
		Stripe.api_key = Rails.env.production? ? ENV['STRIPE_SECRET_KEY'] : ENV['STRIPE_TEST_SECRET']
	end
end