class SessionsController < ApplicationController

    def create
        user = User.find_by(username: params[:username])

        if user.nil?
            render json: { errors: ['Invalid username'] }, status: :unauthorized
        elsif user.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { errors: ['Incorrect password'] }, status: :unauthorized
        end
    end

    def destroy 
        if session[:user_id].nil?
            render json: { errors: ['No user is currently logged in'] }, status: :unauthorized
          else
            session.delete :user_id
            head :no_content
          end
    end
    


end
