class VideoDecorator < Draper::Decorator
	delegate_all

	def average_rating
    if rating
      "Rated: #{rating}/5"
    else
      "Not Rated"
    end
  end
end