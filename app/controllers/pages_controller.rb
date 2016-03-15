class PagesController < ApplicationController
  layout 'frontend'
  skip_before_action :authenticate_user!
end
