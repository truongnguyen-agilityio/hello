class User < ActiveRecord::Base
	# attr_accessor :remember_token
	attr_accessor :email, :password, :password_confirmation

	before_create { self.email = email.downcase }
	before_create { generate_token(:auth_token) }
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: true}, :on => :create
	validates :password, presence: true, length: { minimum: 6 }, :on => :create

	has_secure_password

	# # Returns the hash digest of the given string.
 #  def User.digest(string)
 #    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
 #    BCrypt::Password.create(string, cost: cost)
 #  end

	# def User.new_token
	# 	SecureRandom.urlsafe_base64
	# end

	# # Remembers a user in the database for use in persistent sessions.
 #  def remember
 #    self.remember_token = User.new_token
 #    update_attribute(:remember_digest, User.digest(remember_token))
 #  end

	# def authenticated? (remember_token)
	# 	BCrypt::Password.new(remember_digest).is_password?(remember_token)
	# end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

end