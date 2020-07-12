module User::Operation
	class Create < Trailblazer:: Operation
		step :create_user
		step :address_present?, Output(:failure) => Id(:send_email)
		step :create_address

		step :send_email
		step :set_response


		def create_user(ctx, user_params:, **)
			puts "inside create user"
			ctx[:user] = User.create(user_params)
		end

		def address_present?(ctx, **)
			puts "inside address_present?"
			ctx[:address_params].present?
		end

		def create_address(ctx, address_params:, **)
			puts "inside create_address?"
			true
			# false
			# ctx[:user].create_address(address_params)
		end

		def send_email(ctx, **)
			puts "inside end email"
		end

		def set_response(ctx, **)
			puts "inside end email"
		end
	end
end