Stripe.api_key = Rails.env.production? ? ENV['STRIPE_SECRET_KEY'] : ENV['STRIPE_TEST_SECRET']

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
  	user = User.find_by_customer_token(event.data.object.customer)
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  subscribe 'charge.failed' do |event|
  	user = User.find_by_customer_token(event.data.object.customer)
    user.deactivate!
  end
end