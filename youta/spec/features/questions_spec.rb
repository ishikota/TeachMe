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

end
