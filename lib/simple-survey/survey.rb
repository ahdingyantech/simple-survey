module SimpleSurvey
  class Survey < ActiveRecord::Base
    attr_accessible :title, :survey_template, :creator

    belongs_to :survey_template
    belongs_to :creator, :class_name => 'User'

    validates :title, :survey_template, :creator, :presence => true

    has_many :survey_results
  end
end