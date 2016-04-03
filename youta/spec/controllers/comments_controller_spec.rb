require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

describe CommentsController, type: :request do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:question) { lesson.questions.create(user_id: user.id, title: "hoge") }
  before {
    log_in(user)
    Subscription.create(user_id: user.id, lesson_id: lesson.id)
  }
  
  describe "#create" do
    let!(:params) { { comment: { content: "wao", user_id: user.id, question_id: question.id } } }
    it "should post new comment and redirect to questions page" do
      post comments_path, params
      expect(Comment.find_by_content("wao")).to be_present
      expect(response).to redirect_to lesson_question_path(lesson, question)
    end
    describe "validation" do
      context "post by not subscribing student" do
        before {
          Subscription.find_by_user_id_and_lesson_id(user.id, lesson.id).destroy
        }
        it "should not post comment on not subscribing lesson" do
          post comments_path, params
          expect(Comment.find_by_content("wao")).to be_nil
        end
        context "but editor of the lesson" do
          before {
            EditorRelationship.create(user_id: user.id, lesson_id: lesson.id)
          }
          it "should post new comment" do
            post comments_path, params
            expect(Comment.find_by_content("wao")).to be_present
          end
        end
      end
    end
  end
end
