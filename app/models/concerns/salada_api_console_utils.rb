module SaladaApiConsoleUtils
	extend ActiveSupport::Concern

	#created this to use in terminal (reails c)
	def manage_interactions
	  User.all.each do |user|
	    products = user.comments.question.select(:commentable_id, :commentable_type).group(:commentable_id).map{|c| c.commentable}
	    products.each do |product|
	    	interaction = Interaction.find_by(user: user, product: product) || Interaction.create(user: user, product: product)
	      user.comments.question.where(commentable: product).order(created_at: :asc).each do |question|
	        interaction.last_comment = question
	        if question.answer.present?
	          interaction.last_comment = question.answer
	          question.answer.interaction = interaction
	          question.answer.save
	        end
	        question.interaction = interaction
	        question.save
	      end
	      interaction.save
	    end
	  end
	end

	def shop_fix_attachment(shop)
		keys = shop.image.styles.keys + [:original]
		new_name = 'cover' + File.extname(shop.image.path)
		
		keys.each do |key|
			path = shop.image.path(key)
			new_path = File.join(File.dirname(path), new_name)
			File.rename(path, new_path)
		end
		
		shop.image_file_name = new_name
		shop.save
	end

end
