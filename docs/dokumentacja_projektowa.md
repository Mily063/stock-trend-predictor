# Dokumentacja bazy danych: Giełda

## O co chodzi
Projekt do zapisywania danych giełdowych, portfeli inwestycyjnych i przewidywań analityków. Wybraliśmy PostgreSQL, bo ma fajne funkcje okna i łatwo się pisze triggery.

## Baza i tabele
Zrobiliśmy to w 3NF, żeby uniknąć powtórzeń. Mamy tabele na uzytkownikow, spółki, historie notowań (ceny dzienne), portfele, sklad tych portfeli (wiele do wielu wiec tabela laczaca) i na prognozy analitykow.

## Schemat (ERD)
```mermaid
erDiagram
    USERS ||--o{ PORTFOLIOS : owns
    USERS ||--o{ PREDICTIONS : creates
    COMPANIES ||--o{ STOCK_PRICES : ma
    COMPANIES ||--o{ PREDICTIONS : dotyczy
    COMPANIES ||--o{ PORTFOLIO_ASSETS : nalezy_do
    PORTFOLIOS ||--o{ PORTFOLIO_ASSETS : zawiera

    USERS {
        int id PK
        string username
        string password_hash
        string role
    }

    COMPANIES {
        int id PK
        string ticker
        string name
        string sector
    }

    STOCK_PRICES {
        int id PK
        int company_id FK
        date price_date
        numeric close_price
    }
```
*(uproszczony dla czytelności)*

## Zaawansowane rzeczy na ocenę
*   **Transakcje**: zrobiony skrypt z pokazaniem commit, rollback, upserta oraz izolacją repeatable read.
*   **Role**: dodani uzytkownicy z różnymi prawami (`admin`, `analyst`, `investor`).
*   **Widoki**: zrobiony np. podgląd, czy prognoza się sprawdziła łącząc to z historią, subselecty do liczenia średniej itp.
*   **Wyzwalacze (Triggers)**: napisana w plpgsql walidacja, czy cena high jest rzeczywiście największa danego dnia.

## Instrukcja
Żeby odpalić lokalnie w psql:
1. `\i 01_schema.sql`
2. `\i 02_roles_and_security.sql`
3. `\i 03_views_and_queries.sql`
4. `\i 04_functions_and_triggers.sql`
5. `\i 06_sample_data.sql`
