class PagesController < ApplicationController
  before_filter :authenticate_user!

  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
end
