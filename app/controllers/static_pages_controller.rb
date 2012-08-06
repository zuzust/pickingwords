class StaticPagesController < ApplicationController
  skip_authorization_check
  
  caches_action :home, :help, :about, :contact, layout: false

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
