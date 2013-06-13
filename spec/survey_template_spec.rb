require 'spec_helper'

describe SimpleSurvey::SurveyTemplate do
  context '导入 xls xlsx' do
    before{
      xls_file_path = File.expand_path('../data/template.xls', __FILE__)
      xls_file = File.new(xls_file_path,'r')
      @survey_template = SimpleSurvey::SurveyTemplate.create!(:file => xls_file)

      xlsx_file_path = File.expand_path('../data/template.xlsx', __FILE__)
      xlsx_file = File.new(xlsx_file_path,'r')
      @survey_template_2 = SimpleSurvey::SurveyTemplate.create!(:file => xlsx_file)      
    
      @survey_template = SimpleSurvey::SurveyTemplate.find(@survey_template.id)
      @survey_template_2 = SimpleSurvey::SurveyTemplate.find(@survey_template_2.id)
    }

    it{
      @survey_template_2.template.should == @survey_template.template
    }

    it{
      @survey_template.template.should =~ [
        {
          'content'  => "你觉得老师的教学质量如何？",
          'kind'    => "单选",
          'options' => "非常好|比较满意|不满意"
        },
        {
          'content'  => "你觉得老师的优点有哪些？",
          'kind'    => "多选",
          'options' => "备课充分|讲课风格吸引人|知识点讲解透彻|其他"
        },
        {
          'content'  => "你的年龄__ 你的性别 __",
          'kind'    => "填空",
          'options' => nil
        },
        {
          'content'  => "对老师有什么建议？",
          'kind'    => "问答",
          'options' => nil
        }
      ]
    }

    context '创建调查表' do
      before{
        @user = User.create!(:name => 'user')
        @survey = @survey_template.surveys.create!(
          :title => '测试调查表',
          :creator => @user
        )
      }

      it{
        @survey.creator.should == @user
        @survey.survey_template.should == @survey_template
        @survey.title.should == '测试调查表'
      }
    end
  end
end
