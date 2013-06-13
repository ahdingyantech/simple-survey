module SimpleSurvey
  class SurveyTemplate
    attr_accessor :id, :name, :template

    def initialize(attrs)
      @id = attrs[:id]
      @name = attrs[:name]
      @template = attrs[:template]
    end

    def self.get_names
      SimpleSurvey::TEMPLATES.map(&:name)
    end

    def self.all
      SimpleSurvey::TEMPLATES
    end

    def self.find(id)
      return if id.blank?
      SimpleSurvey::TEMPLATES.select do |template|
        template.id == id
      end.first
    end

    def surveys
      Survey.where(:survey_template_id => self.id)
    end

    def survey_template_items
      template.map do |item|
        SurveyTemplateItem.new(item)
      end
    end

  end
end