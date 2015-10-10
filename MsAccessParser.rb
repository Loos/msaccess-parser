require 'csv'

class MsAccessParser

  def parse_file(filename)
    parsed_input = parse_input(filename)
    CSV.open("output.csv", "w") do |csv|
      parsed_input.each do |row|
        csv << row
       end
    end
  end

  def parse_input(filename)
    data = []
    rows = []
    current_row = []
    File.foreach(filename) {|line| data << line}
    row_delimiter = data[0]

    data.each do |line|
      if line == row_delimiter && !current_row.empty?
        rows << current_row
        current_row = []
      elsif line != row_delimiter
        current_row << line
      end
    end

    rows.map! do |row|
      row.map! do |line|
        line = line.split("|")
        line.map! do |element|
          element = element.strip unless element == ""
        end
      end
    end

    rows.map! do |row|
      row.map! do |line|
        line.map! {|elem| elem.nil? ? "" : elem}
      end
      first_line = row.shift
      row.each do |line|
        line.each_with_index do |elem, index|
          first_line[index] << "\n"
          first_line[index] << elem
        end
      end
      first_line
    end

    rows.map! do |row|
      row.map! do |elem|
        elem.strip
      end
    end
    rows
  end

end
