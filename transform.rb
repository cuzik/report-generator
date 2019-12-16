require 'csv'

def open_csv(file_name)
  CSV.read(file_name)
end

def calculate(file_name)
  matrix = open_csv(file_name)

  text = "user = User.find()\n"

  matrix[1..-1].map do |row|
    for i in 1..(row.length) do
      if row[i] != nil
        date = "#{row[0][4..-1]}/2019 #{row[i]}"
        text += "user.punches.create(date:'#{date}')\n"
      end
    end
  end

  text
end

def generate_file(text, file_name)
  File.write(file_name, text)
end

Dir.glob('data_csv/*').select{ |e| File.file? e }.each do |file_name|
  generate_file(
    calculate(file_name),
    file_name.sub('data_csv', 'seed').sub('csv', 'rb')
  )
end
