module LazyCrud
  module InstanceMethods

    def index
      respond_with(set_collection_instance, collection_options)
    end

    def show
      # instance variable set in before_action
      respond_with(get_resource_instance, options)
    end

    def new
      set_resource_instance(resource_proxy.new)
      respond_with(get_resource_instance, options)
    end

    def edit
      # instance variable set in before_action
    end

    def create
      @resource = resource_proxy.send(build_method, resource_params)

      # ensure we can still use model name-based instance variables
      # such as @discount, or @event
      set_resource_instance

      run_before_create_hooks

      flash[:notice] = "#{resource_name} has been created." if @resource.save
      respond_with(@resource, options)
    end

    def update
      run_before_update_hooks

      @resource.update(resource_params)
      respond_with(@resource, options)
    end

    def destroy
      run_before_destroy_hooks
      @resource.destroy

      respond_with(@resource, options)
    end

    # only works if deleting of resources occurs by setting
    # the deleted_at field
    def undestroy
      @resource = resource_proxy(true).find(params[:id])
      set_resource_instance

      @resource.deleted_at = nil
      @resource.save

      respond_with(@resource, options)
    end

    private

    def options
      default = { location: { action: :index } }
      return default.merge({ serializer: serializer }) if serializer
      default
    end

    def collection_options
      return { each_serializer: serializer } if serializer
      {}
    end

    def resource_name
      @resource.try(:name) || @resource.class.name
    end

    def set_resource
      @resource = resource_proxy.find(params[:id])
    end

    # use .try() on the params hash, in case the user forgot to provide
    # the attributes
    def resource_params
      params[resource_singular_name].try(:permit, self.class.param_whitelist)
    end

    # determines if we want to use the parent class if available or
    # if we just use the resource class
    def resource_proxy(with_deleted = false)
      proxy = if parent_instance.present?
        parent_instance.send(resource_plural_name)
      else
        self.class.resource_class
      end

      if with_deleted and proxy.respond_to?(:with_deleted)
        proxy = proxy.with_deleted
      end

      proxy
    end

    # if the resource_proxy has a parent, we can use the
    # build method. Otherwise, resource_proxy, is just the
    # resource's class - in which case we'll use new
    def build_method
      resource_proxy.respond_to?(:build) ? :build : :new
    end

    # allows all of our views to still use things like
    # @level, @event, @whatever
    # rather than just @resource
    def set_resource_instance(resource = @resource)
      instance_variable_set("@#{resource_singular_name}", resource)
    end

    def get_resource_instance
      instance_variable_get("@#{resource_singular_name}")
    end

    # sets the plural instance variable for a collection of objects
    def set_collection_instance
      instance_variable_set("@#{resource_plural_name}", resource_proxy)
    end

    def parent_instance
      if (not @parent) and self.class.parent_class.present?
        # e.g.: Event => 'event'
        parent_instance_name = self.class.parent_class.name.underscore
        @parent = instance_variable_get("@#{parent_instance_name}")
      end

      @parent
    end

    # e.g.: Event => 'events'
    def resource_plural_name
      @association_name ||= self.class.resource_class.name.tableize
    end

    # e.g.: Event => 'event'
    # alternatively, @resource.class.name.underscore
    def resource_singular_name
      @singular_name ||= resource_plural_name.singularize
    end
  end
end
