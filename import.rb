# frozen_string_literal: true

require 'pg'
db_params = {
  host: 'localhost',
  port: '5433',
  dbname: 'entain', # replace with your actual database name
  user: 'antonmurygin'
}

begin
  $conn = PG.connect(db_params)

  def insert(log_data)
    $conn.exec_params(
      "INSERT INTO events (timestamp, ip, user_id, amount, type) VALUES ($1, $2, $3, $4, $5)",
      [log_data['timestamp'], log_data['ip'], log_data['user'], log_data['amount'], log_data['type']]
    )
  rescue PG::Error => e
    puts "An error occurred: #{e.message}"
  end


  File.open('data', 'r') do |f|
    f.each_line do |line|
      log_data = {}
      puts line
      line.scan(/\[(?<timestamp>.*?)\] \[(?<ip>.*?)\]|\b(?<key>\w+)=(?:"(?<quoted_value>[^"]+)"|(?<value>\S+))/) do |timestamp, ip, key, quoted_value, value|
        if timestamp
          log_data['timestamp'] = timestamp
          log_data['ip'] = ip
        elsif key
          log_data[key] = quoted_value || value
        end
      end
      insert(log_data)
    end
  end

ensure
  $conn.close if $conn
end
