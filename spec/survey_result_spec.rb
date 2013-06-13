require 'spec_helper'

describe SimpleSurvey::SurveyResult do
  before{
    xls_file_path = File.expand_path('../data/template.xls', __FILE__)
    xls_file = File.new(xls_file_path,'r')
    @survey_template = SimpleSurvey::SurveyTemplate.create!(:file => xls_file)
    @user = User.create!(:name => 'user')
    @survey = @survey_template.surveys.create!(
      :title => '测试调查表',
      :creator => @user
    )
  }

  
end