-- kolumna na modyfikacje
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- auto update updated_at
CREATE OR REPLACE FUNCTION update_modified_column() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_modtime 
BEFORE UPDATE ON users 
FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


-- zabezpieczenie zeby ktos nie wpisal glupot w cenach
CREATE OR REPLACE FUNCTION check_stock_prices_validity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.high_price < NEW.low_price THEN
        RAISE EXCEPTION 'High nie moze byc mniejsze od low';
    END IF;
    IF NEW.open_price > NEW.high_price OR NEW.open_price < NEW.low_price THEN
        RAISE EXCEPTION 'Cena otwarcia poza widelkami';
    END IF;
    IF NEW.close_price > NEW.high_price OR NEW.close_price < NEW.low_price THEN
        RAISE EXCEPTION 'Cena zamkniecia poza widelkami';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_stock_prices
BEFORE INSERT OR UPDATE ON stock_prices
FOR EACH ROW EXECUTE PROCEDURE check_stock_prices_validity();
