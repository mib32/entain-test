
require 'prophet-rb'
# require 'matplotlib/pyplot'
require 'click_house'

ClickHouse.config do |config|
  config.logger = Logger.new(STDOUT)
  config.adapter = :net_http
  config.database = 'entain'
  config.url = 'http://localhost:8123'
end

puts ClickHouse.connection.ping

user_ids = ClickHouse.connection.select_all("SELECT DISTINCT user_id FROM events ORDER BY user_id").to_a.map { _1['user_id']}

final_table = {}

user_ids.each do |user_id|
  data = ClickHouse.connection.select_all("""SELECT toDate(toStartOfDay(timestamp)) AS ds,
    SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS y
    FROM events
    WHERE user_id = #{user_id}
    GROUP BY ds
    ORDER BY ds""")

  m = Prophet.new
  m.add_seasonality(name: "monthly", period: 30.5, fourier_order: 5)
  m.add_country_holidays("LV")
  df = Rover::DataFrame.new(data.to_a)
  # puts df.head
  m.fit(df)
  future = m.make_future_dataframe(periods: 31, include_history: false)
  # puts future.inspect
  forecast = m.predict(future)
  # pp df.to_a
  # pp forecast[["ds", "yhat"]].to_a
  sum_net_profit = forecast["yhat"].sum
  puts "user_id: #{user_id}, profit: #{sum_net_profit}"
  final_table[user_id] = sum_net_profit
end
puts final_table

max_profit_user = final_table.max_by {|k,v| v}
puts "Maximum profit user in december: #{max_profit_user}"
