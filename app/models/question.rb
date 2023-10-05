class Question < ApplicationRecord
    belongs_to :user
    validates :name, presence: true
    validates :description, presence: true
    def self.import(file,user)
        file = self.convert_to_utf8_encoding(file)
        CSV.foreach(file.path, headers: true) do |row|
            user.questions.create! row.to_hash rescue ""
        end
    end
    def self.convert_to_utf8_encoding(original_file)  
        original_string = original_file.read
        final_string = original_string.encode(invalid: :replace, undef: :replace, replace: '') #If you'd rather invalid characters be replaced with something else, do so here.
        final_file = Tempfile.new('import') #No need to save a real File
        final_file.write(final_string)
        final_file.close #Don't forget me
        final_file
      end
end
