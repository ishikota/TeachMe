require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

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
      log_in(user)
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
      visit edit_lesson_path(lesson)
    }
    it "should display sansu lesson data on form by default" do
      expect(page).to have_select '曜日', selected: '火曜'
      expect(page).to have_select '時間', selected: '2限'
      expect(page).to have_field '授業名', with: '算数'
      expect(page).to have_field '授業内容(タグ)', with: '足し算,引き算'
      expect(page).to have_field '受講者の追加'
      expect(page).to have_link '受講者一覧', href: students_lesson_path(lesson)
    end

    describe "append new user to lesson" do
      it "should create new subscription relationships" do
        attach_file '受講者の追加', "#{Rails.root}/spec/fixtures/lecture_students.csv"
        expect { click_button '更新する' }.to change { lesson.students.count }.from(0).to(3)
      end
      it "should not create duplicate subscriptions" do
        attach_file '受講者の追加', "#{Rails.root}/spec/fixtures/lecture_students.csv"
        expect { click_button '更新する' }.to change { lesson.students.count }.from(0).to(3)
        attach_file '受講者の追加', "#{Rails.root}/spec/fixtures/lecture_students.csv"
        expect { click_button '更新する' }.not_to change { lesson.students.count }
      end
    end
  end

  describe "#students" do
    let(:params) { { name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar' } }
    let!(:user1) { User.create(params.merge( name: "kota", student_id: "A1178086")) }
    let!(:user2) { User.create(params.merge( name: "ishi", student_id: "B1578048")) }
    let(:lesson) { Lesson.create(title: "算数", day_of_week: 1, period: 2) }
    before {
      Subscription.create(user_id: user1.id, lesson_id: lesson.id)
      Subscription.create(user_id: user2.id, lesson_id: lesson.id)
      visit students_lesson_path(lesson)
    }
    it "should display students who subscribes the lesson" do
      expect(page).to have_selector 'li', count: 2
    end
  end


end
