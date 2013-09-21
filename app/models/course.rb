        
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
    t.string  :ssr_mtg_loc_long
=end


class Course < ActiveRecord::Base

	belongs_to :user
	has_many :office_hours, dependent: :destroy

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
            if !json_user_object.nil? && json_user_object.length == 1
                json_subject = json_user_object["ssr_get_classes_resp"]["search_result"]["subjects"]["subject"]
                self.subject = json_subject["subject_lov_descr"];
                self.catalog_nbr = json_subject["catalog_nbr"]
                self.institution = json_subject["institution_lov_descr"]
                self.acad_career = json_subject["acad_career_lov_descr"]
                self.course_title_long = json_subject["course_title_long"]
                json_class = json_subject["classes_summary"]["class_summary"]
                self.class_nbr = json_class["class_nbr"]
                self.ssr_component = json_class["ssr_component"]
                json_sched = json_class["classes_meeting_patterns"]["class_meeting_pattern"]
                self.ssr_mtg_sched_long = json_sched["ssr_mtg_sched_long"]
                self.ssr_instr_long = json_sched["ssr_instr_long"]
                self.ssr_mtg_dt_long = json_sched["ssr_mtg_dt_long"]
                self.ssr_mtg_loc_long = json_sched["ssr_mtg_loc_long"]
                return true
            end
        end
        return false
    end

end
