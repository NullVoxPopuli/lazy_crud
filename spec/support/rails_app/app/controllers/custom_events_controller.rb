class CustomEventsController < ApplicationController
  include LazyCrud
  respond_to :json
  set_resource Event
  set_serializer CustomSerializer

end
