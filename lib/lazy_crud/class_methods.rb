module LazyCrud
  module ClassMethods
    include Constants

    # for use with APIs
    def set_serializer(klass)
      self.serializer = klass
    end

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

    # determine default resource / pareent resource (if applicable)
    # based on the naming convention
    # e.g.: Parent::ModelController
    def set_default_resources
      name = self.name
      namespaced_names = name.split(/::|Controller/)

      model_name = namespaced_names.pop.try(:singularize)
      parent_name = namespaced_names.join('::').try(:singularize)

      if model_name.present?
        set_resource model_name.safe_constantize
      end

      unless self.resource_class
        logger.error "#{model_name} based on #{name} does not exist."
      end

      if parent_name.present?
        parent_klass = parent_name.safe_constantize
        if parent_klass
          set_resource_parent parent_klass
        else
          logger.debug "[lazy_crud] #{parent_name} could not be found as a class / module."
        end
      end
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
