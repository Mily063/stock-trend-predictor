-- TODO dla [Imie kolegi] (funkcja zliczajaca kwote portfela)
-- wez portfolio_id i zwroc sume z portfolio_assets pomnozona przez najnowsza cene zamkniecia
-- mozesz zlaczyc z widokiem v_latest_prices

CREATE OR REPLACE FUNCTION calculate_portfolio_value(_portfolio_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_value NUMERIC := 0;
BEGIN
    -- tutaj walnij selecta do zmiennej total_value
    
    RETURN total_value;
END;
$$ LANGUAGE plpgsql;

-- SELECT calculate_portfolio_value(1);
