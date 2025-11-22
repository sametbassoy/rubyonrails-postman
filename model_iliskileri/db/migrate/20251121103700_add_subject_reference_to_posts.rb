class AddSubjectReferenceToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :subject, foreign_key: true
  end
end
