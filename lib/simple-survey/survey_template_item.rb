module SimpleSurvey
  class SurveyTemplateItem
    class Kind
      SINGLE_CHOICE = 'SINGLE_CHOICE'
      FILL = 'FILL'
      MULTIPLE_CHOICE = 'MULTIPLE_CHOICE'
      TEXT = 'TEXT'
    end

    attr_accessor :content, :kind, :options
    def initialize(attrs)
      @content = attrs['content'] || attrs[:content]
      @kind = attrs['kind'] || attrs[:kind]
      @options = (attrs['options'] || attrs[:options] || '').split('|')
    end
    
  end
end