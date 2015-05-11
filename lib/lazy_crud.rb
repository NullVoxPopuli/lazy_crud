require 'active_support'

require 'lazy_crud/version'

module LazyCrud
  extend ActiveSupport::Concern

  ACTIONS_WITH_HOOKS = [:create, :update, :destroy]

  included do
    class_attribute :resource_class
    class_attribute :parent_class
    class_attribute :param_whitelist

    # crud hooks
    class_attribute :before_create_hooks
    class_attribute :before_update_hooks
    class_attribute :before_destroy_hooks
    # setting instance variables for actions and views
    before_action :set_resource, only: [:show, :edit, :update, :destroy]
    before_action :set_resource_instance, only: [:show, :edit, :update, :destroy]
  end

  module ClassMethods

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

  def index
    set_collection_instance
  end

  def show
    # instance variable set in before_action
  end

  def new
    set_resource_instance(resource_proxy.new)
  end

  def edit
    # instance variable set in before_action
  end

  def create
    @resource = resource_proxy.send(build_method, resource_params)

    # ensure we can still use model name-based instance variables
    set_resource_instance

    run_before_create_hooks
    if @resource.save
      flash[:notice] = "#{resource_name} has been created."
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    run_before_update_hooks
    if @resource.update(resource_params)
      redirect_to action: :index
    else
      redirect_to action: :edit
    end
  end

  def destroy
    run_before_destroy_hooks
    @resource.destroy

    flash[:notice] = "#{resource_name} has been deleted."
    redirect_to action: :index
  end

  # only works if deleting of resources occurs by setting
  # the deleted_at field
  def undestroy
    @resource = resource_proxy(true).find(params[:id])
    set_resource_instance

    @resource.deleted_at = nil
    @resource.save

    flash[:notice] = "#{resource_name} has been undeleted"
    redirect_to action: :index
  end

  private

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
