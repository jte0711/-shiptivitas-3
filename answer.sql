-- TYPE YOUR SQL QUERY BELOW

-- PART 1: Create a SQL query that maps out the daily average users before and after the feature change
SELECT 
  COUNT(DISTINCT user_id) as users_count,
  strftime('%Y-%m-%d', login_timestamp, 'unixepoch') as ymd_date
FROM login_history
GROUP BY ymd_date;

-- Select login history before feature change with unique user per day
CREATE VIEW before_change
AS
SELECT 
  COUNT(DISTINCT user_id) as users_count,
  strftime('%Y-%m-%d', login_timestamp, 'unixepoch') as ymd_date
FROM login_history
WHERE login_timestamp < strftime('%s', '2018-06-02')
GROUP BY ymd_date;


-- Select login history after feature change with unique user per day
CREATE VIEW after_change
AS
SELECT 
  COUNT(DISTINCT user_id) as users_count,
  strftime('%Y-%m-%d', login_timestamp, 'unixepoch') as ymd_date
FROM login_history
WHERE login_timestamp >= strftime('%s', '2018-06-02')
GROUP BY ymd_date;

-- Show Average users per day before compared to after
SELECT 
  AVG(before_change.users_count) as avg_before,
  AVG(after_change.users_count) as avg_after
FROM before_change, after_change;


-- PART 2: Create a SQL query that indicates the number of status changes by card

-- Create a view where only changes in status recorded
CREATE VIEW status_change
AS
SELECT * FROM card_change_history
WHERE 
  oldStatus IS NOT NULL AND 
  newStatus IS NOT NULL AND
  oldStatus != newStatus
;

SELECT 
  COUNT(DISTINCT id) as numberOfChanges,
  cardId
FROM status_change
GROUP BY cardId;


