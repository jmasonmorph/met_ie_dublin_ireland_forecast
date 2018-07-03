require 'time'
require 'sqlite3'
require 'yaml'
require 'httparty'

conf = YAML.load_file('config.yml')

db = SQLite3::Database.new "data.sqlite"

db.execute( "select
           day,today_forecast
           from data
           order by issued_at desc limit 1"
) do |row|

  day = row[0]
  forecast = row[1]
  
  title = "Dublin Weather for #{day}"
  body = forecast

  response = HTTParty.post('https://fcm.googleapis.com/fcm/send',
      debug_output: STDOUT,
      headers: {
        "Authorization" => "key=#{conf['server_key']}",
        "Content-Type" => "application/json"
      },
      body: {
        notification: {
          title: title,
          body: body,
        },
        to: conf['push_token']
      }.to_json)


  puts response.body, response.code, response.message, response.headers.inspect

end

