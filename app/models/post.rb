class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true

  belongs_to(
    :author,
    class_name: "User"
  )

  has_many :post_subs, inverse_of: :post
  has_many :subs, through: :post_subs
  has_many :comments

  def top_level_comments
    self.comments.where(parent_comment_id: nil)
  end
end
