require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Comments", type: :feature do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:question) { user.questions.create(title:"Build error", lesson_id: lesson.id) }

  before {
    log_in(user)
  }

  describe "#show" do

    context "by subscribing user" do
      let(:content) { 'I tried clean build but ...' }
      before { Subscription.create(user_id: user.id, lesson_id: lesson.id); }

      it "should post comment" do
        visit lesson_question_path(lesson, question)
        fill_in 'comment_content', with: content
        click_button 'コメント'
        expect(page).to have_selector 'div.chat-bubble'
        expect(page).to have_content content
      end
    end

    context "by not subscribing user" do

      it "should not see comment form" do
        visit lesson_question_path(lesson, question)
        expect(page).not_to have_selector 'form.new_comment'
      end

      context "but editor" do
        before { EditorRelationship.create(lesson_id: lesson.id, user_id: user.id) }

        it "should see comment form" do
          visit lesson_question_path(lesson, question)
          expect(page).to have_selector 'form.new_comment'
        end
      end
    end

  end

  describe "#edit" do

    let!(:someone) { FactoryGirl.create(:taro) }
    let!(:my_comment) { user.comments.create(question_id: question.id, content: "Did you try clean build?") }
    let!(:someone_comment) { someone.comments.create(question_id: question.id, content: "Yes I did but...") }
    before { Subscription.create(user_id: user.id, lesson_id: lesson.id) }

    context "by not author" do
      it "should not enabled" do
        visit lesson_question_path(lesson, question)
        within "#comment-#{someone_comment.id}" do
          expect(page).not_to have_link '編集する'
        end
      end
    end

    context "by author" do
      let(:update_comment) { "Please check you have cleaned up." }
      it "should update comment" do
        visit lesson_question_path(lesson, question)
        click_on '編集する'
        within '.chat-bubble.me.edit' do
          fill_in 'comment_content', with: update_comment
        end
        click_on '更新'
        my_comment.reload
        expect(my_comment.content).to eq update_comment
      end
    end

  end

end
