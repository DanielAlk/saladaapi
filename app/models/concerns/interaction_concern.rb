module InteractionConcern
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
end
