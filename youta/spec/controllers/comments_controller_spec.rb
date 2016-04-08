require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

describe CommentsController, type: :request do

  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:question) { lesson.questions.create(user_id: user.id, title: "hoge") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:my_comment) { question.comments.create( content: "foo", user_id: user.id ) }
  let!(:someone) { FactoryGirl.create(:taro) }
  let!(:someone_comment) { question.comments.create( content: "fuga", user_id: someone.id ) }

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

  describe "#edit" do

    context "by author" do
      it "should assign comment" do
        get edit_comment_path(my_comment)
        expect(assigns(:lesson)).to eq my_comment.question.lesson
        expect(assigns(:question)).to eq my_comment.question
        expect(assigns(:comment)).to eq my_comment
      end
    end

    context "by someone" do
      it "should redirect" do
        get edit_comment_path(someone_comment)
        expect(response).to redirect_to lesson_question_path(lesson, question)
      end
    end
  end

  describe "#update" do
    let(:update_comment) { "bar" }
    let(:params) { { comment: { content: update_comment } } }

    context "by author" do
      it "should update" do
        put comment_path(my_comment), params
        my_comment.reload
        expect(my_comment.content).to eq update_comment
      end
    end
    context "by someone" do
      it "should not update" do
        put comment_path(someone_comment), params
        someone_comment.reload
        expect(someone_comment.content).not_to eq update_comment
      end
    end
  end

end
