-- czyszczenie tabel przed tworzeniem
DROP TABLE IF EXISTS portfolio_assets CASCADE;
DROP TABLE IF EXISTS portfolios CASCADE;
DROP TABLE IF EXISTS predictions CASCADE;
DROP TABLE IF EXISTS stock_prices CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- uzytkownicy (role: admin, analyst, investor)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'investor',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- spolki
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    ticker VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    sector VARCHAR(50) NOT NULL,
    industry VARCHAR(100),
    description TEXT
);

-- historia notowan
CREATE TABLE stock_prices (
    id SERIAL PRIMARY KEY,
    company_id INT NOT NULL,
    price_date DATE NOT NULL,
    open_price NUMERIC(10, 4) NOT NULL CHECK (open_price >= 0),
    close_price NUMERIC(10, 4) NOT NULL CHECK (close_price >= 0),
    high_price NUMERIC(10, 4) NOT NULL CHECK (high_price >= 0),
    low_price NUMERIC(10, 4) NOT NULL CHECK (low_price >= 0),
    volume BIGINT NOT NULL CHECK (volume >= 0),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT unique_company_date UNIQUE (company_id, price_date)
);

-- portfele
CREATE TABLE portfolios (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- sklad portfeli
CREATE TABLE portfolio_assets (
    portfolio_id INT NOT NULL,
    company_id INT NOT NULL,
    quantity NUMERIC(15, 4) NOT NULL CHECK (quantity >= 0),
    average_buy_price NUMERIC(10, 4) NOT NULL CHECK (average_buy_price >= 0),
    PRIMARY KEY (portfolio_id, company_id),
    CONSTRAINT fk_portfolio FOREIGN KEY (portfolio_id) REFERENCES portfolios(id) ON DELETE CASCADE,
    CONSTRAINT fk_company_asset FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
);

-- prognozy analitykow
CREATE TABLE predictions (
    id SERIAL PRIMARY KEY,
    company_id INT NOT NULL,
    user_id INT NOT NULL,
    target_date DATE NOT NULL,
    predicted_price NUMERIC(10, 4) NOT NULL,
    model_used VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_company_pred FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_pred FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- przydatne indeksy
CREATE INDEX idx_stock_prices_date ON stock_prices(price_date);
CREATE INDEX idx_companies_sector ON companies(sector);
CREATE INDEX idx_predictions_target_date ON predictions(target_date);
