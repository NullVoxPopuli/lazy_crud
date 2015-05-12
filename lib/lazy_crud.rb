require 'active_support'

require 'lazy_crud/version'
require 'lazy_crud/constants'
require 'lazy_crud/before_hook_methods'
require 'lazy_crud/class_methods'
require 'lazy_crud/instance_methods'

require 'responders'
require 'responders/json_responder'

module LazyCrud
  extend ActiveSupport::Concern

  include Constants
  include BeforeHookMethods
  include InstanceMethods

  included do
    # support buth rails view layer, and js framework
    respond_to :html, :json
    # uses custom json responder
    responders :json

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

end
