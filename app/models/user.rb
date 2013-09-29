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
	
	has_many :courses, dependent: :destroy
 	before_create :create_remember_token, :student_courses_new
  
  has_secure_password
  validates :net_id, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true
  validates :instructor, inclusion: {:in => [true, false]}

  def requestDukeAPI_people
  	require "net/http"
	require "uri"
	if self.net_id.to_s.length > 1
		url = "https://streamer.oit.duke.edu/ldap/people"
		params = {
			q: self.net_id.to_s,
			access_token: "6b1af6d392b889398917c54a7544806a"
		}
		response = Net::HTTP.get_response(URI.parse("#{url}?#{params.to_query}"))
		json_user_object = JSON.parse(response.body)
		if json_user_object.kind_of? Array
			found_user = json_user_object.find do |user|
				user["netid"].eql? self.net_id
			end
			if found_user
				self.ldapkey = found_user["ldapkey"]
				self.sn = found_user["sn"]
				self.givenName = found_user["givenName"]
				self.display_name = found_user["display_name"]
				return true
			end
		end
	end
	return false
  end

  private

  	def student_courses_new
  		if (!self.instructor)
  			array = []
  			self.student_courses = Marshal.dump(array)
  		end
  	end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
