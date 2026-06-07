-- kupowanie akcji (jak cos pojdzie nie tak to wszystko sie cofa)
BEGIN;

-- wstawienie albo update (usrednianie ceny jak juz je mamy w portfelu)
INSERT INTO portfolio_assets (portfolio_id, company_id, quantity, average_buy_price)
VALUES (1, 2, 100, 145.50)
ON CONFLICT (portfolio_id, company_id) DO UPDATE SET
    average_buy_price = ((portfolio_assets.quantity * portfolio_assets.average_buy_price) + (100 * 145.50)) / (portfolio_assets.quantity + 100),
    quantity = portfolio_assets.quantity + 100;

COMMIT;


-- generowanie raportow bez efektu brudnego odczytu (repeatable read)
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT sum(quantity * average_buy_price) FROM portfolio_assets WHERE portfolio_id = 1;
COMMIT;

-- wycofywanie zlych wartosci
BEGIN;
    INSERT INTO portfolio_assets (portfolio_id, company_id, quantity, average_buy_price)
    VALUES (1, 3, -50, 100.00); -- to wywali blad na CHECK i uzyjemy rollbacka
ROLLBACK;
