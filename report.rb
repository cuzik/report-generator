require 'csv'
require 'time'
require 'active_support'
require 'active_support/core_ext'
require 'tempus'


def open_csv(file_name)
  CSV.read(file_name)
end

def calculate(file_name)
  matrix = open_csv(file_name)

  total_hours = Tempus.new(0)

  max_length = 0

  matrix.each { |x| x.length > max_length ? max_length = x.length : nil}

  matrix = [matrix[0] + ["Total"]] + matrix[1..-1].map do |row|
    row_n = row.select{ |i| i != "" }
    sum_hours = Tempus.new(0)
    for i in 1..((row_n.length) / 2) do
      sum_hours += Tempus.new(Time.parse(row_n[i * 2])) - Tempus.new(Time.parse(row_n[i * 2 - 1]))
    end

    total_hours += sum_hours

    row + Array.new(max_length - row.length) + [sum_hours.to_s("%H:%M")]
  end

  p "#{file_name.sub('data_csv/', '').sub('_', ' ').sub('.csv', '').capitalize}: normais: #{total_hours.to_s("%H:%M")}"

  matrix
end

def generate_csv(matrix, file_name)
  File.write(file_name, matrix.map(&:to_csv).join)
end

Dir.glob('data_csv/*').select{ |e| File.file? e }.each do |file_name|
  generate_csv(
    calculate(file_name),
    file_name.sub('data_csv', 'report_csv')
  )
end
