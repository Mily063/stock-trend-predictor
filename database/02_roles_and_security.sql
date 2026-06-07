-- usuwamy stare role jak odpalamy skrypt od nowa
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_analyst;
DROP ROLE IF EXISTS db_investor;

-- zakladamy role
CREATE ROLE db_admin WITH LOGIN PASSWORD 'AdminPass123!';
CREATE ROLE db_analyst WITH LOGIN PASSWORD 'AnalystPass123!';
CREATE ROLE db_investor WITH LOGIN PASSWORD 'InvestorPass123!';

-- ADMIN ma pelne uprawnienia
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO db_admin;

-- ANALYST moze czytac wszystko i dodawac notowania/prognozy
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_analyst;
GRANT INSERT, UPDATE ON stock_prices, companies, predictions TO db_analyst;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO db_analyst;

-- INVESTOR widzi dane gieldowe, ale edytuje tylko swoj portfel
GRANT SELECT ON companies, stock_prices, predictions TO db_investor;
GRANT SELECT, INSERT, UPDATE, DELETE ON portfolios, portfolio_assets TO db_investor;
GRANT USAGE, SELECT ON SEQUENCE portfolios_id_seq TO db_investor;

-- opcjonalnie wlaczenie RLS zeby inwestor nie widzial nieswoich portfeli
ALTER TABLE portfolios ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_assets ENABLE ROW LEVEL SECURITY;

CREATE POLICY admin_all_portfolios ON portfolios TO db_admin USING (true) WITH CHECK (true);
CREATE POLICY admin_all_assets ON portfolio_assets TO db_admin USING (true) WITH CHECK (true);
