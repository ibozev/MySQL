DROP DATABASE IF EXISTS restaurant;
CREATE DATABASE restaurant;
USE restaurant;

CREATE TABLE waiters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(20) NULL DEFAULT NULL,
    UNIQUE (phone)
);

CREATE TABLE orders (
    numOfTable INT PRIMARY KEY,
    numOfClients INT NOT NULL,
    waiter_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (waiter_id) REFERENCES waiters(id)
);

CREATE TABLE drinks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type ENUM ('топли напитки', 'шотове', 'бира', 'джин', 'водка', 'узо', 'мастика',
	'бренди', 'ликьор', 'ром', 'текила', 'уиски', 'ракия', 'вино', 'коктейли') NULL DEFAULT NULL,
    volume DOUBLE NOT NULL,
    price DOUBLE DEFAULT NULL,
    isAlcoholic ENUM ('yes', 'no'),
    beer_type ENUM ('light bottle', 'light draft', 'light can', 
	'dark bottle', 'dark draft', 'dark can') NULL DEFAULT NULL,
    UNIQUE (name, volume) 
);

CREATE TABLE order_drink (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    drink_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (order_id) REFERENCES orders(numOfTable) 
	ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (drink_id) REFERENCES drinks(id) 
	ON DELETE CASCADE 
        ON UPDATE CASCADE,
    order_time DATETIME NOT NULL,
    comments TEXT NULL DEFAULT NULL
);

/* Of a wine there may be a small and a large bottle, but it will have reference only to the large,
it is logical that the small one with the same name, but another size, has the same ingredients (wine, year, winery) */
CREATE TABLE wines (
    drink_id INT PRIMARY KEY, 
    color ENUM ('бяло', 'червено', 'розе') NOT NULL,
    typeOfGrape VARCHAR(150) NULL,
    winery VARCHAR(50) NULL,
    year YEAR NULL DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    CONSTRAINT FOREIGN KEY (drink_id) REFERENCES drinks(id),
    UNIQUE (typeOfGrape, winery, year)
);

CREATE TABLE coctails (
    drink_id INT PRIMARY KEY,
    ingredients TEXT NOT NULL, 
    decoration VARCHAR (50) NULL DEFAULT NULL,
    CONSTRAINT FOREIGN KEY (drink_id) REFERENCES drinks(id)
);

CREATE TABLE foods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM ('салати', 'предястия', 'аламинути', 'супи', 'основни ястия', 'мезета', 'риби', 
	'скара', 'паста', 'пици', 'специалитети', 'гарнитури', 'десерти', 'ядки', 'хляб') NOT NULL DEFAULT 'хляб',
    weight DOUBLE NOT NULL,
    lunchMenu ENUM ('yes', 'no') DEFAULT 'no', 
    ingredients TEXT NULL DEFAULT NULL, 
    allergens SET ('Зърнени култури съдържащи глутен', 'Ракообразни и продукти от тях', 'Яйца и продукти от тях', 
	'Риба и рибни продукти', 'Фъстъци и продукти от тях', 'Соя и соеви продукти', 'Мляко и млечни продукти', 
        'Ядки', 'Целина и продукти от нея', 'Синап и синапено семе (горчица)', 'Сусамово семе и продукти от тях', 
        'Мекотели и продукти от тях', 'Лупина и продукти от нея', 'Серен диоксид и сулфити') NULL DEFAULT NULL,
    price DOUBLE NOT NULL,
    UNIQUE (name, weight)
);

CREATE TABLE order_food (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (order_id) REFERENCES orders(numOfTable)
	ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (food_id) REFERENCES foods(id)
	ON DELETE CASCADE 
        ON UPDATE CASCADE,
    order_time DATETIME NOT NULL,
    comments TEXT NULL DEFAULT NULL # за доуточняване на поръчката
);

INSERT INTO waiters (name, phone)
VALUES	
    ('Петър Кунчев', '0885694595'),
    ('Иван Кафеджиев', NULL),
    ('Калина Йорданова', '0879569482'),
    ('Христина Ангелова', '0895699954');
    
