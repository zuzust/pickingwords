class StaticPagesController < ApplicationController
  skip_authorization_check
  
  caches_action :home, :help, :about, :contact, layout: false, expires_in: 24.hours

  def home
  end

  def help
  end

  def about
  end
  
  def contact
  end

  def playground
  end
end
