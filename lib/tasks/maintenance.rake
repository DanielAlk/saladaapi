namespace :maintenance do
	desc 'Maintenance tasks'

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
								File.rename(path, style_dir + new_name)
								if member[property] != new_name
									member[property] = new_name
									member.save
								end
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

	task products: :environment do
		puts '_____________________________'
		puts ''
		puts 'MANTAIN PRODUCTS'
		puts 'Use this script to check for products violating premium/free rules'
		puts 'This may happen due to updates changing the rules'
		puts '_____________________________'
		puts ''

		free_sellers = User.free.seller
		free_sellers_ids = free_sellers.map { |s| s.id }
		ilegal_products = Product.where(:user_id => free_sellers_ids).where.not(:available_at => nil)
		ilegal_products_count = ilegal_products.count
		ilegal_products.each do |p|
			p.available_at = nil
			p.save

			puts "CHANGED PRODUCT"
			puts "ID: #{p.id.to_s}"
			puts "TITLE: #{p.title}"
			puts "USER ID: #{p.user.id.to_s}"
			puts "USER NAME: #{p.user.name}"
			puts '_______________________'
			puts ''
		end

		puts '_____________________________'
		puts ''
		puts "Fixed #{ilegal_products_count.to_s} ilegal products"
		puts '_____________________________'
		puts ''
	end

	task shop_product_count: :environment do
		puts '_____________________________'
		puts ''
		puts 'MANTAIN SHOPS'
		puts 'Use this script to populate product_count column in shops'
		puts '_____________________________'
		puts ''
		Shop.all.each do |shop|
			product_count = shop.products.count
			shop.update(product_count: product_count)
			puts "UPDATED SHOP"
			puts "ID: #{shop.id.to_s}"
			puts "PRODUCT COUNT: #{product_count.to_s}"
			puts '_______________________'
			puts ''
		end
		puts '_____________________________'
		puts ''
		puts "Done..."
		puts '_____________________________'
		puts ''
	end

end
