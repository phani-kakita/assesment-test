class Api::V1::QuestionsController < ApplicationController
  require 'csv'
    before_action :authorize_request
    before_action :find_question,only: [:show,:update,:destroy]
   
  
    # GET /questions
    def index
  
      @questions = @current_user.questions
      render json: @questions, status: :ok
    end
  
    # GET /questions/{username}
    def show
      render json: @question, status: :ok
    end
  
    # POST /questions
    def create
    
      @question = @current_user.questions.create(question_params)
      if @question.save
        render json: @question, status: :created
      else
        render json: { errors: @question.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  
    # PUT /questions/{username}
    def update

      # @question = @question.update(question_params)
      if @question.update(question_params)
        render json: @question, status: 200
      else
        render json: { errors: @question.errors.full_messages },
               status: :unprocessable_entity
      end


      unless @question.update(question_params)
        render json: { errors: @question.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  
    # DELETE /questions/{username}
    def destroy
     
      if @question.destroy
      render json: { message: "Question deleted." },
               status: 200
             else
       render json: { errors: @question.errors.full_messages },
               status: :unprocessable_entity
             end
    end

    def import
 
    file = Tempfile.new(permit_params[:file][:tempfile]) rescue permit_params[:file]
    Question.import(file,@current_user)
   @questions = @current_user.questions
   render json: @questions, status: :ok
    end
  
    private

    def find_question
      @question = @current_user.questions.where(id:params[:id]).first
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Question not found' }, status: :not_found
    end

  
    def question_params
      params.permit(
        :name,:description
      )
    end
    private 

    def permit_params
      params.permit!
    end
  end

# end
