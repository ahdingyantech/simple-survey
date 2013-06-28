module SimpleSurvey
  class SurveyResult < ActiveRecord::Base
    attr_accessible :survey, :user, :survey_result_items_attributes

    validates :survey, :user, :presence => true

    belongs_to :survey
    belongs_to :user

    has_many :survey_result_items, :dependent => :destroy

    accepts_nested_attributes_for :survey_result_items

    validate :check_survey_result_items
    def check_survey_result_items
      count = self.survey_result_items.map(&:item_number).uniq.count
      must_count = self.survey.survey_template.template.count

      have_blank = self.survey_result_items.map(&:answer).select{|answer|answer.blank?}.count > 0
      if count != must_count || have_blank
        errors.add(:survey_result_items, "没有填写完整")
      end
    end

  end
end