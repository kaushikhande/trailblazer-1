module User::Operation
  class Index < Trailblazer::Operation
    step :is_valid_user?
    step :load_data
    pass :build_user
    fail :set_errors

    def is_valid_user?(_ctx, **)
      true
    end

    def load_data(ctx, **)
      ctx[:users] = User.all
    end

    def set_errors(ctx, **)
      ctx[:errors] = 'Invalid User'
    end

    def build_user(ctx, **)
      ctx[:build_result] = 'Builded successfully'
    end
  end
end