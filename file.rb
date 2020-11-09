require 'csv'

class FileCSV
  def initialize(csv_name)
    @csv_name = csv_name
  end

  CSV_HEADER = %w[
    Name
    Price
    Image
  ].freeze

  def write_to_csv(row)
    if csv_exists?
      puts 'write to file'
      CSV.open(@csv_name, 'a+') do |csv|
        row.each { |product| csv << product }
      end
    else
      CSV.open(@csv_name, 'wb') do |csv|
        puts 'create file and write to it'
        csv << CSV_HEADER
        row.each { |product| csv << product }
      end
    end
  end

  private

  def csv_exists?
    @exists ||= File.file?(@csv_name)
  end
end
