require 'simple_xlsx_reader'
require 'time'
require 'csv'


def open_xlsx(file_name)
  workbook = SimpleXlsxReader.open file_name

  report = workbook.sheets.find(name: 'report').first

  matrix = []

  max_length = 0

  report.rows.each { |x| x.length > max_length ? max_length = x.length : nil}

  rows = report.rows.map{ |x| x.length < max_length ? x + Array.new(max_length - x.length) : x }

  rows[3..-1].each do |row|
    row = row.map{ |x| x.to_s.gsub("\nEntrada", "") }
    row = row.map{ |x| x.to_s.gsub("\nInício de inter.", "") }
    row = row.map{ |x| x.to_s.gsub("\nVolta de inter.", "") }
    row = row.map{ |x| x.to_s.gsub("\nSaída", "") }
    matrix << [row[0]] + row[2...-4].map{ |x| Time.parse(x) rescue x }
  end

  matrix
end

def sanitizer(matrix)
  new_matrix = []

  matrix.each do |row|
    data_row = row[0..1]
    for i in 2...row.length do
      if row[i-1].is_a?(String) || row[i].is_a?(String) || row[i-1] <= row[i]
        if !row[i-1].is_a?(String) || row[i-1] != ""
          data_row << row[i]
        else
          data_row << ""
        end
      else
        data_row << ""
      end
    end
    new_matrix << data_row
  end

  new_matrix
end

def formatter_matrix_to_csv(matrix)
  matrix.map { |x| x.map{ |a| a.strftime("%H:%M") rescue a } }
end

def generate_csv(matrix, file_name)
  File.write(file_name, formatter_matrix_to_csv(matrix).map(&:to_csv).join)
end

Dir.glob('data/*').select{ |e| File.file? e }.each do |file_name|
  p file_name.sub('xlsx', 'csv').sub('data', 'data_csv')
  generate_csv(
    sanitizer(open_xlsx(file_name)),
    file_name.sub('xlsx', 'csv').sub('data', 'data_csv')
  )
end
