require 'rails_helper'

feature "Lessons", :type => :feature do

  it 'visit page wit no-lesson item' do
    visit lessons_path
    expect(page).to have_content '授業一覧'
  end
end
