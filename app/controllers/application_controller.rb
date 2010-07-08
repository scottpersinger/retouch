# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "photo"

class ApplicationController < ActionController::Base
  filter_parameter_logging :password, :password_confirmation

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user

  def home

  end

  def products
    unless request.post?
    #  redirect_to :action => 'home'
    #  return
    end

    @email = params[:email]
    @file = params[:image]

    if @email && @file
      file_name = File.basename(@file.original_filename)
      # File data in @image.read (File object)

      customer = Customer.find_by_email(@email) || Customer.create(:email => @email)
      @photo = Photo.create(:customer => customer, :file_name => file_name)
      @photo.store_file(@file, 'image/jpeg', file_name)
    else
      @email = "scooter@test.com"
      @photo = MockPhoto.new
    end
  end

  def purchase
    customer = Customer.find_by_email(params[:email])
    photo = customer.photos.find_by_id(params[:photo_id])
    if photo
      photo.comments = params[:comments]
      photo.product = params[:product]
      photo.style = params[:style]
      photo.save!
    end
  end

  def feedback
    if request.post?
      if !params[:email].blank?
        # spam
        redirect_to 'http://bitbucket.org'
        return
      end

      logger.info "Feedback from (#{params[:gopher]}): #{params[:message]}"
      Notifier.deliver_feedback(params[:gopher], params[:message])

      @thankyou = "Thank you for your feedback!"
    end
  end
  
 private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end
