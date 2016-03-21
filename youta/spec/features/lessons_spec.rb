require 'rails_helper'

feature "Lessons", :type => :feature do

  it 'visit page wit no-lesson item' do
    visit lessons_path
    expect(page).to have_content '授業一覧'
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
