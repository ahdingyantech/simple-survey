require 'simple-survey/survey_template'
require 'simple-survey/survey_template_item'
require 'simple-survey/survey'
require 'simple-survey/survey_result'
require 'simple-survey/survey_result_item'
require 'simple-survey/import_file'
require 'yaml'

module SimpleSurvey
  if defined?(Rails)
    TEMPLATE_PATH = Rails.root.join('config/survey_templates')
  else
    TEMPLATE_PATH = File.expand_path('../../survey_templates', __FILE__)
  end

  TEMPLATES = Dir["#{TEMPLATE_PATH}/*.yaml"].map do |yaml_path|
    hash = YAML.load_file(yaml_path)
    SurveyTemplate.new(
      :id => hash['id'],
      :name => hash['name'],
      :template => hash['template']
    )
  end
end
