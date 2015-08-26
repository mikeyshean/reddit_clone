class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true

  belongs_to(
    :author,
    class_name: "User"
  )

  has_many :post_subs, inverse_of: :post
  has_many :subs, through: :post_subs
  has_many :comments
  has_many :votes, as: :votable

  def top_level_comments
    self.comments.where(parent_comment_id: nil)
  end

  def comments_by_parent_id
    result = Hash.new { |h,k| h[k] = [] }

    self.comments.includes(:author).each do |comment|
      result[comment.parent_comment_id] << comment
    end

    result
  end
end
