require 'rails_helper'

feature "Questions", type: :feature do

  it 'visits page when no questions' do
    lesson = Lesson.create(title: "sansu", day_of_week: 0, period: 1)
    visit lesson_questions_path(lesson)
    expect(page).to have_content 'sansu の質問'
    expect(page).to have_content 'まだ質問が投稿されていません．'
    expect(page).to have_link '質問する'
  end

  describe "index page" do
    let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    before {
      user = User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_digest: 'foobar')
      tag = lesson.tags.create(name: "tashizan")
      question = user.questions.create(title:"Build error", lesson_id: lesson.id)
      question.tag_relationships.create(tag_id: tag.id)
    }
    it "should have question about 'Build error'" do
      visit lesson_questions_path(lesson)
      expect(page).to have_content 'Build error'
      expect(page).to have_content 'tashizan'
      expect(page).to have_content 'Kota Ishimoto さんが質問しました'
    end
  end

  describe "new page" do
    let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    let!(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_digest: 'foobar') }
    let!(:tag) { lesson.tags.create(name: "hikizan") }
    before {
      lesson.tags.create(name: "dummy")
      # should login user
    }

    it "should create new question" do
      pending "Yet implemented create action"
      visit new_lesson_question_path(lesson)
      expect(page).to have_content "#{lesson.title} の質問の作成"
      fill_in 'タイトル', with: '5-2が分かりません'
      select 'hikizan', from: '授業項目'
      fill_in '詳細', with: '引き算ってなんですか?'
      click_button '質問する'

      question = Question.find(lesson_id: lesson.id)
      expect(question.title).to eq '5-2が分かりません'
      expect(question.tags).to include tag
      #expect(question.user).to eq user
      #expect(question.comments.first).to eq user.comments.first
    end
  end


end
