namespace :maintenance do
  desc "TODO"
  task attachments: :environment do
  	@property_names = { ad: :cover_file_name, image: :item_file_name, post: :cover_file_name, shop: :image_file_name, user: :avatar_file_name }
  	@directories = {
			ad:  ENV['public_folder_path'] + 'system/ads/covers/',
			image:  ENV['public_folder_path'] + 'system/images/items/',
			post:  ENV['public_folder_path'] + 'system/posts/covers/',
			shop:  ENV['public_folder_path'] + 'system/shops/images/',
			user:  ENV['public_folder_path'] + 'system/users/avatars/'
  	}

  	def dir_entries(directory)
  		return Dir.entries(directory).select{ |d| d != '.' && d != '..' }
  	end

  	def change_invalid_names(collection, model_name)
  		reg_exp = /[^A-Za-z0-9.\_\-]/
  		collection.select do |member|
  			property = @property_names[model_name.downcase.to_sym].to_s
  			directory = @directories[model_name.downcase.to_sym]
  			file_name = member[property]
  			if file_name.present? && file_name[reg_exp].present?
  				id = member.id.to_s
  				(id.length...9).each{ id = '0' + id }
  				id = id[0...3] + '/' + id[3...6] + '/' + id[6...9]
  				
  				current_dir = directory + '/' + id + '/'
  				if File.directory?(current_dir) && (styles = dir_entries(current_dir)).try(:include?, 'original')
						styles.each do |style|
							style_dir = current_dir + style + '/'
							path =  style_dir + file_name
							if File.exists?(path)
								new_name = model_name.downcase + '_' + property.sub('_file_name', '') + File.extname(path)
								#File.rename(path, style_dir + new_name)
								#member[property] = new_name
								#member.save
								puts 'CHANGE FOR: ' + model_name
								puts 'PRODUCT ID: ' + member.imageable.id.to_s if model_name.downcase.to_sym == :image
								puts 'FROM:' + path
								puts 'TO:' + style_dir + new_name
								puts 'PROPERTY: ' + new_name
								puts '_______________________'
								puts ''
							end
						end
  				end
  			end
  		end
  	end

  	puts '_____________________________'
		puts ''
		puts 'MANTAIN ATTACHMENTS'
		puts 'Use this script to rename invalid attachment file names'
		puts '_____________________________'
		puts ''
		puts 'Starts with Ads'
		puts '_____________________________'
		puts ''

		change_invalid_names(Ad.all, Ad.name)

		puts '_____________________________'
		puts ''
		puts 'Now Product images'
		puts '_____________________________'
		puts ''
		change_invalid_names(Image.all, Image.name)

		puts '_____________________________'
		puts ''
		puts 'Now with Posts'
		puts '_____________________________'
		puts ''
		change_invalid_names(Post.all, Post.name)

		puts '_____________________________'
		puts ''
		puts 'Now with Shops'
		puts '_____________________________'
		puts ''
		change_invalid_names(Shop.all, Shop.name)

		puts '_____________________________'
		puts ''
		puts 'Finally Users'
		puts '_____________________________'
		puts ''
		change_invalid_names(User.all, User.name)
	end

end