#TODO lunchMenu
INSERT INTO foods (name, type, weight, ingredients, price, allergens) 
VALUES
    ('Шопска салата', 'салати', 350, 'домати, краставици, лук, сирене', 4.20, 
	'Мляко и млечни продукти'),
    ('Овчарска салата', 'салати', 400, 'домати, краставици, шунка, гъби, кашкавал', 5.50, 
     	'Мляко и млечни продукти'),
    ('Гръцка салата', 'салати', 350, 'домати, краставици, лук, сирене, маслини', 4.30, 
	'Мляко и млечни продукти'),
    ('Салата варени картофи', 'салати', 300, NULL, 3.50, NULL),
    ('Салата Цезар', 'салати', 400, 'айсберг, шунка, бекон, кротони, Цезар сос', 5.50, NULL),
    ('Средиземноморска', 'салати', 350, 'макарони, кисели краставички. шунка. сметана, майонеза', 5.00, NULL),
    ('Зелена салата с риба тон', 'салати', 400, 'маруля, риба тон, лук', 4.80, NULL),
    ('Печен пипер с катък', 'салати', 350, 'катък, печен пипер, чесън', 4.80, NULL),
    ('Туршия', 'салати', 350, NULL, 3.50, NULL),
    ('Кьопоолу', 'салати', 200, NULL, 3.00, NULL),
    ('Запечени картофи със сирене и кашкавал', 'предястия', 400, NULL, 4.20, NULL),
    ('Запечени картофи сбекон и кашкавал', 'предястия', 400, NULL, 4.80, NULL),
    ('Пържени картофи', 'предястия', 200, NULL, 2.80, NULL),
    ('Пикантни картофи', 'предястия', 200, NULL, 3.20, NULL),
    ('Език в масло', 'предястия', 250, NULL, 5.30, NULL),
    ('Телешко плато', 'предястия', 500, 'сърца, дробчета, воденички, бяло месо в подправки', 8.00, NULL),
    ('Свинско плато', 'предястия', 500, 'ребра, контра филе', 9.50, NULL),
    ('Пилешки хапки със сусам', 'предястия', 250, NULL, 5.20, NULL),
    ('Калмари пане', 'предястия', 200, NULL, 5.30, 'Мекотели и продукти от тях'),
    ('Пикантни пипала', 'предястия', 250, NULL, 6.00, 'Мекотели и продукти от тях'),
    ('Омплет със сирене', 'аламинути', 200, NULL, 3.50, 'Мляко и млечни продукти,Яйца и продукти от тях'),
    ('Омплет с шунка', 'аламинути', 200, NULL, 3.70, 'Яйца и продукти от тях'),
    ('Омплет с кашкавал', 'аламинути', 200, NULL, 3.80, 'Яйца и продукти от тях'),
    ('Яйца по панагюрски', 'аламинути', 250, NULL, 3.50, 'Яйца и продукти от тях'),
    ('Кашкавал пане', 'аламинути', 220, NULL, 4.20, 'Мляко и млечни продукти'),
    ('Сирене по шопски', 'аламинути', 350, NULL, 4.00, 'Мляко и млечни продукти'),
    ('Пиле жулиен', 'основни ястия', 250, NULL, 6.50, NULL),
    ('Пилешки шиш', 'скара', 200, NULL, 1.80, NULL),
    ('Свинска вратна пържола', 'скара', 250, NULL, 5.50, NULL),
    ('Свински шиш', 'скара', 200, NULL, 2.20, NULL),
    ('Кюфте', 'скара', 70, NULL, 1.30, NULL),
    ('Кебапче', 'скара', 70, NULL, 1.30, NULL),
    ('Свински ребра', 'скара', 350, NULL, 5.90, NULL),
    ('Джолан на фурна', 'основни ястия', 500, NULL, 9.00, NULL),
    ('Заешко задушено с гъби', 'основни ястия', 550, NULL, 15.50, NULL),
    ('Пилешки бутчета с кисело зеле', 'основни ястия', 650, NULL, 8.50, NULL),
    ('Телешко филе с аспержи', 'основни ястия', 350, NULL, 13.50, NULL),
    ('Чируз', 'риби', 250, NULL, 6.50, 'Риба и рибни продукти'),
    ('Сафрид пържен', 'риби', 250, NULL, 7.50, 'Риба и рибни продукти'),
    ('Пъстърва на скара', 'риби', 250, NULL, 6.80, 'Риба и рибни продукти'),
    ('Цаца', 'риби', 250, NULL, 3.00, 'Риба и рибни продукти'),
    ('Калкан', 'риби', 300, NULL, 19.00, 'Риба и рибни продукти'),
    ('Луканка', 'мезета', 100, NULL, 2.80, NULL),
    ('Кашкавал натюр', 'мезета', 100, NULL, 1.90, 'Мляко и млечни продукти'),
    ('Прошуто', 'мезета', 100, NULL, 2.80, NULL),
    ('Плато сирена', 'мезета', 500, 'синьо сирене, Бри, Ементал', 15.90, 'Мляко и млечни продукти'),
    ('Плато колбаси', 'мезета', 500, 'прошуто, пуешко филе, салам, старец', 15.90, NULL),
    ('Домати', 'гарнитури', 150, NULL, 2.00, NULL),
    ('Краставици', 'гарнитури', 150, NULL, 2.00, NULL),
    ('Варени картофи', 'гарнитури', 150, NULL, 1.50, NULL),
    ('Пържени картофи', 'гарнитури', 150, NULL, 1.70, NULL),
    ('Мелба', 'десерти', 320, NULL, 4.20, NULL),
    ('Банана сплит', 'десерти', 350, NULL, 3.50, NULL),
    ('Плодова салата', 'десерти', 300, 'портокал, банан, киви, грейпфрут, праскова, ябълка', 5.00, NULL),
    ('Сладолед', 'десерти', 80, NULL, 2.00, NULL),
    ('Кашу', 'ядки', 50, NULL, 2.00, 'Ядки'),
    ('Фъстък', 'ядки', 50, NULL, 1.50, 'Ядки'),
    ('Бадем', 'ядки', 50, NULL, 2.00, 'Ядки'),
    ('Лешник', 'ядки', 50, NULL, 1.80, 'Ядки'),
    ('Шам фъстък', 'ядки', 50, NULL, 2.50, 'Ядки'),
    ('Спагети Болонезе', 'паста', 400, 'доматен сос, телешка кайма, чесън, лук, целина, морков, пармезан, кашкавал',
	5.90, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти,Целина и продукти от нея'),
    ('Спагети Карбонара', 'паста', 400, 'сметана, бекон, шунка, лук, гъби, пармезан, кашакавал',
	5.90, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти'),
    ('Пене със сирена', 'паста', 400, 'сметана, топено сирене, синьо сирене, памезан, пушено сирене, кашкавал',
	6.30, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти'),
    ('Маргарита', 'пици', 600, 'доматен сос, кашкавал, пресен домат, риган',
	4.20, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти'),
    ('Капричоза', 'пици', 600, 'доматен сос, шунка, гъби, лук, зелени чушки, кашкавал, маслина', 
	5.90, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти'),
    ('Четири сирена', 'пици', 600, 'доматен сос, топено сирене, синьо сирене, ппушено сирене, кашкавал', 
     	6.90, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти'),
    ('Риба Тон', 'пици', 600, 'доматен сос, риба Тон, царевица, маслини, кашкавал', 
	6.90, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти,Риба и рибни продукти'),
    ('Прайд', 'пици', 600, 'доматен сос, луканка, шунка, пил.пушено филе, бекон, зелена чушка, гъби, лук, маслини, кашкавал, яйце', 
	8.90, 'Зърнени култури съдържащи глутен,Мляко и млечни продукти,Яйца и продукти от тях');

INSERT INTO foods (name, weight, price)
VALUES
	('Хляб', 5, 0.20);

/* in the lunch menu ingredients are not necessery*/
INSERT INTO foods (name, type, weight, lunchMenu, price, allergens) 
VALUES
    ('Свежа салата', 'салати', 200, 'yes', 2.60, NULL),
    ('Салата краставици', 'салати', 200, 'yes', 2.60, NULL),
    ('Салата зеле и моркови', 'салати', 200, 'yes', 2.00, NULL),
    ('Шопска салата', 'салати', 200, 'yes', 2.80, 'Мляко и млечни продукти'),
    ('Овчарска салата', 'салати', 250, 'yes', 3.30, 'Мляко и млечни продукти'),
    ('Гръцка салата', 'салати', 200, 'yes', 2.80, 'Мляко и млечни продукти'),
    ('Пилешка супа', 'супи', 300, 'yes', 2.50, 'Мляко и млечни продукти'),
    ('Супа топчета', 'супи', 300, 'yes', 2.50, 'Мляко и млечни продукти'),
    ('Таратор', 'супи', 300, 'yes', 2.20, 'Мляко и млечни продукти'),
    ('Шкембе чорба', 'супи', 300, 'yes', 2.70, NULL),  
    ('Свинско със зеле', 'основни ястия', 350, 'yes', 5.90, NULL),
    ('Пържени тиквички', 'основни ястия', 300, 'yes', 3.00, NULL),
    ('Пилешка кавърма', 'основни ястия', 350, 'yes', 4.00, NULL),
    ('Спанак с ориз', 'основни ястия', 350, 'yes', 3.00, NULL);

INSERT INTO drinks (name, type, volume, isAlcoholic, price)
VALUES
    ('Кафе', 'топли напитки', 60, 'no', 1.20),
    ('Ирландско кафе', 'топли напитки', 250, 'yes', 3.50),
    ('Капучино', 'топли напитки', 250, 'no', 2.60),
    ('Чай', 'топли напитки', 200, 'no', 1.20),
    ('Горещ шоколад', 'топли напитки', 350, 'no', 2.60),
    ('Кока кола, Фанта, Спрайт, Тоник', NULL, 250, 'no', 1.80),
    ('Минерална вода', NULL, 500, 'no', 1.30),
    ('Минерална вода', NULL, 1500, 'no', 1.30),
    ('Натурален сок Capppy', NULL, 250, 'no', 2.50),
    ('Студент чай', NULL, 250, 'no', 3.50),
    ('Фреш', NULL, 250, 'no', 3.50),
    ('Оранжада', 'коктейли', 350, 'no', 2.50), 
    ('Залез над Аризона', 'коктейли', 300, 'no', 3.80),
    ('Безалкохолно мохито', 'коктейли', 300, 'no', 3.80),
    ('Коктейл червена боровинка', 'коктейли', 300, 'no', 4.00),
    ('Арабска свирка', 'шотове', 25, 'yes', 4.00),
    ('Йегермайстер', 'шотове', 25, 'yes', 3.50),
    ('Абсент', 'шотове', 25, 'yes', 3.50),
    ('Бомбай', 'джин', 50, 'yes', 3.30),
    ('Савой', 'джин', 50, 'yes', 1.30),
    ('Бийфитър', 'джин', 50, 'yes', 2.00),
    ('Савой водка', 'водка', 50, 'yes', 1.70),
    ('Финландия', 'водка', 50, 'yes', 2.20),
    ('Абсолют', 'водка', 50, 'yes', 2.40),
    ('Пломари', 'узо', 50, 'yes', 3.30),
    ('Узаки Зорбас', 'узо', 50, 'yes', 1.60),
    ('Тсантали', 'водка', 50, 'yes', 2.40),
    ('Карнобатска', 'мастика', 50, 'yes', 1.60),
    ('Метакса', 'бренди', 50, 'yes', 3.00),
    ('Плиска', 'бренди', 50, 'yes', 2.00),
    ('Слънчев бряг', 'бренди', 50, 'yes', 2.00),
    ('Бакарди', 'ром', 50, 'yes', 4.00),
    ('Малибу', 'ром', 50, 'yes', 4.00),
    ('Савой ром', 'ром', 50, 'yes', 1.70),
    ('Мартини', NULL, 50, 'yes', 3.60),
    ('Кампари', NULL, 50, 'yes', 4.00),
    ('Бейлис', 'ликьор', 50, 'yes', 4.50),
    ('Амарето', 'ликьор', 50, 'yes', 4.00),
    ('Коантро', 'ликьор', 50, 'yes', 4.00),
    ('Савой', 'текила', 25, 'yes', 1.50),
    ('Джак Даниелс', 'уиски', 50, 'yes', 6.20),
    ('Чивас Регал', 'уиски', 50, 'yes', 8.00),
    ('Бушмилс', 'уиски', 50, 'yes', 4.60),
    ('Карнобатска гроздова', 'ракия', 50, 'yes', 1.70),
    ('Кехлибар', 'ракия', 50, 'yes', 3.50),
    ('Бургас 63', 'ракия', 50, 'yes', 3.30),
    ('Мохито', 'коктейли', 300, 'yes', 5.50),
    ('Маргарита', 'коктейли', 200, 'yes', 5.00),
    ('Куба Либре', 'коктейли', 300, 'yes', 5.00),
    ('Космополитан', 'коктейли', 200, 'yes', 5.50),
    ('Мотли Кок', 'вино', 750, 'yes', 15.00),
    ('Александра', 'вино', 750, 'yes', 16.00),
    ('Левент', 'вино', 750, 'yes', 17.00),
    ('Енира', 'вино', 750, 'yes', 15.00),
    ('Тера Тангра', 'вино', 750, 'yes', 18.00),
    ('Санта Сара', 'вино', 750, 'yes', 22.00),
    ('Захир', 'вино', 750, 'yes', 20.00),
    ('Едоардо Миролио', 'вино', 750, 'yes', 22.00),
    ('Фейс то фейс', 'вино', 750, 'yes', 19.00),
    ('Риалинг Класик', 'вино', 750, 'yes', 19.00),
    ('Виня Сол', 'вино', 750, 'yes', 24.00),
    ('Гейс', 'вино', 750, 'yes', 16.00),
    ('Шато Сейнт Пиер', 'вино', 750, 'yes', 25.00),
    ('Да Коста', 'вино', 750, 'yes', 22.00),
    ('Мировал', 'вино', 750, 'yes', 20.00),
    ('Сангре де', 'вино', 750, 'yes', 26.00),
    ('Бабич Пино Ноар', 'вино', 750, 'yes', 27.00),
    ('Мишел Роан', 'вино', 750, 'yes', 27.00),
    ('Тера Тангра', 'вино', 375, 'yes', 8.00),
    ('Мишел Роан', 'вино', 375, 'yes', 10.00),
    ('Гейс', 'вино', 375, 'yes', 9.00),
    ('Мировал', 'вино', 375, 'yes', 11.00);

#INSERT beers
INSERT INTO drinks (name, type, volume, isAlcoholic, price, beer_type)
VALUES      
	('Стела Артоа', 'бира', 500, 'yes', 2.70, 'light bottle'),
	('Стела Артоа', 'бира', 330, 'yes', 3.30, 'light bottle'),
	('Бекс', 'бира', 500, 'yes', 2.90, 'dark bottle'),
	('Бекс', 'бира', 330, 'yes', 3.30, 'light bottle'),
	('Каменица', 'бира', 500, 'yes', 2.00, 'light draft'),
	('Ариана', 'бира', 500, 'yes', 2.00, 'light can');

#INSERT coctails specifications 
INSERT INTO coctails (drink_id, ingredients, decoration)
VALUES      
	(12, 'портокал, мед, сода', 'резен портокал'),   
	(124, 'лимон, мед, сода, мента', 'резен лимон'),
	(13, 'гренадин, сода, сок портокал', 'резен портокал или коктейлни черешки'),
	(14, 'кафява захар, лайм, сода, листа мента', 'листа мента или резен лайм'),
	(15, 'фреш боровинка, фреш ябълка, розмарин, вода', 'стрък розмарин'),
	(119, 'кафява захар, лайм, сода, листа мента, ром', 'листа мента или резен лайм'),
	(120, 'лимонов сок, текила, портокалов ликьор', 'венец от сол и резен лимон'),
	(121, 'ром, кока кола, сок от лайм', 'резен лайм'),
	(122, 'водка, сок от боровинка, лимонов сок, портокалов ликьор', 'кора от портокал');   

#INSERT wines specifications
INSERT INTO wines (drink_id, color, typeOfGrape, winery, year, country)
VALUES      
    (125, 'бяло', 'шардоне, совиньон блан, вионие', 'Костра Рубра', 2011, 'България'),     
    (126, 'бяло', 'шардоне', 'Александра естейт', 2011, 'България'),
    (127, 'бяло', 'траминер, враччански мискет', 'Винарна къща Русе', 2012, 'България'),
    (128, 'розе', NULL, 'Беса Валей', 2015, 'България'),
    (129, 'розе', NULL, 'Тера Тангра', 2016, 'България'),
    (130, 'розе', 'каберне совиньон, пино ноар, мавруд', 'Санта Сара', 2016, 'България'),
    (131, 'червено', 'каберне совиньон, санджовезе', 'Коста Рубра', 2013, 'България'),
    (132, 'червено', 'пино ноар', 'Едоардо Миролио', 2015, 'България'),
    (133, 'червено', 'шардоне', 'Ню Блум', 2013, 'България'),
    (134, 'бяло', 'шардоне, совиньон блан', 'Лавей Фарм', 2013, 'Франция'),
    (135, 'бяло', 'траминер, совиньон блан', 'Лавей Фарм', 2013, 'Франция'),
    (136, 'бяло', 'шардоне', 'Гейсън Естейт', 2013, 'Нова Зеландия'),
    (137, 'розе', NULL, NULL, 2014, 'Франция'),
    (138, 'розе', NULL, NULL, 2014, 'Испания'),
    (139, 'розе', NULL, NULL, 2016, 'Франция'),
    (140, 'червено', 'каберне совиньон', NULL, 2016, 'Испания'),
    (141, 'червено', 'пинот гриджо', NULL, 2016, 'Нова Зеландия'),
    (142, 'червено', 'мавруд', 'Лавей Фарм', 2016, 'Франция'),
    (143, 'розе', NULL, 'Тера Тангра', 2016, 'България'),  
    (144, 'червено', 'мавруд', 'Лавей Фарм', 2015, 'Франция'),
    (145, 'бяло', 'шардоне', 'Гейсън Естейт', 2014, 'Нова Зеландия'),
    (146, 'розе', NULL, NULL, 2015, 'Франция');

INSERT INTO orders (numOfTable, numOfClients, waiter_id)
VALUES
	(1, 2, 1),
	(2, 1, 1);
    
#INSERT foods for table 1
INSERT INTO order_food (order_id, food_id, order_time, comments)
VALUES
    (1, 65, now(), 'Едната шопска салата да е без сирене'),
    (1, 65, now(), NULL),
    (1, 66, now(), NULL),
    (1, 75, now(), NULL),
    (1, 80, now(), NULL),
    (1, 82, now(), NULL),
    (1, 95, now(), NULL),
    (1, 153, now(), NULL),
    (1, 120, now(), NULL),
    (1, 123, now(), NULL),
    (1, 123, now(), NULL);

/* INSERT drinks for table 1 */
INSERT INTO order_drink (order_id, drink_id, order_time, comments)
VALUES
    (1, 6, now(), 'Колите да са с лед и лимон'),
    (1, 6, now(), NULL),
    (1, 8, now(), NULL),
    (1, 125, now(), NULL);

/* INSERT foods for table 2 */
INSERT INTO order_food (order_id, food_id, order_time, comments)
VALUES
    (2, 69, now(), 'Без кротони, с повече сос'),
    (2, 77, now(), 'По-препържени'),
    (2, 104, now(), NULL),
    (2, 120, now(), 'Без банан');
    
/* INSERT drinks for table 2 */
INSERT INTO order_drink (order_id, drink_id, order_time)
VALUES
    (2, 19, now()),
    (2, 19, now());
    
INSERT INTO order_drink (order_id, drink_id, order_time)
VALUES
	(2, 20, now());

#1.задача
#Извежда всички алкохолни коктейли
SELECT name, volume AS ml, price
FROM drinks
WHERE type = 'коктейли' AND isAlcoholic = 'yes';    

#2. задача
/*Извежда всички храни и напитки за дадена маса, показва за всеки един от продуктите 
	по колко пъти е поръчан, в колко часа и коментарите към всеки продукт от поръчката*/
(SELECT order_id AS NumberOfTable, name AS NameOfFoodsAndDrinks, 
	count(food_id) AS HowManyTimes, order_time AS OrderTime, comments AS Comments
FROM order_food JOIN foods
ON food_id = foods.id
JOIN orders
ON orders.numOfTable = order_food.order_id
WHERE order_id = 1
GROUP BY food_id)
UNION
(SELECT order_id AS NumberOfTable, name AS NameOfFoodsAndDrinks, 
	count(drink_id) AS HowManyTimes, order_time AS OrderTime, comments AS Comments
FROM order_drink JOIN drinks
ON drink_id = drinks.id
JOIN orders
ON orders.numOfTable = order_drink.order_id
WHERE order_id = 1
GROUP BY drink_id) 
ORDER BY NumberOfTable ASC;

#3. задача
#Извежда всички вина; INNER JOIN
SELECT name, volume AS ml, price, color, typeOfGrape, winery, year, country 
FROM drinks JOIN wines
ON drinks.id = wines.drink_id;

#4. задача
#Извежда всички сервитьори, дори те да нямат маси, които да обслужват; OUTTER JOIN
SELECT numOfTable, name
FROM orders
RIGHT JOIN waiters
ON waiter_id = waiters.id;    

#5. задача
#Извежда цялата сметка на конкретна маса
SELECT numOfTable AS NumberOfTable, sum(foods_drinks.price) AS FullPrice
FROM orders    
JOIN (
	(SELECT SUM(price) AS price
    FROM foods JOIN order_food
    ON food_id = foods.id
    WHERE order_id = 2)
	UNION
	(SELECT SUM(price) AS price
    FROM drinks JOIN order_drink
    ON drink_id = drinks.id
    WHERE order_id = 2)
) AS foods_drinks
WHERE numOfTable = 2;

#6. задача
/*Извежда всички продукти с определен алерген, подаден като мараметър на процедура,
чрез използване на  курсор; при невалиден или неучастващ в никое ястие алерген, се извежда съобщение */
DELIMITER //
CREATE PROCEDURE foodsWithConcreteAllergen(IN typeAllergen VARCHAR(100))
BEGIN
    DECLARE tempFoodName VARCHAR(100);
    DECLARE tempFoodType VARCHAR(100);
    DECLARE tempFoodWeight DOUBLE;
    DECLARE tempLunchMenu VARCHAR(3);
    DECLARE tempFoodIngredients TEXT;
	DECLARE finished INT; 
    
	DECLARE foodCursor CURSOR FOR
		SELECT name, type, weight, lunchMenu, ingredients
		FROM foods
		WHERE find_in_set(typeAllergen, allergens) != 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    SET finished = 0;
    OPEN foodCursor;
        
    IF((SELECT sum(find_in_set(typeAllergen, allergens)) FROM foods) = 0)
    THEN
		SELECT 'Allergen is incorrect or there is no food with this allergen!' AS result;
	ELSE
		food_loop: 
		WHILE(finished = 0)
		DO	
			FETCH foodCursor INTO tempFoodName, tempFoodType, tempFoodWeight, tempLunchMenu, tempFoodIngredients;
			IF (finished = 1)
			THEN
				LEAVE food_loop;
			END IF;
			SELECT tempFoodName, tempFoodType, tempFoodWeight, tempLunchMenu, tempFoodIngredients;
		END WHILE;	
    END IF;
    CLOSE foodCursor;
    SET finished = 0;
END;
//
DELIMITER ;
CALL foodsWithConcreteAllergen('Яйца и продукти от тях');







    
    
    

