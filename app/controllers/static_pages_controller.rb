class StaticPagesController < ApplicationController
  skip_authorization_check
  
  caches_action :home, :help, :about, layout: false, expires_in: 24.hours

  def home
  end

  def help
  end

  def about
  end
  
  def contact
    @cf = ContactForm.new(params[:cf] || {})

    if request.post? and @cf.valid?
      Notifier.contacted(@cf).deliver
      @cf.clear

      flash.now[:notice] = "Your message has been successfully delivered and will be considered"
    end
  end

  # TODO Remove playground action
  def playground
  end
end
