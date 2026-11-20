CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    login VARCHAR(50) NOT NULL UNIQUE,
    role_id INT NOT NULL REFERENCES roles(role_id)
);

j

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE subcategories (
    subcategory_id SERIAL PRIMARY KEY,
    subcategory_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(category_id)
);

CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    subcategory_id INT NOT NULL REFERENCES subcategories(subcategory_id),
    manufacturer_id INT NOT NULL REFERENCES manufacturers(manufacturer_id),
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    composition VARCHAR(200),
    base_price NUMERIC(10,2) NOT NULL CHECK (base_price > 0),
    image VARCHAR(200)
);

CREATE TABLE sizes (
    size_id SERIAL PRIMARY KEY,
    size_value INT NOT NULL UNIQUE
);

CREATE TABLE stock_items (
    stock_item_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    size_id INT NOT NULL REFERENCES sizes(size_id),
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    UNIQUE (product_id, size_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    user_id INT NOT NULL REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    stock_item_id INT NOT NULL REFERENCES stock_items(stock_item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0)
);



INSERT INTO roles (role_name) VALUES
('Клиент'),
('Менеджер'),
('Администратор');
INSERT INTO users (last_name, first_name, middle_name, login, role_id) VALUES
('Лукина', 'Анна', 'Сергеевна', 'client01', 1),
('Романов', 'Илья', 'Павлович', 'client02', 1),
('Крылова', 'Мария', 'Андреевна', 'client03', 1),
('Зайцев', 'Денис', 'Олегович', 'client04', 1),
('Белова', 'Елена', 'Ильинична', 'client05', 1),
('Туманов', 'Максим', 'Романович', 'client06', 1),
('Орлова', 'Дарья', 'Алексеевна', 'manager01', 2),
('Фомин', 'Виктор', 'Дмитриевич', 'manager02', 2),
('Власов', 'Кирилл', 'Михайлович', 'admin01', 3),
('Соколова', 'Ольга', 'Константиновна', 'admin02', 3);
INSERT INTO categories (category_name) VALUES
('Для сборки'),
('Для монтажа'),
('Утеплённые');


j
INSERT INTO subcategories (subcategory_name, category_id) VALUES
('Трикотажные', 1),
('С точечным покрытием', 1),
('С усиленной ладонью', 2),
('С крагой', 2),
('С вязаной манжетой', 3),
('С удлинённой манжетой', 3);


INSERT INTO manufacturers (manufacturer_name) VALUES
('Стежок'),
('Технолад'),
('Прочный шов'),
('РабЛайн'),
('ТеплоТекс');



INSERT INTO products (subcategory_id, manufacturer_id, product_name, description, composition, base_price, image) VALUES
(1, 1, 'Такт', 'Тонкая вязка для работы с мелкими деталями', 'Хлопок и полиэстер', 160, 'model_01.png'),
(1, 2, 'Микро', 'Плотная манжета и гладкая ладонь', 'Хлопок и полиэстер', 200, 'model_02.png'),
(2, 3, 'Сетка', 'Точечный рисунок для сухих поверхностей', 'Хлопок и полиэстер', 240, 'model_03.png'),
(2, 1, 'Сборка', 'Упругая облегающая манжета', 'Хлопок и полиэстер', 280, 'model_04.png'),
(3, 4, 'Контур', 'Усиленная ладонь и текстильный тыльник', 'Полиамид и нитриловое покрытие', 520, 'model_05.png'),
(3, 2, 'Опора', 'Плотная ткань в зоне большого пальца', 'Полиамид и нитриловое покрытие', 440, 'model_06.png'),
(4, 3, 'Захват', 'Длинная крага с широкой посадкой', 'Полиамид и нитриловое покрытие', 600, 'model_07.png'),
(4, 4, 'Борт', 'Нескользящая вставка по краю ладони', 'Полиамид и нитриловое покрытие', 480, 'model_08.png'),
(5, 5, 'Иней', 'Мягкая подкладка и усиленная манжета', 'Полиэстер, акрил и латекс', 760, 'model_09.png'),
(5, 1, 'Снег', 'Внутренний акриловый слой', 'Полиэстер, акрил и латекс', 640, 'model_10.png'),
(6, 5, 'Полюс', 'Длинная манжета под рукав куртки', 'Полиэстер, акрил и латекс', 840, 'model_11.png'),
(6, 4, 'Север', 'Тёплый вкладыш и рельефная ладонь', 'Полиэстер, акрил и латекс', 720, NULL);



--юзануть похже
INSERT INTO sizes (size_value) VALUES
(6),
(7),
(8),
(9),
(10),
(11);

INSERT INTO stock_items (product_id, size_id, quantity) VALUES
(1, 1, 7),
(1, 2, 0),
(1, 3, 2),
(2, 1, 1),
(2, 2, 0),
(2, 3, 2),
(3, 2, 1),
(3, 3, 2),
(3, 4, 2),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(5, 3, 2),
(5, 4, 5),
(5, 5, 1),
(6, 3, 8),
(6, 4, 2),
(6, 5, 0),
(7, 4, 0),
(7, 5, 1),
(7, 6, 3),
(8, 4, 5),
(8, 5, 0),
(8, 6, 1),
(9, 1, 1),
(9, 2, 1),
(9, 3, 0),
(10, 1, 4),
(10, 2, 1),
(10, 3, 0),
(11, 2, 4),
(11, 3, 3),
(11, 4, 2),
(12, 2, 3),
(12, 3, 2),
(12, 4, 1);

INSERT INTO orders (order_id, order_date, user_id) VALUES
(1001, '2026-11-30', 1),
(1002, '2026-12-01', 2),
(1003, '2026-12-03', 3),
(1004, '2026-12-07', 4),
(1005, '2026-12-13', 5),
(1006, '2026-12-17', 6),
(1007, '2026-12-22', 1),
(1008, '2026-12-31', 2),
(1009, '2027-01-01', 3),
(1010, '2027-01-03', 4),
(1011, '2027-01-05', 5),
(1012, '2027-01-07', 6);

INSERT INTO order_items (order_id, stock_item_id, quantity, unit_price) VALUES
(1001, 1, 1, 160),
(1001, 14, 2, 520),
(1002, 5, 2, 200),
(1002, 21, 1, 600),
(1003, 15, 1, 520),
(1004, 16, 2, 440),
(1004, 29, 1, 640),
(1005, 20, 1, 600),
(1006, 33, 2, 840),
(1006, 16, 1, 440),
(1007, 22, 1, 480),
(1008, 5, 2, 200),
(1008, 27, 1, 760),
(1009, 3, 1, 160),
(1009, 7, 2, 240),
(1010, 10, 2, 280),
(1011, 26, 1, 760),
(1011, 30, 2, 640),
(1012, 33, 2, 840),
(1012, 34, 1, 720);
