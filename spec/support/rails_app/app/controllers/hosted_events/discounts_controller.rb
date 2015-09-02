class HostedEvents::DiscountsController < ApplicationController
  before_action :set_event
  include LazyCrud

  set_resource_parent Event
  set_param_whitelist(:name, :amount)


  def set_event
    @event = Event.find(params[:hosted_event_id])
  end

end
