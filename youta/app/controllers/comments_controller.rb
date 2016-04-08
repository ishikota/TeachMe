class CommentsController < ApplicationController
  before_action :subscribing
  before_action :author_check, only: [:edit, :update]

  def create
    question = Question.find(params[:comment][:question_id])
    comment = Comment.new(comment_params)
    unless comment.save
      flash[:warning] = "コメントに何も入力されていません"
    end
    redirect_to lesson_question_path(question.lesson, question)
  end

  def edit
    @comment = Comment.find(params[:id])
    @question = @comment.question
    @lesson = @question.lesson
  end

  def update
    @comment = Comment.find(params[:id])
    @question = @comment.question
    @lesson = @question.lesson

    @comment.content = params[:comment][:content]
    if @comment.save
      flash[:success] = "コメントを更新しました"
      redirect_to lesson_question_path(@lesson, @question)
    else
      flash[:warning] = "コメントを更新できませんでした"
      render 'edit'
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :user_id, :question_id)
    end

    #before_action
    def subscribing
      question = Question.find(params[:comment][:question_id]) if params[:comment].present?
      question ||= Comment.find(params[:id]).question

      unless logged_in? && teacher_or_student_of(question.lesson)
        redirect_to root_path, notice: '受講していない授業にコメントできません'
      end
    end

    def teacher_or_student_of(lesson)
      current_user.lessons.include?(lesson) || current_user.lectures.include?(lesson)
    end

    def author_check
      comment = Comment.find(params[:id])
      question = comment.question
      unless logged_in? && comment.user == current_user
        redirect_to lesson_question_path(question.lesson, question)
      end
    end

end
