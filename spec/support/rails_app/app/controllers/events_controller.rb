class EventsController < ApplicationController
  include LazyCrud

  set_resource Event
  set_param_whitelist(:name)

  before_create ->(resource){ resource.name = resource.name.upcase }
  before_create ->(resource){}

  before_update ->(resource){ resource.user_id = -1 }
  before_destroy ->(resource){ resource.created_at = nil }

  def before_create
    @resource.name = @resource.name + " " + @resource.name
  end


end
