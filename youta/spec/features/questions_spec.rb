require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Questions", type: :feature do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:tag_tashizan) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
  let!(:tag_hikizan) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }

  before { log_in(user) }

  it 'visits page when no questions' do
    visit lesson_questions_path(lesson)
    expect(page).to have_content 'hoge の質問'
    expect(page).to have_content 'まだ質問が投稿されていません．'
    expect(page).to have_link '質問する'
  end

  describe "index page" do
    let!(:question1) { user.questions.create(title:"Build error", lesson_id: lesson.id) }
    before { question1.tag_relationships.create(tag_id: tag_tashizan.id) }
    it "should have question about 'Build error'" do
      visit lesson_questions_path(lesson)
      expect(page).to have_content 'Build error'
      expect(page).to have_content '足し算'
      expect(page).to have_content 'Kota Ishimoto さんが質問しました'
      expect(page).to have_link nil, href: lesson_question_path(lesson, question1)
    end

    describe "tag fileter" do
      let!(:question2) { user.questions.create(title:"NPE", lesson_id: lesson.id) }
      before { question2.tag_relationships.create(tag_id: tag_hikizan.id) }
      context "when filter is off" do
        it "should display all questions" do
          visit lesson_questions_path(lesson)
          expect(page).to have_selector 'li.question-row', count: 2
          expect(page).to have_selector '.current-tag', text: "全ての質問"
          within 'ul.dropdown-menu' do
            expect(page).to have_link tag_tashizan.name, href: lesson_questions_path(lesson, tag: tag_tashizan.name)
            expect(page).to have_link tag_hikizan.name, href: lesson_questions_path(lesson, tag: tag_hikizan.name)
          end
        end
      end
      context "when filter is on" do
        before { visit lesson_questions_path(lesson, tag: tag_hikizan.name) }
        it "should filter question to display" do
          expect(page).to have_selector 'li.question-row', count: 1
          expect(page).to have_selector "#question-#{question2.id}"
          expect(page).to have_selector '.current-tag', text: tag_hikizan.name
        end
        it "should not set html paramter when all-tag is clicked" do
          # BUT  : /lessons/:id/questions?tag=all-tag
          # GOOD : /lessons/:id/questions
          click_link '全ての質問'
          expect(current_url).to eq lesson_questions_url(lesson)
        end
      end
    end
  end

  describe "new page" do
    before {
      visit new_lesson_question_path(lesson)
      expect(page).to have_content "#{lesson.title} の質問の作成"
    }
    it "should create new question" do
      fill_in 'タイトル', with: '5-2が分かりません'
      select '引き算', from: '授業項目'
      fill_in '詳細', with: '引き算ってなんですか?'
      click_button '質問する'

      expect(page).to have_content lesson.title
      expect(page).to have_content '引き算ってなんですか?'
    end
  end

  describe "#show" do
    let!(:question) { user.questions.create(title:"Build error", lesson_id: lesson.id) }
    let!(:comment) { user.comments.create(question_id: question.id, content: "Did you try clean build?") }
    before { visit lesson_question_path(lesson, question) }

    it "should have content about question" do
      expect(page).to have_content question.title
      expect(page).to have_content question.user.name
    end

    it "should display comment on question" do
      expect(page).to have_selector 'div.chat-bubble', count:1
    end

    describe "#comment" do
      context "subscribing user" do
        let(:content) { 'I tried clean build but ...' }
        before {
          Subscription.create(user_id: user.id, lesson_id: lesson.id);
          visit current_path  # reload screen
        }
        it "should post comment" do
          fill_in 'comment_content', with: content
          click_button 'コメント'
          expect(page).to have_selector 'div.chat-bubble', count:2
          expect(page).to have_content content
        end
      end
      context "not subscribing user" do
        it "should not see comment form" do
          expect(page).not_to have_selector 'form.new_comment'
        end
        context "but editor" do
          before {
            EditorRelationship.create(lesson_id: lesson.id, user_id: user.id)
            visit current_path
          }
          it "should see comment form" do
            expect(page).to have_selector 'form.new_comment'
          end
        end
      end
    end
  end

  describe "authentication" do
    before {
      visit root_path
      click_link "ログアウト"
    }

    it { require_login_and_friendly_forward user, lesson_questions_url(lesson) }
    it { require_login_and_friendly_forward user, new_lesson_question_url(lesson)}
  end

end
