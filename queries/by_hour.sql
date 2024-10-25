SELECT
  toHour(timestamp) AS hour,
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue
FROM
  events
GROUP BY
  hour
ORDER BY
  hour ASC


      ┌─hour─┬─net_revenue─┐
 1. │    0 │     8088.35 │
 2. │    1 │    18056.54 │
 3. │    2 │    15127.55 │
 4. │    3 │    -38061.6 │
 5. │    4 │    45637.27 │
 6. │    5 │    -7746.27 │
 7. │    6 │    17438.13 │
 8. │    7 │    29810.16 │
 9. │    8 │    -9790.12 │
10. │    9 │    -10573.1 │
11. │   10 │    13947.74 │
12. │   11 │    42456.79 │
13. │   12 │    -5548.19 │
14. │   13 │     10045.3 │
15. │   14 │    26750.37 │
16. │   15 │    -30955.3 │
17. │   16 │   -31862.01 │
18. │   17 │   -14408.53 │
19. │   18 │   -83186.02 │
20. │   19 │    10213.16 │
21. │   20 │    12834.68 │
22. │   21 │   -22015.71 │
23. │   22 │   -45042.51 │
24. │   23 │   -40586.63 │
    └──────┴─────────────┘


select sparkbar(24)(hour, net_revenue) from (SELECT
  toHour(timestamp) AS hour,
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue
FROM
  events
GROUP BY
  hour
ORDER BY
  hour ASC )


-- number of bets
SELECT
  toHour(timestamp) AS hour,
  SUM(multiIf(type = 'bet', 1, 0)) AS bets
FROM
  events
GROUP BY
  hour
ORDER BY
  hour ASC

-- amount of bets
SELECT
  toHour(timestamp) AS hour,
  SUM(multiIf(type = 'bet', amount, 0)) AS bet_value
FROM
  events
GROUP BY
  hour
ORDER BY
  hour ASC

    ┌─hour─┬────bet_value─┐
 1. │    0 │   3972495.36 │
 2. │    1 │    4039412.7 │
 3. │    2 │   4085925.38 │
 4. │    3 │   3965997.72 │
 5. │    4 │   4397850.97 │
 6. │    5 │   4287977.98 │
 7. │    6 │   4389071.74 │
 8. │    7 │   4471776.52 │
 9. │    8 │   4573452.41 │
10. │    9 │   4664483.44 │
11. │   10 │   4810930.68 │
12. │   11 │   4968067.83 │
13. │   12 │   5094265.64 │
14. │   13 │   5293903.11 │
15. │   14 │   5514903.26 │
16. │   15 │    5763438.4 │
17. │   16 │   6083705.14 │
18. │   17 │   6494514.94 │
19. │   18 │   7030860.03 │
20. │   19 │   7877816.44 │
21. │   20 │   9127642.26 │
22. │   21 │  11331621.52 │
23. │   22 │  16724658.34 │
24. │   23 │ 113460115.22 │
    └──────┴──────────────┘


SELECT
  toHour(timestamp) AS hour,
  SUM(multiIf(type = 'bet', amount, 0)) AS bet_value
FROM
  events
WHERE
  timestamp < '2016-11-30 00:00:00'
GROUP BY
  hour
ORDER BY
  hour ASC

SELECT
  toHour(timestamp) AS hour_of_day,
  AVG(amount) AS avg_bet_amount
FROM
  events
WHERE
  type = 'bet' -- Filter for only 'bet' events
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;



SELECT
  toStartOfDay(timestamp) AS day,
  SUM(multiIf(type = 'bet', amount, 0)) - SUM(multiIf(type = 'win', amount, 0)) AS net_revenue
FROM
  events
GROUP BY
  day
ORDER BY
  day;

SELECT
  toStartOfDay(timestamp) AS day,
  COUNT(*) AS total_events
FROM
  events
WHERE
  type = 'bet' -- Filter for only 'bet' events
GROUP BY
  day
ORDER BY
  day;
