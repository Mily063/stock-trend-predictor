-- czyscimy stare dane jak odpalamy jeszcze raz
TRUNCATE TABLE users, companies, stock_prices, portfolios, portfolio_assets, predictions RESTART IDENTITY CASCADE;

INSERT INTO users (username, password_hash, role) VALUES 
('jan_admin', 'hash1', 'admin'),
('anna_analyst', 'hash2', 'analyst'),
('piotr_investor', 'hash3', 'investor');

INSERT INTO companies (ticker, name, sector, industry, description) VALUES
('AAPL', 'Apple Inc.', 'Technology', 'Consumer Electronics', 'Producent sprzetu'),
('MSFT', 'Microsoft Corp.', 'Technology', 'Software', 'Cloud i soft'),
('TSLA', 'Tesla Inc.', 'Consumer Discretionary', 'Automobile', 'Elektryki'),
('JPM', 'JPMorgan Chase', 'Financials', 'Banks', 'Bank');

INSERT INTO stock_prices (company_id, price_date, open_price, close_price, high_price, low_price, volume) VALUES
(1, '2026-06-01', 150.00, 155.00, 156.00, 149.00, 1000000),
(1, '2026-06-02', 155.00, 153.00, 157.00, 152.00, 1200000),
(2, '2026-06-01', 300.00, 305.00, 310.00, 295.00, 500000),
(2, '2026-06-02', 305.00, 315.00, 316.00, 300.00, 600000),
(3, '2026-06-01', 200.00, 210.00, 215.00, 195.00, 2000000),
(4, '2026-06-01', 140.00, 142.00, 143.00, 139.00, 800000);

INSERT INTO portfolios (user_id, name) VALUES
(3, 'Portfel Główny'),
(3, 'Portfel Emerytalny');

INSERT INTO portfolio_assets (portfolio_id, company_id, quantity, average_buy_price) VALUES
(1, 1, 50, 140.00),
(1, 2, 10, 280.00),
(2, 4, 100, 135.00);

INSERT INTO predictions (company_id, user_id, target_date, predicted_price, model_used) VALUES
(1, 2, '2026-06-15', 160.00, 'LSTM Neural Network'),
(3, 2, '2026-06-15', 250.00, 'XGBoost'),
(2, 2, '2026-06-01', 304.00, 'ARIMA');
