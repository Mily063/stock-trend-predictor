-- widok z najnowszą cena zeby nie robic za kazdym razem subselectow
CREATE OR REPLACE VIEW v_latest_prices AS
WITH RankedPrices AS (
    SELECT 
        company_id,
        price_date,
        close_price,
        ROW_NUMBER() OVER(PARTITION BY company_id ORDER BY price_date DESC) as rn
    FROM stock_prices
)
SELECT 
    c.ticker,
    c.name,
    rp.price_date,
    rp.close_price
FROM RankedPrices rp
JOIN companies c ON rp.company_id = c.id
WHERE rp.rn = 1;


-- sprawdzenie czy prognozy sie sprawdzily 
CREATE OR REPLACE VIEW v_predictions_vs_actuals AS
SELECT 
    p.id AS prediction_id,
    c.ticker,
    p.target_date,
    p.predicted_price,
    sp.close_price AS actual_price,
    p.model_used,
    ROUND(ABS(p.predicted_price - sp.close_price) / sp.close_price * 100, 2) AS error_percentage
FROM predictions p
JOIN companies c ON p.company_id = c.id
LEFT JOIN stock_prices sp ON c.id = sp.company_id AND p.target_date = sp.price_date;


-- przykladowy raport: wolumen z ostatnich 30 dni > sredni calkowity
/*
SELECT c.ticker, c.name, 
       (SELECT AVG(volume) FROM stock_prices WHERE company_id = c.id AND price_date >= CURRENT_DATE - INTERVAL '30 days') as avg_vol_30d,
       (SELECT AVG(volume) FROM stock_prices WHERE company_id = c.id) as avg_vol_all_time
FROM companies c
WHERE 
    (SELECT AVG(volume) FROM stock_prices WHERE company_id = c.id AND price_date >= CURRENT_DATE - INTERVAL '30 days') > 
    (SELECT AVG(volume) FROM stock_prices WHERE company_id = c.id);
*/
