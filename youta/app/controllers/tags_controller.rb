class TagsController < ApplicationController
  before_action :signed_in_user
  before_action :editor_check

  def index
    @lesson = Lesson.find(params[:lesson_id])
    @tags = @lesson.tags
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @tags = @lesson.tags

    tag_strs = params[:tags].split(',').map{ |tag| tag.strip }
    tag_strs.each { |tag|
      @lesson.tags.create(name: tag)
    }
    redirect_to lesson_tags_path(@lesson)
  end

  def destroy
    @lesson = Lesson.find(params[:lesson_id])
    @tags = @lesson.tags

    tag = Tag.find(params[:id])
    if tag.lesson == @lesson
      tag.destroy
      flash[:success] = "タグ「#{tag.name}」を削除しました."
      redirect_to lesson_tags_path(@lesson)
    else
      flash[:danger] = "不正な操作です"  # try to delete the tag not attched to @lesson
      redirect_to root_path
    end
  end

  private
    def editor_check
      @lesson = Lesson.find(params[:lesson_id])
      unless @lesson.editors.include?(current_user)
        flash[:warning] = "あなたはこの授業の編集権限を持っていません"
        redirect_to root_path
      end
    end
end
