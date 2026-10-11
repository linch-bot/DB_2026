-- ============================================================================
-- Лабораторна робота №2: Перетворення ER-діаграми на схему PostgreSQL
-- Предметна область: Інтернет-магазин електроніки «TechStore»
-- Виконала: Лінчевська Анастасія, група ІМ-о51
-- ============================================================================

-- ============================================================================
-- ЧАСТИНА 1: СТВОРЕННЯ ТАБЛИЦЬ (CREATE TABLE)
-- ============================================================================

-- 1. Таблиця клієнтів (customers)
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name   VARCHAR(120) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    phone       VARCHAR(30)  NOT NULL UNIQUE,
    city        VARCHAR(80)  NOT NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Таблиця категорій товарів (categories)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 3. Таблиця товарів (products)
CREATE TABLE products (
    product_id     SERIAL PRIMARY KEY,
    category_id    INTEGER       NOT NULL REFERENCES categories(category_id),
    name           VARCHAR(150)  NOT NULL,
    legacy_sku     VARCHAR(50)   UNIQUE,
    price          NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INTEGER       NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    tags           VARCHAR(255),
    supplier_name  VARCHAR(120)  NOT NULL,
    supplier_phone VARCHAR(30)   NOT NULL,
    supplier_email VARCHAR(150)  NOT NULL
);

-- 4. Таблиця замовлень (orders)
CREATE TABLE orders (
    order_id             SERIAL PRIMARY KEY,
    customer_id          INTEGER       NOT NULL REFERENCES customers(customer_id),
    order_date           TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status               VARCHAR(30)   NOT NULL DEFAULT 'pending'
                         CHECK (status IN ('pending', 'paid', 'shipped', 'completed', 'cancelled')),
    shipping_address     VARCHAR(255)  NOT NULL,
    shipping_city        VARCHAR(80)   NOT NULL,
    city_delivery_tariff NUMERIC(8,2)  NOT NULL DEFAULT 0.00 CHECK (city_delivery_tariff >= 0),
    total_amount         NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- 5. Таблиця позицій замовлення (order_items — асоціативна таблиця M:N)
CREATE TABLE order_items (
    order_id     INTEGER       NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id   INTEGER       NOT NULL REFERENCES products(product_id),
    product_name VARCHAR(150)  NOT NULL,
    quantity     INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price   NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    PRIMARY KEY (order_id, product_id)
);

-- 6. Таблиця платежів (payments — зв'язок 1:1 із замовленням)
CREATE TABLE payments (
    payment_id     SERIAL PRIMARY KEY,
    order_id       INTEGER       NOT NULL UNIQUE REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_method VARCHAR(40)   NOT NULL
                   CHECK (payment_method IN ('card', 'apple_pay', 'google_pay', 'cash_on_delivery')),
    amount         NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    payment_status VARCHAR(30)   NOT NULL DEFAULT 'pending'
                   CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    paid_at        TIMESTAMP
);

-- ============================================================================
