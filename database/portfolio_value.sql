-- funkcja zliczajaca aktualna wartosc portfela
-- bierze portfolio_id i zwraca sume (ilosc * najnowsza cena zamkniecia) po wszystkich aktywach
-- laczymy sie z widokiem v_latest_prices, ktory zwraca ticker -> wiec idziemy przez companies

CREATE OR REPLACE FUNCTION calculate_portfolio_value(_portfolio_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_value NUMERIC := 0;
BEGIN
    -- dla kazdego aktywa w portfelu: ilosc * najnowsza cena zamkniecia
    -- COALESCE zeby pusty (lub nieznany) portfel zwracal 0 zamiast NULL
    SELECT COALESCE(SUM(pa.quantity * lp.close_price), 0)
    INTO total_value
    FROM portfolio_assets pa
    JOIN companies c ON pa.company_id = c.id
    JOIN v_latest_prices lp ON lp.ticker = c.ticker
    WHERE pa.portfolio_id = _portfolio_id;

    RETURN total_value;
END;
$$ LANGUAGE plpgsql;

-- SELECT calculate_portfolio_value(1);  -- Portfel Główny: 50*153 + 10*315 = 10800
-- SELECT calculate_portfolio_value(2);  -- Portfel Emerytalny: 100*142 = 14200
-- SELECT calculate_portfolio_value(999); -- nieistniejacy portfel -> 0
