class AddCourseReferenceToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :course, foreign_key: true
  end
end
