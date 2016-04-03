class CommentsController < ApplicationController
  before_action :subscribing
  def create
    question = Question.find(params[:comment][:question_id])
    comment = Comment.new(comment_params)
    unless comment.save
      flash[:warning] = "コメントに何も入力されていません"
    end
    redirect_to lesson_question_path(question.lesson, question)
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :user_id, :question_id)
    end

    #before_action
    def subscribing
      question = Question.find(params[:comment][:question_id])
      unless logged_in? && teacher_or_student_of(question.lesson)
        redirect_to root_path, notice: '受講していない授業にコメントできません'
      end
    end

    def teacher_or_student_of(lesson)
      current_user.lessons.include?(lesson) || current_user.lectures.include?(lesson)
    end

end
