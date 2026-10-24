-- ============================================================================
-- Лабораторна робота №4: Аналітичні SQL-запити (OLAP)
-- Предметна область: Інтернет-магазин електроніки «TechStore»
-- Виконала: Лінчевська Анастасія, група ІМ-о51
-- ============================================================================

-- ============================================================================
-- БЛОК 1: АГРЕГАЦІЙНІ ФУНКЦІЇ
-- ============================================================================

-- Запит 1.1: Базова агрегація по каталогу товарів
-- (загальна кількість моделей, сумарний залишок на складі, середня, мінімальна та максимальна ціна)
SELECT
    COUNT(*)                     AS total_products,
    SUM(stock_quantity)          AS total_units_in_stock,
    ROUND(AVG(price), 2)         AS avg_product_price,
    MIN(price)                   AS min_product_price,
    MAX(price)                   AS max_product_price
FROM products;

-- Запит 1.2: Групування замовлень за містом доставки (GROUP BY)
-- (кількість замовлень, загальна сума виручки та середній чек по кожному місту)
SELECT
    shipping_city,
    COUNT(*)                     AS orders_count,
    SUM(total_amount)            AS city_total_revenue,
    ROUND(AVG(total_amount), 2)  AS avg_order_amount
FROM orders
WHERE status <> 'cancelled'
GROUP BY shipping_city
ORDER BY city_total_revenue DESC;

-- Запит 1.3: Статистика за способами оплати (GROUP BY)
-- (кількість платежів, мінімальний, максимальний та сумарний обсяг транзакцій)
SELECT
    payment_method,
    COUNT(*)                     AS payments_count,
    MIN(amount)                  AS min_payment,
    MAX(amount)                  AS max_payment,
    SUM(amount)                  AS total_paid_amount
FROM payments
WHERE payment_status = 'completed'
GROUP BY payment_method
ORDER BY total_paid_amount DESC;

-- Запит 1.4: Фільтрація згрупованих даних за допомогою HAVING
-- (пошук категорій, у яких середня вартість товару перевищує 15 000 грн)
SELECT
    category_id,
    COUNT(*)                     AS products_in_category,
    ROUND(AVG(price), 2)         AS avg_category_price,
    SUM(stock_quantity)          AS total_category_stock
FROM products
GROUP BY category_id
HAVING AVG(price) > 15000.00
