SELECT
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue
FROM
  events


