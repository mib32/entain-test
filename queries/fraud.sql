SELECT
  user_id,
  COUNT(*) AS bet_count,
  MIN(timestamp) AS first_bet,
  MAX(timestamp) AS last_bet,
  dateDiff('second', MIN(timestamp), MAX(timestamp)) AS duration_seconds
FROM
  events
WHERE
  type = 'bet'
GROUP BY
  user_id -- HAVING
  -- bet_count > 10
  -- AND duration_seconds < 60 -- More than 10 bets in less than a minute
ORDER BY
  bet_count DESC;

select
  *
from
  events
where
  user_id = 44
order by
  timestamp;

SELECT
  AVG(bets_per_day) AS avg_bet_frequency_per_day
FROM
  (
    SELECT
      toDate(timestamp) AS bet_date,
      COUNT(*) AS bets_per_day
    FROM
      events
    WHERE
      user_id = 44
      AND type = 'bet'
    GROUP BY
      bet_date
  )
SELECT
  AVG(bets_per_day) AS avg_bet_frequency_per_day
FROM
  (
    SELECT
      toStartOfHour(timestamp) AS bet_hour,
      COUNT(*) AS bets_per_hour
    FROM
      events
    WHERE
      user_id = 44
      AND type = 'bet'
    GROUP BY
      bet_hour
  )

  -- by minute

SELECT
  DISTINCT user_id
FROM
  (
    SELECT
      user_id,
      toStartOfMinute(timestamp) AS bet_minute,
      COUNT(*) AS bets_per_minute
    FROM
      events
    WHERE
      type = 'bet'
    GROUP BY
      user_id,
      bet_minute
    HAVING
      bets_per_minute > 60
  )

-- by ip

SELECT
  user_id,
  COUNT(DISTINCT ip) AS unique_ip_count
FROM
  events
GROUP BY
  user_id
ORDER BY
  unique_ip_count DESC;



  SELECT
  ip,
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue,
  count(*),
  COUNTIf(type = 'bet') AS bet_count
FROM
  events
GROUP BY
  ip
ORDER BY
  net_revenue DESC



  SELECT
  ip,
  (
    SUM(multiIf(type = 'win', amount, 0)) - SUM(multiIf(type = 'bet', amount, 0))
  ) / COUNTIf(type = 'bet') AS avg_win_per_bet
FROM
  events
GROUP BY
  ip
HAVING
  COUNTIf(type = 'bet') > 0
ORDER BY
  avg_win_per_bet DESC;


  SELECT
  user_id,
  (COUNTIf(type = 'win') / COUNT(*)) * 100 AS win_percentage
FROM
  events
GROUP BY
  user_id
ORDER BY
  win_percentage DESC;


  SELECT
  user_id,
  ip,
  (
    SUM(multiIf(type = 'win', amount, 0)) - SUM(multiIf(type = 'bet', amount, 0))
  ) / COUNTIf(type = 'bet') AS avg_win_per_bet
FROM
  events
GROUP BY
  user_id, ip
HAVING
  COUNTIf(type = 'bet') > 0
  and user_id = 24
ORDER BY
  avg_win_per_bet DESC;
