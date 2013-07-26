module ApplicationHelper
	def video_rating_options(selected=nil)
		options_for_select([5,4,3,2,1].map { |num| [pluralize(num, "Star"), num] }, selected)
	end

	def gravatar(user, size=40)
		gravatar_digest = Digest::MD5.hexdigest(user.email.downcase)
		gravatar_url = "http://www.gravatar.com/avatar/#{gravatar_digest}?s=#{size}"
		image_tag(gravatar_url)
	end
end
