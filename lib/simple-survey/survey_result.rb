module SimpleSurvey
  class SurveyResult < ActiveRecord::Base
    attr_accessible :survey, :user, :survey_result_items_attributes

    validates :survey, :user, :presence => true
    validates  :survey_id,  :uniqueness => {:scope => :user_id}

    belongs_to :survey
    belongs_to :user

    has_many :survey_result_items

    accepts_nested_attributes_for :survey_result_items

    validate :check_survey_result_items
    def check_survey_result_items
      count = self.survey_result_items.map(&:item_number).uniq.count
      must_count = self.survey.survey_template.template.count
      if count != must_count
        errors.add(:survey_result_items, "请填写完整")
      end
    end

  end
end