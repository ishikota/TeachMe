require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ImportHelper. For example:
#
# describe ImportHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ImportHelper do
  
  describe "Read student data from csv" do
    describe "should convert csv file to student_ids array" do
      let(:file_name) { "lecture_students.csv" }
      let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
      let(:result) { %w"A1178086 A1178087 A1178088" }
      it { expect(helper.read_student_from_csv(file_path)).to eq result }
    end

    let(:student_ids) { %w"A1178086 A1178087 A1178088" }
    let(:password) { "foobar" }
    it "should convert student_ids to User object array" do
      students = helper.import_students(student_ids, password)
      expect(User.count).to eq student_ids.size
      students.each_with_index { |student, idx|
        expect(student.student_id).to eq student_ids[idx].downcase
      }
    end

    describe "convert csv data to User object array" do
      let(:file_name) { "lecture_students.csv" }
      let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
      let(:password) { 'foobar' }
      let(:result) { %w"A1178086 A1178087 A1178088" }
      let(:students) { helper.read_csv_student_id(file_path, password) }
      specify "students have expected student_ids" do
        students.each_with_index { |student, idx|
          expect(student.student_id).to eq result[idx].downcase
        }
      end
    end
  end

end
