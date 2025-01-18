class CreateCoursesStudentsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :courses, :students do |t|
      t.index :course_id
      t.index :student_id
    end
  end
end
