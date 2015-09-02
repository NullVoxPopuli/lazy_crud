class Event::DiscountsController < ApplicationController
  include LazyCrud

  set_param_whitelist(:name, :amount)


end
