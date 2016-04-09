require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Questions", type: :feature do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }

  before { log_in(user) }

  describe "when no question is posted" do
    it 'should display empty message' do
      visit lesson_questions_path(lesson)
      expect(page).to have_content 'hoge の質問'
      expect(page).to have_content 'まだ質問が投稿されていません．'
      expect(page).to have_link '質問する'
    end
  end

  describe "index page" do
    let!(:question1) { user.questions.create(title:"Build error", lesson_id: lesson.id) }
    let!(:tag_tashizan) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
    let!(:tag_hikizan) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }
    before { question1.tag_relationships.create(tag_id: tag_tashizan.id) }

    describe "page content" do

      it "should have question about 'Build error'" do
        visit lesson_questions_path(lesson)
        expect(page).to have_content 'Build error'
        expect(page).to have_content '足し算'
        expect(page).to have_content 'Kota Ishimoto さんが質問しました'
        expect(page).to have_content '未解決'
        expect(page).to have_link nil, href: lesson_question_path(lesson, question1)
      end
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
    let!(:tag_tashizan) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
    let!(:tag_hikizan) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }
    before { visit new_lesson_question_path(lesson) }

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
    let(:comment) { "Dis you try clean build?" }
    before {
      user.comments.create(question_id: question.id, content: comment)
      visit lesson_question_path(lesson, question)
    }

    it "should have content about question" do
      expect(page).to have_content question.title
      expect(page).to have_content question.user.name
    end

    it "should display comment on question" do
      expect(page).to have_content comment
    end

    describe "click solved button" do
      before {
        Subscription.create(user_id: user.id, lesson_id: lesson.id);
        visit current_path  # reload screen
      }

      context "when question is not solved" do
        it "should close question" do
          click_button "解決済みにする"
          expect(page).to have_content "解決済み"
          expect(page).to have_content "#{user.name} さんがこの質問を 解決済み としました"
        end
      end

      context "when question is solved" do
        before {
          question.toggle(:solved).save
          visit current_path
        }

        it "should re-open question" do
          click_button "未解決に戻す"
          expect(page).to have_content "未解決"
          expect(page).to have_content "#{user.name} さんがこの質問を 未解決 に戻しました"
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
