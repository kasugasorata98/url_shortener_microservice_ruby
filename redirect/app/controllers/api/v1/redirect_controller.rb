class Api::V1::RedirectController < ApplicationController
  def redirect
    redirect_mapping = RedirectMapping.find_by(short_id: params[:shortId])

    if redirect_mapping.nil? || redirect_mapping.target_url.nil?
      render json: { error: 'Short ID not found' }, status: :not_found
    else
      redirect_to redirect_mapping.target_url, allow_other_host: true
    end
  end
end
