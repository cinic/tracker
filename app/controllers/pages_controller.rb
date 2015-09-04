class PagesController < ApplicationController
  layout 'general'

  skip_before_action :authenticate_user!

end