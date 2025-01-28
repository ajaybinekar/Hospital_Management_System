class CsvImportDepartmentService
  require "csv"

  def call(file)
    opened_file = File.open(file)
    CSV.foreach(opened_file, headers: true) do |row|
    debugger
      user_hash = {}
      user_hash[:name] = row["name"]
      Department.find_or_create_by!(user_hash)
    end
  end
end
