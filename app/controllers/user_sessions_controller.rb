# frozen_string_literal: true

require 'uri'

class UserSessionsController < ApplicationController
  skip_authorization_check

  def new
    @redirect_to = params[:redirect_to]
    @active_admissions_exist = Admission.active_admissions?
  end

  def destroy
    session[:applicant_id] = nil
    session[:member_id]    = nil
    cookies.delete :signed_in

    flash[:success] = t('sessions.logout_success')
    redirect_to root_path
  end

protected

  def redirect_after_login(default_path)
    if params[:redirect_to] && URI.parse(params[:redirect_to]).relative?
      redirect_to params[:redirect_to]
    else
      redirect_to default_path
    end
  end
end
