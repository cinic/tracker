# Class Admin/Authentication.rb
module Admin::Authentication
  extend ActiveSupport::Concern

  included do
    attr_accessor :password

    validates_presence_of :name
    validates :email,
              presence: true,
              format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
              uniqueness: { case_sensitive: false }

    # Users can edit their account without providing a password
    validates_presence_of :password, on: :create

    before_save :prepare_password, :downcase_email
    before_create { generate_token(:remember_token) }
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def reset_remember_token
    generate_token(:remember_token)
  end

  def reset_remember_token_and_save
    reset_remember_token
    save!(:validate => false)
  end

  def track_on_login(request)
    self.last_login_at = Time.zone.now
    self.last_login_ip = request.remote_ip
    self.login_count += 1
    save!(validate: false)
  end

  def track_on_logout
    self.last_logout_at = Time.zone.now
    save!(validate: false)
  end

  def logout(cookies)
    track_on_logout
    reset_remember_token_and_save
    cookies.delete(:remember_token)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  def downcase_email
    email.downcase! if email.present?
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Admin::Admin.exists?(column => self[column])
  end

  module ClassMethods
    def authenticate(email, pass)
      admin = where('email = ?', email.downcase).first
      return admin if admin && admin.password_hash == admin.encrypt_password(pass)
    end
  end
end