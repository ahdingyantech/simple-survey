module SimpleSurvey
  class Survey < ActiveRecord::Base
    attr_accessible :title, :survey_template_id, :survey_template, :creator

    belongs_to :creator, :class_name => 'User'

    validates :title, :creator, :presence => true

    has_many :survey_results
    
    def survey_template=(survey_template)
      @survey_template = survey_template
      survey_template_id = survey_template.id
    end

    def survey_template
      @survey_template ||= (
        SurveyTemplate.find(survey_template_id)
      )
    end
  end

end