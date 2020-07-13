module User::Operation
	class ParseFile < Trailblazer::Operation
    step :read_file
    step :validate_file?
    fail :file_empty_error, fail_fast: true

    step :convert_to_json
    fail :error_in_conversion, fail_fast: true

    step :validate_json
    fail :validate_json_error, fail_fast: true

    step :dump_data

    def read_file(ctx, file_path:, **)
      p 'inside read file'
      ctx[:file_read] = YAML.load(File.read(file_path))
    end

    def validate_file?(ctx, **)
      p 'inside validate file'
      p ctx[:file_read].present?
    end

    def file_empty_error(ctx, **)
      p "Empty file. Keys of the file should be - (Name, DOB, Email)"
    end

    def convert_to_json(ctx, **)
      p "Convert to json"
      ctx[:file_json] = ctx[:file_read].to_json
    end

    def error_in_conversion(ctx, **)
      return true if JSON.parse ctx[:file_json]

      p "Error in conversion #{ctx[:file_read]}"
    end

    def validate_json(ctx, **)
      p "Check for errors"
      # check for error in age > 18
      # Check for email format
      json_data = JSON.parse(ctx[:file_json])
      age = DateTime.parse(json_data["dob"])
      p age = Time.now.year - age.year
      parsed_email = json_data["email"]
      ctx[:age] = age
      ctx[:email] = parsed_email
      age > 18 && URI::MailTo::EMAIL_REGEXP.match?(parsed_email)
    end

    def validate_json_error(ctx, **)
      p "JSON Data validation error #{ctx[:file_read]}"
    end

    def dump_data(ctx, **)
      puts "Data dump successfull."
      User.create(name: ctx[:file_read][:name], age: ctx[:age], email: ctx[:email])
    end
  end
end
