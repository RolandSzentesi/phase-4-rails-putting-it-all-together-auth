class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :recipe_params_invalid

    def index
        recipes = Recipe.all 
        if session[:user_id].nil?
            render json: { errors: ['Unable to find recipe'] }, status: :unauthorized
        else
            render json: recipes, include: :user
        end

    end

    def create
        if session.include? :user_id
            user = User.find(session[:user_id])
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
        else
            render json: { errors: ['You are not logged in'] }, status: :unauthorized
        end
        
    end


    private
    
    def recipe_params
        params.permit(:user_id, :title, :instructions, :minutes_to_complete)
    end

    def recipe_params_invalid(exception)
        render json: {errors: [exception.record.errors.full_messages]}, status: :unprocessable_entity
    end

end
