module LazyCrud
  module ClassMethods
    include Constants

    # all REST actions will take place on an instance of this class
    def set_resource(klass)
      self.resource_class = klass
    end

    # for scoping the resource
    # useful for nested routes, such as
    # /event/:event_id/package/:package_id
    # where Event would be the parent class and would scope
    # the package
    def set_resource_parent(klass)
      self.parent_class = klass
    end

    # the list of parameters to allow through the strong parameter filter
    def set_param_whitelist(*param_list)
      self.param_whitelist = param_list
    end

    ACTIONS_WITH_HOOKS.each do |action|
      # adds a lambda to the hook array
      define_method("before_#{action}") do |func|
        hook_list = self.send("before_#{action}_hooks")
        hook_list ||= []
        hook_list << func

        self.send("before_#{action}_hooks=", hook_list)
      end
    end
  end
end
