require 'rails_helper'

feature "Questions", type: :feature do

  let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
  let!(:tag_tashizan) { lesson.tags.create(name: "tashizan") }
  let!(:tag_hikizan) { lesson.tags.create(name: "hikizan") }
  let!(:user) {
    user = User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar')
  }

  before {
    visit login_path
    fill_in '学生番号', with: user.student_id
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  }

  it 'visits page when no questions' do
    visit lesson_questions_path(lesson)
    expect(page).to have_content 'sansu の質問'
    expect(page).to have_content 'まだ質問が投稿されていません．'
    expect(page).to have_link '質問する'
  end

  describe "index page" do
    before {
      question = user.questions.create(title:"Build error", lesson_id: lesson.id)
      question.tag_relationships.create(tag_id: tag_tashizan.id)
    }
    it "should have question about 'Build error'" do
      visit lesson_questions_path(lesson)
      expect(page).to have_content 'Build error'
      expect(page).to have_content 'tashizan'
      expect(page).to have_content 'Kota Ishimoto さんが質問しました'
    end
  end

  describe "new page" do
    it "should create new question" do
      pending "Yet implemented create action"
      visit new_lesson_question_path(lesson)
      expect(page).to have_content "#{lesson.title} の質問の作成"
      fill_in 'タイトル', with: '5-2が分かりません'
      select 'hikizan', from: '授業項目'
      fill_in '詳細', with: '引き算ってなんですか?'
      click_button '質問する'

      expect(page).to have_content lesson.title
      expect(page).to have_content '引き算ってなんですか?'
    end
  end


end
