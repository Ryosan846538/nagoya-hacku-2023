require 'sqlite3'
require 'json'

db = SQLite3::Database.new('../db/development.sqlite3')

results = db.execute('SELECT * FROM missions')

data = []

results.each do |row|
  item_hash = {
    id: row[0],
    title: row[1],
    progress: row[2]
  }
  data << item_hash
  puts "ID: #{row[0]}, Title #{row[1]}, Progress #{row[2]} \n"
  #puts row

  result2 = db.execute("SELECT * FROM sub_missions WHERE mission_id = #{row[0]}")
  result2.each do |rol|
    #puts result2
    puts "SubID: #{rol[0]}, refID: #{rol[1]}, content #{rol[2]} \n"
  end
end

#json dataで書き出し
json_data = data.to_json
file_path = "output.json"
File.open(file_path, 'w') do |file|
  file.write(json_data)
end

# (db access) mission = Mission.all
# mission.each do |row|
# (access db data)
# row.id          Mission ID
# row.title       Mission's Title
# row.progress    Mission Progress
# row.created_at  Time of Mission's created
# row.updated_at  Time of Mission's updated
# end

# .allで取得する場合
# json_data = mission.to_json
# File.open('file_path', 'w') do |file|
#   file.write(json_data)
# end

## json file ..
