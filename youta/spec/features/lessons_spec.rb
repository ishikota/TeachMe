require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Lessons", :type => :feature do

  def attach_students_file
    attach_file '受講者', "#{Rails.root}/spec/fixtures/lecture_students.csv"
  end

  let!(:user) { FactoryGirl.create(:taro) }
  before "login" do
    log_in(user)
  end


  describe 'index page' do
    context "when lesson exists" do
      let!(:sansu) { FactoryGirl.create(:sansu) }
      let!(:kokugo) { FactoryGirl.create(:kokugo) }
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

    describe 'creates new lesson' do
      before {
        visit new_lesson_path
        select '火曜', from: "曜日"
        select '3限', from: "時間"
        fill_in '授業名', with: '情報理工学演習'
        fill_in '授業内容(タグ)', with: 'ファイルの読み書き,サーバクライアント通信'
        attach_students_file
        click_button '作成する'
      }
      specify "new lesson is created" do
        expect(page).to have_selector 'li', count:1
        expect(Tag.count).to eq 2
        expect(User.count).to eq 4
        expect(EditorRelationship.count).to eq 1
      end
    end
  end

  describe "edit sansu lesson" do
    let!(:lesson) { FactoryGirl.create(:sansu) }
    let!(:tashizan) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
    let!(:hikizan) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }
    before { visit edit_lesson_path(lesson) }

    it "should display sansu lesson data on form by default" do
      day_of_week = Lesson.day_of_week_to_str(lesson.day_of_week)
      period = Lesson.period_to_str(lesson.period)
      tag = [tashizan.name, hikizan.name].join(',')

      expect(page).to have_select '曜日', selected: day_of_week
      expect(page).to have_select '時間', selected: period
      expect(page).to have_field '授業名', with: lesson.title
      expect(page).to have_field '授業内容(タグ)', with: tag
      expect(page).to have_field '受講者の追加'
      expect(page).to have_link '受講者一覧', href: students_lesson_path(lesson)
    end

    describe "append new user to lesson" do
      before { attach_students_file }
      it "should create new subscription relationships" do
        expect { click_button '更新する' }.to change { lesson.students.count }.from(0).to(3)
      end
      describe "when user already registered" do
        before {
          click_button '更新する'
          attach_students_file
        }
        it "should not create duplicate subscriptions" do
          expect { click_button '更新する' }.not_to change { lesson.students.count }
        end
      end
    end

  end

  describe "#students" do
    let!(:user1) { FactoryGirl.create(:kota) }
    let!(:user2) { FactoryGirl.create(:ishimoto) }
    let(:lesson) { Lesson.create(FactoryGirl.attributes_for(:lesson)) }
    before {
      Subscription.create(user_id: user1.id, lesson_id: lesson.id)
      Subscription.create(user_id: user2.id, lesson_id: lesson.id)
      visit students_lesson_path(lesson)
    }
    it "should display students who subscribes the lesson" do
      expect(page).to have_selector 'li', count: 2
    end
  end

  describe "authentication" do
    before {
      visit root_path
      click_link "ログアウト"
    }
    context "on index page" do
      it "should require login and friendly forward" do
        visit lessons_path
        log_in(user, visit=false)
        expect(current_url).to eq lessons_url
      end
    end
  end


end
