
SELECT
  user_id,
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue,
  count(*)
FROM
  events
GROUP BY
  user_id
ORDER BY
  net_revenue DESC

SELECT
  user_id,
  SUM(multiIf(type = 'bet', amount, 0)) as bet_amount
FROM
  events
GROUP BY
  user_id
ORDER BY
  bet_amount DESC

-- And Date
SELECT
  user_id,
  toStartOfDay(timestamp) AS day,
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue,
  AVG()
  count(*)
FROM
  events
WHERE
  user_id = 129
GROUP BY
  user_id, day
ORDER BY
  day
