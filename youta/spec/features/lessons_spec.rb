require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Lessons", :type => :feature do

  let!(:user) { FactoryGirl.create(:taro) }
  let!(:admin) { FactoryGirl.create(:admin) }

  describe 'index page' do
    before { log_in(user) }
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
    before { log_in(admin) }
    describe 'creates new lesson' do
      before {
        visit new_lesson_path
      }
      specify "new lesson is created" do
        select '火曜', from: "曜日"
        select '3限', from: "時間"
        fill_in '授業名', with: '情報理工学演習'
        click_button '作成する'

        expect(page).to have_selector 'li.lesson-row', count:1
        expect(EditorRelationship.count).to eq 1
      end
    end
  end

  describe "edit sansu lesson" do
    before { log_in(admin) }
    let!(:lesson) { FactoryGirl.create(:sansu) }
    let!(:tag) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
    let!(:student) { lesson.students.create(FactoryGirl.attributes_for(:kota)) }
    before { visit edit_lesson_path(lesson) }

    it "should have link to edit tag and students" do
      expect(page).to have_link '編集する', href: lesson_students_path(lesson)
      expect(page).to have_link '編集する', href: lesson_tags_path(lesson)
      expect(page).to have_content tag.name
      expect(page).to have_content '1人'
    end

    it "should edit sansu to sugaku" do
      select '金曜', from: "曜日"
      select '5限', from: "時間"
      fill_in '授業名', with: '数学'
      click_button '更新する'

      expect(page).to have_select '曜日', selected: '金曜'
      expect(page).to have_select '時間', selected: '5限'
      expect(page).to have_field '授業名', with: '数学'
    end

  end

  describe "authentication" do
    it { require_login_and_friendly_forward user, lessons_url }

    describe "not admin user try to access" do
      before { log_in(user) }
      let!(:lecture) { user.lectures.create(FactoryGirl.attributes_for(:lesson)) }
      it { require_admin_and_redirect new_lesson_url }
      it { require_admin_and_redirect edit_lesson_url(lecture) }
    end
  end

end
