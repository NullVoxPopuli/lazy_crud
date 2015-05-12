module LazyCrud
  module BeforeHookMethods
    include Constants

    ACTIONS_WITH_HOOKS.each do |action|
      # runs all of the hooks
      define_method("run_before_#{action}_hooks") do
        hook_list = self.send("before_#{action}_hooks")

        if hook_list
          hook_list.each do |hook|
            hook.call(@resource)
          end
        end

        # run the before action method if it exists
        if respond_to?("before_#{action}")
          self.send("before_#{action}")
        end
      end
    end
  end
end
