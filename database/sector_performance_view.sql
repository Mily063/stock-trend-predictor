-- TODO
-- zrob widok v_sector_performance
-- zwroc ticker, sector, current_price, avg_sector_price (tu wlasnie funkcja okna over partition)
-- wystarczy polaczyc companies z naszym v_latest_prices

CREATE OR REPLACE VIEW v_sector_performance AS
SELECT c.ticker, c.sector, lp.close_price AS current_price,
AVG(lp.close_price) OVER (PARTITION BY c.sector) AS avg_sector_price
FROM companies c JOIN v_latest_prices lp ON lp.ticker = c.ticker;

SELECT * FROM v_sector_performance;

