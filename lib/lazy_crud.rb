require 'active_support'

require 'lazy_crud/version'

module LazyCrud
  extend ActiveSupport::Concern

  included do
    class_attribute :resource_class
    class_attribute :parent_class
    class_attribute :param_whitelist

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
    @resource = resource_proxy.build(resource_params)

    # ensure we can still use model name-based instance variables
    set_resource_instance

    if @resource.save
      flash[:notice] = "#{resource_name} has been created."
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    if @resource.update(resource_params)
      redirect_to action: :index
    else
      redirect_to action: :edit
    end
  end

  def destroy
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

  def resource_params
    params[resource_singular_name].permit(self.class.param_whitelist)
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
    unless @parent
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
