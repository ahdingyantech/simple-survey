require 'spec_helper'

describe SimpleSurvey::SurveyTemplate do
  context '获取模版' do
    before{
      @template_names = SimpleSurvey::SurveyTemplate.get_names
      id = SimpleSurvey::SurveyTemplate.all.first.id
      @survey_template = SimpleSurvey::SurveyTemplate.find(id)
    }

    it{
      @template_names.should == ['八中']
    }

    it{
      SimpleSurvey::SurveyTemplate.all.map(&:name).should == ['八中']
    }

    it{
      @survey_template.template.should =~ [
        {
          'content'  => "你觉得老师的教学质量如何？",
          'kind'    => "SINGLE_CHOICE",
          'options' => "非常好|比较满意|不满意"
        },
        {
          'content'  => "你觉得老师的优点有哪些？",
          'kind'    => "MULTIPLE_CHOICE",
          'options' => "备课充分|讲课风格吸引人|知识点讲解透彻|其他"
        },
        {
          'content'  => "你的年龄__ 你的性别 __",
          'kind'    => "FILL",
          'options' => nil
        },
        {
          'content'  => "对老师有什么建议？",
          'kind'    => "TEXT",
          'options' => nil
        }
      ]
    }

    context '创建调查表' do
      before{
        @user = User.create!(:name => 'user')
        @survey = SimpleSurvey::Survey.create!(
          :title => '测试调查表',
          :creator => @user,
          :survey_template => @survey_template
        )
        @survey = SimpleSurvey::Survey.find(@survey.id)
      }

      it{
        @survey.creator.should == @user
        @survey.survey_template.id.should == @survey_template.id
        @survey.title.should == '测试调查表'
        items = @survey.survey_template.survey_template_items
        items.count.should == 4

        items[0].content.should == "你觉得老师的教学质量如何？"
        items[0].kind.should == SimpleSurvey::SurveyTemplateItem::Kind::SINGLE_CHOICE
        items[0].options.should == %w(非常好 比较满意 不满意)

        items[1].content.should == "你觉得老师的优点有哪些？"
        items[1].kind.should == SimpleSurvey::SurveyTemplateItem::Kind::MULTIPLE_CHOICE
        items[1].options.should == %w(备课充分 讲课风格吸引人 知识点讲解透彻 其他)

        items[2].content.should == "你的年龄__ 你的性别 __"
        items[2].kind.should == SimpleSurvey::SurveyTemplateItem::Kind::FILL

        items[3].content.should == "对老师有什么建议？"
        items[3].kind.should == SimpleSurvey::SurveyTemplateItem::Kind::TEXT
      }
    end
  end
end
