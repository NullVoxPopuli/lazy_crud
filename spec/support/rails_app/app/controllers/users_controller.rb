class UsersController < ApplicationController
  include LazyCrud

  set_resource User
  set_param_whitelist(:name)
end
