class CommentsController < ApplicationController
  def create
    question = Question.find(params[:comment][:question_id])
    comment = Comment.new(comment_params)
    if comment.save
      #TODO success message in flash
    else
      #TODO failure message in flash
    end
    redirect_to lesson_question_path(question.lesson, question)
  end
  
  private
    def comment_params
      params.require(:comment).permit(:content, :user_id, :question_id)
    end
end
