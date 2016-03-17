require 'spec_helper'

describe Comment do
  
  let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true) }
  let(:comment) { user.comments.build(content: "Teach Me !!") }

  it { expect(comment.user.id).to eq user.id }

  describe "validation" do
    describe "when content is empty" do
      before { comment.content = "" }
      it { expect(comment).not_to be_valid }
    end
    describe "when user_id is not present" do
      before { comment.user_id = nil }
      it { expect(comment).not_to be_valid }
    end
  end

end
