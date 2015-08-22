class User < ActiveRecord::Base
  after_initialize :ensure_session_token

  attr_reader :password

  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true}

  has_many(
    :subs,
    class_name: "Sub",
    foreign_key: :moderator_id
  )

  has_many(
    :posts,
    class_name: "Post",
    foreign_key: :author_id
  )

  has_many(
    :comments,
    class_name: "Comment",
    foreign_key: :author_id
  )

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    user.try(:is_password?, password) ? user : nil
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    save!
    session_token
  end

  def password=(password)
    if password.present?
      @password = password
      self.password_digest = BCrypt::Password.create(password)
    end
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def to_s
    self.username.to_s
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
