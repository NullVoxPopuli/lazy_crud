class DiscountsController < ApplicationController
  before_action :set_event
  include LazyCrud

  set_resource Discount
  set_resource_parent Event
  set_param_whitelist(:name, :amount)


  def set_event
    @event = Event.find(params[:event_id])
  end

end
