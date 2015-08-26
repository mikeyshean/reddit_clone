class Comment < ActiveRecord::Base
  validates :content, :author_id, :post_id, presence: true

  belongs_to :post
  belongs_to(
    :author,
    class_name: "User"
  )

  belongs_to(
    :parent_comment,
    class_name: "Comment"
  )

  has_many(
    :child_comments,
    class_name: "Comment",
    foreign_key: :parent_comment_id
  )

  has_many :votes, as: :votable

end
