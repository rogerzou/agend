=begin

t.string :net_id
t.string :ldapkey
t.string :display_name
t.string :givenName
t.string :sn
t.string :password_digest
t.string :remember_token
t.boolean :instructor, default: false

t.timestamps

=end

class User < ActiveRecord::Base
	
	has_many :courses
  before_save :create_remember_token
  
  has_secure_password
  validates :net_id, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true
  validates :instructor, presence: true

  def authenticate_duke
  	require "net/http"
		require "uri"

		url = "https://streamer.oit.duke.edu/ldap/people"
		query = "?q="
		net_id = self.net_id
		token_string = "&access_token="
		access_token = "6b1af6d392b889398917c54a7544806a"

		uri = URI.parse(url + query + net_id + token_string + access_token)
		response = Net::HTTP.get_response(uri)
		json_user_object = JSON.parse(response.body)
		if json_user_object.length == 1
			self.ldapkey = json_user_object[0]["ldapkey"]
			self.sn = json_user_object[0]["sn"]
			self.givenName = json_user_object[0]["givenName"]
			self.display_name = json_user_object[0]["display_name"]
			return true;
		end
		return false;
  end

  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end