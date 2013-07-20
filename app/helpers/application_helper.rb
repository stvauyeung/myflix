module ApplicationHelper
	def video_rating_options(selected=nil)
		options_for_select([5,4,3,2,1].map { |num| [pluralize(num, "Star"), num] }, selected)
	end
end
