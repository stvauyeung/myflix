class VideoDecorator < Draper::Decorator
	delegate_all

	def average_rating
    if object.rating
      "Rated: #{object.rating}/5"
    else
      "Not Rated"
    end
  end
end