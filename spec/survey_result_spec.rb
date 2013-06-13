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

  context '提交一个空调查表结果' do
    it{
      @survey.survey_results.build.save.should == false
    }
  end

  context '提交一个调查表结果' do
    before{
      @user_1 = User.create!(:name => 'user_1')

      @survey_result = @survey.survey_results.build

      survey_result_items_attributes = [
        {
          :kind        => SimpleSurvey::SurveyResultItem::Kind::SINGLE_CHOICE,
          :item_number => '1',
          :answer      => ['A']
        },
        {
          :kind        => SimpleSurvey::SurveyResultItem::Kind::MULTIPLE_CHOICE,
          :item_number => '2',
          :answer      => ['A', 'B', 'D'],
          :other       => '和善'
        },
        {
          :kind        => SimpleSurvey::SurveyResultItem::Kind::FILL,
          :item_number => '3',
          :answer      => ['25', '男']
        },
        {
          :kind        => SimpleSurvey::SurveyResultItem::Kind::TEXT,
          :item_number => '4',
          :answer      => '狂帅拽酷叼炸天'
        }
      ]

      @survey_result.survey_result_items_attributes = survey_result_items_attributes
      @survey_result.user = @user_1
      @survey_result.save!
      @survey_result = SimpleSurvey::SurveyResult.find(@survey_result.id)
    }

    it{
      @survey_result.survey_result_items.count.should == 4
    }

    it '单选' do
      item_1 = @survey_result.survey_result_items.first
      item_1.kind.should == SimpleSurvey::SurveyResultItem::Kind::SINGLE_CHOICE
      item_1.answer_choice_mask.should == 1
      item_1.answer_choice.should == 'A'
    end

    it '多选' do
      item_2 = @survey_result.survey_result_items[1]
      item_2.kind.should == SimpleSurvey::SurveyResultItem::Kind::MULTIPLE_CHOICE
      item_2.answer_choice_mask.should == 11
      item_2.answer_choice.should == 'ABD'
      item_2.other.should == '和善'
    end

    it '填空' do
      item_3 = @survey_result.survey_result_items[2]
      item_3.kind.should == SimpleSurvey::SurveyResultItem::Kind::FILL
      item_3.answer_fill.should == '25,男'
    end

    it '问答' do
      item_4 = @survey_result.survey_result_items[3]
      item_4.kind.should == SimpleSurvey::SurveyResultItem::Kind::TEXT
      item_4.answer_text.should == '狂帅拽酷叼炸天' 
    end
  end
end