require 'rails_helper'

feature "Lessons", :type => :feature do

  it 'visit page wit no-lesson item' do
    visit lessons_path
    expect(page).to have_content '授業一覧'
  end

  describe 'index page' do
    context "when lesson exists" do
      before {
        Lesson.create(title: "算数", day_of_week: 0, period: 1)
        Lesson.create(title: "国語", day_of_week: 1, period: 2)
      }
      it "should display all lessons" do
        visit lessons_path
        expect(page).to have_content '算数'
        expect(page).to have_content '月曜'
        expect(page).to have_content '1限'
        expect(page).to have_content '国語'
        expect(page).to have_content '火曜'
        expect(page).to have_content '2限'
      end
    end
    context "when no lesson is found" do
      it "should display empty message" do
        visit lessons_path
        expect(page).to have_content '授業は登録されていません.'
      end
    end

  end

  it 'creates new class' do
    visit lessons_new_path
    expect(page).to have_content '授業を作成する'
    select '火曜', from: "曜日"
    select '3限', from: "時間"
    fill_in '授業名', with: '情報理工学演習'
    fill_in '授業内容(タグ)', with: 'ファイルの読み書き,サーバクライアント通信'
    attach_file '受講者', "#{Rails.root}/spec/fixtures/lecture_students.csv"
    click_button '作成する'

    expect(Lesson.count).to eq 1
    expect(Tag.count).to eq 2
    expect(User.count).to eq 3
  end
end
