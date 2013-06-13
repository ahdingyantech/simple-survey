require 'roo'
require 'iconv'

module SimpleSurvey

  class ImportFile
    class FormatError < Exception; end

    def self.open_spreadsheet(file)
      extname = case file
      when ActionDispatch::Http::UploadedFile
        File.extname file.original_filename
      else
        File.extname file
      end

      case extname
        when '.xls' 
          Roo::Excel.new(file.path, nil, :ignore)
        when '.xlsx' 
          Roo::Excelx.new(file.path, nil, :ignore)
        else 
          raise FormatError.new "Unsupported file format #{extname}"
      end
    end
  end
end  
