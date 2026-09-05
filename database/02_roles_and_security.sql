-- ============================================================================
-- Roles & Security Configuration
-- ============================================================================
-- NOTE: Never store plaintext passwords in version control.
-- Passwords must be passed dynamically at runtime using psql variables (-v).
--
-- Example execution:
--   psql -U postgres -d stock_db \
--     -v admin_password='<SECURE_ADMIN_PASSWORD>' \
--     -v analyst_password='<SECURE_ANALYST_PASSWORD>' \
--     -v investor_password='<SECURE_INVESTOR_PASSWORD>' \
--     -f database/02_roles_and_security.sql
--
-- Or via environment variables:
--   psql -U postgres -d stock_db \
--     -v admin_password="$DB_ADMIN_PASSWORD" \
--     -v analyst_password="$DB_ANALYST_PASSWORD" \
--     -v investor_password="$DB_INVESTOR_PASSWORD" \
--     -f database/02_roles_and_security.sql
-- ============================================================================

-- usuwamy stare role jak odpalamy skrypt od nowa
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS db_analyst;
DROP ROLE IF EXISTS db_investor;

-- zakladamy role z haslami przekazanymi przez zmienne psql
CREATE ROLE db_admin WITH LOGIN PASSWORD :'admin_password';
CREATE ROLE db_analyst WITH LOGIN PASSWORD :'analyst_password';
CREATE ROLE db_investor WITH LOGIN PASSWORD :'investor_password';

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

-- Row Level Security (RLS) zeby inwestor widzial i edytowal wylacznie swoje portfele
ALTER TABLE portfolios ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_assets ENABLE ROW LEVEL SECURITY;

-- 1) Administrator ma pelny dostep do wszystkich portfeli i aktywow
CREATE POLICY admin_all_portfolios ON portfolios TO db_admin USING (true) WITH CHECK (true);
CREATE POLICY admin_all_assets ON portfolio_assets TO db_admin USING (true) WITH CHECK (true);

-- 2) Inwestor ma dostep wylacznie do wlasnych portfeli i powiazanych pozycji
-- Kontekst uzytkownika przekazywany jest w sesji aplikacji (SET LOCAL app.current_user_id = '<user_id>')
CREATE POLICY investor_own_portfolios ON portfolios TO db_investor
    USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::int)
    WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::int);

CREATE POLICY investor_own_assets ON portfolio_assets TO db_investor
    USING (portfolio_id IN (
        SELECT id FROM portfolios 
        WHERE user_id = NULLIF(current_setting('app.current_user_id', true), '')::int
    ))
    WITH CHECK (portfolio_id IN (
        SELECT id FROM portfolios 
        WHERE user_id = NULLIF(current_setting('app.current_user_id', true), '')::int
    ));
