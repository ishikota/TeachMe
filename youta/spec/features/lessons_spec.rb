require 'rails_helper'

feature "Lessons", :type => :feature do

  it 'visit page wit no-lesson item' do
    visit lessons_path
    expect(page).to have_content '授業一覧'
  end

  describe 'index page' do
    context "when lesson exists" do
      let!(:sansu) { Lesson.create(title: "算数", day_of_week: 0, period: 1) }
      let!(:kokugo) { Lesson.create(title: "国語", day_of_week: 1, period: 2) }
      it "should display all lessons" do
        visit lessons_path
        expect(page).to have_content '算数'
        expect(page).to have_content '月曜'
        expect(page).to have_content '1限'
        expect(page).to have_content '国語'
        expect(page).to have_content '火曜'
        expect(page).to have_content '2限'
        expect(page).to have_link nil, href: lesson_questions_path(sansu)
        expect(page).to have_link nil, href: lesson_questions_path(kokugo)
      end
    end
    context "when no lesson is found" do
      it "should display empty message" do
        visit lessons_path
        expect(page).to have_content '授業は登録されていません.'
      end
    end

  end

  describe "#new" do
    let!(:user) {
      User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar')
    }
    before {
      visit login_path
      fill_in '学生番号', with: user.student_id
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit new_lesson_path
    }

    describe 'creates new lesson' do
      before {
        expect(page).to have_content '授業を作成する'
        select '火曜', from: "曜日"
        select '3限', from: "時間"
        fill_in '授業名', with: '情報理工学演習'
        fill_in '授業内容(タグ)', with: 'ファイルの読み書き,サーバクライアント通信'
        attach_file '受講者', "#{Rails.root}/spec/fixtures/lecture_students.csv"
        click_button '作成する'
      }
      specify "new lesson is created" do
        expect(page).to have_selector 'li', count:1
        expect(Tag.count).to eq 2
        expect(User.count).to eq 3
        expect(EditorRelationship.count).to eq 1
      end
    end
  end

  describe "edit sansu lesson" do
    let(:lesson) { Lesson.create(title: "算数", day_of_week: 1, period: 2) }
    before {
      lesson.tags.create(name: "足し算")
      lesson.tags.create(name: "引き算")
    }
    it "should display sansu lesson data on form by default" do
      visit edit_lesson_path(lesson)
      expect(page).to have_select '曜日', selected: '火曜'
      expect(page).to have_select '時間', selected: '2限'
      expect(page).to have_field '授業名', with: '算数'
      expect(page).to have_field '授業内容(タグ)', with: '足し算,引き算'
      expect(page).not_to have_field '受講者'
    end
  end
end
