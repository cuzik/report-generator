require 'csv'
require 'time'
require 'active_support'
require 'active_support/core_ext'
require 'tempus'



def open_csv(file_name)
  CSV.read(file_name)
end

def check(file_name)
  p ">>>>>>>>>>>>>>>>>>>>>>>>>#{file_name.sub('data_csv/', '').sub('_', ' ').sub('.csv', '').capitalize}<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

  matrix = open_csv(file_name)

  matrix[1..-1].each do |row|
    for i in 2...(row.length - 1) do
      if (Tempus.new(Time.parse(row[i])) - Tempus.new(Time.parse(row[i-1]))).value_in_minutes < 15
        p "#{row[0]}: Tempo muito curto entre pontos"
      end
    end
    if row.length.even?
      p "#{row[0]}: Número de batidas não é PAR"
    end
  end
end







Dir.glob('data_csv/*').select{ |e| File.file? e }.each do |file_name|
    check(file_name)
end
