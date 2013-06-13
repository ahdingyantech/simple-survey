module SimpleSurvey
  class SurveyTemplate < ActiveRecord::Base
    attr_accessible :file, :template

    validates :template, :presence => true

    has_many :surveys

    def file=(file)
      spreadsheet = ImportFile.open_spreadsheet(file)
      arr = []
      (2..spreadsheet.last_row).each do |row_num|
        row = spreadsheet.row(row_num)
        arr << {
          'content' => row[0],
          'kind'    => row[1],
          'options' => row[2]
        }
      end

      self.template = arr
    end

    def template
      ActiveSupport::JSON.decode(read_attribute(:template))
    end

    def template=(template)
      json = template.is_a?(String) ? template : template.to_json
      write_attribute(:template, json)
    end
  end
end