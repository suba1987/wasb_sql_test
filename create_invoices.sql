USE memory.default;

CREATE TABLE IF NOT EXISTS SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE IF NOT EXISTS INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

INSERT INTO SUPPLIER VALUES 
    (1, 'Catering Plus'),
    (2, 'Dave''s Discos'),
    (3, 'Entertainment tonight'),
    (4, 'Ice Ice Baby'),
    (5, 'Party Animals');

-- I used current date to figure out the due date, in the real world we would probably
-- never do something like this because if the data gets reloaded at some point, the 
-- whole payment scheduled would turn to mess
INSERT INTO INVOICE VALUES
    (5, 6000.00, LAST_DAY_OF_MONTH(DATE_ADD('month', 3, CURRENT_DATE))),
    (1, 2000.00, LAST_DAY_OF_MONTH(DATE_ADD('month', 2, CURRENT_DATE))),
    (1, 1500.00, LAST_DAY_OF_MONTH(DATE_ADD('month', 3, CURRENT_DATE))),
    (2, 500.00, LAST_DAY_OF_MONTH(DATE_ADD('month', 1, CURRENT_DATE))),
    (3, 6000.00, LAST_DAY_OF_MONTH(DATE_ADD('month', 3, CURRENT_DATE))),
    (4, 4000.00, LAST_DAY_OF_MONTH(DATE_ADD('month', 6, CURRENT_DATE)));
