# frozen_string_literal: true

require 'click_house'

ClickHouse.config do |config|
  config.logger = Logger.new(STDOUT)
  config.adapter = :net_http
  config.database = 'entain'
  config.url = 'http://localhost:8123'
end

$columns = ['timestamp','ip','user','amount','type']

def insert(log_data)
  ClickHouse.connection.insert('events', columns: ['timestamp','ip','user_id','amount','type'], values: log_data)
end


File.open('logs', 'r') do |f|
  arr = []
  f.each_line.with_index do |line, i|
    log_data = {}
    line.scan(/\[(?<timestamp>.*?)\] \[(?<ip>.*?)\]|\b(?<key>\w+)=(?:"(?<quoted_value>[^"]+)"|(?<value>\S+))/) do |timestamp, ip, key, quoted_value, value|
      if timestamp
        log_data['timestamp'] = timestamp
        log_data['ip'] = ip
      elsif key
        log_data[key] = quoted_value || value
      end
    end
    arr << log_data.fetch_values('timestamp','ip','user','amount','type')
    if i % 5000 == 0
      puts i
      insert(arr)
      arr = []
    end
  end
  insert(arr)
end
