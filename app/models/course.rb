        
=begin
    t.integer   :crse_id
    t.string    :subject
    t.integer   :catalog_nbr
    t.string    :institution
    t.string    :acad_career
    t.string    :course_title_long
    t.integer   :class_nbr
    t.string    :ssr_component
    t.string    :ssr_mtg_sched_long
    t.string    :ssr_instr_long
    t.string    :ssr_mtg_dt_long
    t.string    :ssr_mtg_loc_long
=end


class Course < ActiveRecord::Base

	belongs_to :user
	has_many :office_hours, dependent: :destroy

    validates :crse_id, uniqueness: true

    def requestDukeAPI_courses
        require "net/http"
        require "uri"
        if self.crse_id.to_s.length > 1
            url = "https://streamer.oit.duke.edu/curriculum/classes/strm/1460%20-%202013%20Fall%20Term/"
            query = "crse_id/"
            crse_id = self.crse_id.to_s
            token_string = "?access_token="
            access_token = "6b1af6d392b889398917c54a7544806a"
            uri = URI.parse(url + query + crse_id + token_string + access_token)
            response = Net::HTTP.get_response(uri)
            json_user_object = JSON.parse(response.body)
            puts JSON.pretty_generate(json_user_object)
            if !json_user_object.nil? && json_user_object.length == 1 && JSONQuery(json_user_object, "error_warn_text").nil?
                JSONQuery(json_user_object, "error_warn_text")
                self.subject = JSONQuery(json_user_object, "subject")
                self.catalog_nbr = JSONQuery(json_user_object, "catalog_nbr")
                self.institution = JSONQuery(json_user_object, "institution")
                self.acad_career = JSONQuery(json_user_object, "acad_career")
                self.course_title_long = JSONQuery(json_user_object, "course_title_long")
                self.class_nbr = JSONQuery(json_user_object, "class_nbr")
                self.ssr_component = JSONQuery(json_user_object, "ssr_component")
                self.ssr_mtg_sched_long = JSONQuery(json_user_object, "ssr_mtg_sched_long")
                self.ssr_instr_long = JSONQuery(json_user_object, "ssr_instr_long")
                self.ssr_mtg_dt_long = JSONQuery(json_user_object, "ssr_mtg_dt_long")
                self.ssr_mtg_loc_long = JSONQuery(json_user_object, "ssr_mtg_loc_long")
                puts self.subject
                puts self.catalog_nbr
                puts self.institution
                puts self.acad_career
                puts self.course_title_long
                puts self.class_nbr
                puts self.ssr_component
                puts self.ssr_mtg_sched_long 
                puts self.ssr_instr_long
                puts self.ssr_mtg_dt_long
                puts self.ssr_mtg_loc_long
                return true

            end
        end
        return false
    end

    def JSONQuery(obj,key)
        if obj.respond_to?(:key?) && obj.key?(key) && obj[key].is_a?(String)
            obj[key]
        elsif obj.respond_to?(:each)
            r = nil
            obj.find{ |*a| r = JSONQuery(a.last,key) }
            r
        end
    end
end
