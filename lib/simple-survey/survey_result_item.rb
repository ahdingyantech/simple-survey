module SimpleSurvey
  class SurveyResultItem < ActiveRecord::Base
    class Kind
      SINGLE_CHOICE = 'SINGLE_CHOICE'
      FILL = 'FILL'
      MULTIPLE_CHOICE = 'MULTIPLE_CHOICE'
      TEXT = 'TEXT'
    end
    KINDS = [ Kind::SINGLE_CHOICE, Kind::FILL, Kind::MULTIPLE_CHOICE, Kind::TEXT ]

    attr_accessible :kind, 
                    :survey_result, 
                    :item_number, 
                    :answer_choice_mask,
                    :answer_fill,
                    :answer_text,
                    :answer,
                    :other

    belongs_to :survey_result

    validates :kind, :item_number, :presence => true
    validates :kind, :inclusion => {:in => KINDS}

    validates :answer_choice_mask, :presence => {:if=> lambda {|item|
      item.is_choice?
    }}

    validates :answer_fill, :presence => {:if=> lambda {|item|
      item.is_fill?
    }}

    validates :answer_text, :presence => {:if=> lambda {|item|
      item.is_text?
    }}

    before_validation :set_answer_value
    def set_answer_value
      case self.kind
      when Kind::SINGLE_CHOICE, Kind::MULTIPLE_CHOICE
        self.answer_choice = @answer
      when Kind::TEXT
        self.answer_text = @answer
      when Kind::FILL
        self.answer_fill = @answer
      end
    end


    def is_single_choice?
      kind == Kind::SINGLE_CHOICE
    end

    def is_multiple_choice?
      kind == Kind::MULTIPLE_CHOICE
    end

    def is_choice?
      is_multiple_choice? || is_single_choice?
    end

    def is_fill?
      kind == Kind::FILL
    end

    def is_text?
      kind == Kind::TEXT
    end

    def answer=(answer_arr)
      @answer = [answer_arr].flatten*","
    end

    def answer
      case self.kind
      when Kind::SINGLE_CHOICE, Kind::MULTIPLE_CHOICE
        self.answer_choice
      when TEXT
        self.answer_text
      when FILL
        self.answer_fill
      end
    end

    def answer_choice=(choices)
      choice_arr = choices.upcase.split('')
      choice_arr.delete(',')
      value = choice_arr.map do |choice|
       2 ** ('A'..'Z').to_a.index(choice.to_s.upcase)
      end.sum
      write_attribute(:answer_choice_mask, value)
    end

    def answer_choice
      answer_choice_mask &&
      answer_choice_mask.to_s(2).chars.reverse.each_with_index.inject([]) do |acc, (num,index)|
        num == "1" ? acc + [('A'..'Z').to_a[index]] : acc
      end.compact.sort.join('')
    end

    def other=(fill)
      case self.kind
      when Kind::SINGLE_CHOICE, Kind::MULTIPLE_CHOICE
        self.answer_fill = fill
      end
    end

    def other
      self.answer_fill
    end

  end
end