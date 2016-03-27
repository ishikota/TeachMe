require 'rails_helper'

describe CommentsController, type: :request do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:question) { lesson.questions.create(user_id: user.id, title: "hoge") }
  
  describe "#create" do
    it "should post new comment and redirect to questions page" do
      params = { comment: { content: "wao", user_id: user.id, question_id: question.id } }
      post comments_path, params
      expect(Comment.find_by_content("wao")).to be_present
      expect(response).to redirect_to lesson_question_path(lesson, question)
    end
  end
end
