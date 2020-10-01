CREATE TABLE supplier_s (
 id VARCHAR(5),
 name_p VARCHAR(30),
 status INT(5),
 city VARCHAR(30),
 PRIMARY KEY(id)
 );
  
INSERT INTO supplier_s (id, name_p, status, city)
VALUES ('П1', 'Петров', 20,	'Москва'),
       ('П2', 'Синицин', 10, 'Таллинн'),
       ('П3', 'Федоров', 30, 'Таллинн'),
       ('П4', 'Чаянов',	20,	'Минск'),
       ('П5', 'Крюков',	30,	'Киев');
	   
CREATE TABLE detail_p (
 id VARCHAR(5),
 name_d VARCHAR(30),
 color VARCHAR(30),
 size INT(5),
 city VARCHAR(30),
 PRIMARY KEY(id)
 );

INSERT INTO detail_p (id, name_d, color, size, city)
VALUES ('Д1', 'Болт', 'Красный', 12, 'Москва'),
       ('Д2', 'Гайка', 'Зеленая', 17, 'Минск'),
       ('Д3', 'Диск', 'Черный',	17,	'Вильнюс'),
       ('Д4', 'Диск', 'Черный',	14,	'Москва'),
       ('Д5', 'Корпус',	'Красный', 12, 'Минск'),
       ('Д6', 'Крышки',	'Красный', 19, 'Москва');
	   
CREATE TABLE project_j (
id VARCHAR(5),
name_pr VARCHAR(30),
city VARCHAR(30),
PRIMARY KEY(id)
);

INSERT INTO project_j (id, name_pr, city)
VALUES ('ПР1', 'ИПР1', 'Минск'),
       ('ПР2', 'ИПР2', 'Таллинн'),
       ('ПР3', 'ИПР3', 'Псков'),
       ('ПР4', 'ИПР4', 'Псков'),
       ('ПР5', 'ИПР4', 'Москва'),
	   ('ПР6', 'ИПР6', 'Саратов'),
       ('ПР7', 'ИПР7', 'Москва');
	   
CREATE TABLE amount_of_details (
supplier_id VARCHAR(5) REFERENCES suppliers_s(id),
detail_id VARCHAR(5) REFERENCES details_p(id),
project_id VARCHAR(5) REFERENCES projects_pr(id),
amount INT(5),
PRIMARY KEY (supplier_id, detail_id, project_id)
);

INSERT INTO amount_of_details (supplier_id, detail_id, project_id, amount)
VALUES ('П1', 'Д1',	'ПР1', 200),
	   ('П1', 'Д1',	'ПР2', 700),
       ('П2', 'Д3',	'ПР1', 400),
       ('П2', 'Д2',	'ПР2', 200),
       ('П2', 'Д3',	'ПР3', 200),
       ('П2', 'Д3',	'ПР4', 500),
       ('П2', 'Д3',	'ПР5', 600),
       ('П2', 'Д3',	'ПР6', 400),
       ('П2', 'Д3',	'ПР7', 800),
       ('П2', 'Д5',	'ПР2', 100),
       ('П3', 'Д3',	'ПР1', 200),
       ('П3', 'Д4',	'ПР2', 500),
       ('П4', 'Д6',	'ПР3', 300),
       ('П4', 'Д6',	'ПР7', 300),
       ('П5', 'Д2',	'ПР2', 200),
       ('П5', 'Д2',	'ПР4', 100),
       ('П5', 'Д5',	'ПР5', 500),
       ('П5', 'Д5',	'ПР7', 100),
       ('П5', 'Д6',	'ПР2', 200),
       ('П5', 'Д1',	'ПР2', 100),
       ('П5', 'Д3',	'ПР4', 200),
       ('П5', 'Д4',	'ПР4', 800),
       ('П5', 'Д5',	'ПР4', 400),
       ('П5', 'Д6',	'ПР4', 500);
	   

-- 26
SELECT AVG(amount), project_id FROM amount_of_details GROUP BY project_id
HAVING
AVG(amount) > (SELECT MAX(amount) FROM amount_of_details WHERE project_id = 'ПР1');

-- 17
SELECT detail_id, project_id, amount FROM amount_of_details
ORDER BY project_id;

-- 25
SELECT id FROM project_j
 ORDER BY city LIMIT 1;
 
 -- 8
SELECT DISTINCT supplier_s.id, detail_p.id, project_j.id, supplier_s.city, detail_p.city, project_j.city 
FROM detail_p, supplier_s, project_j
WHERE supplier_s.city <> detail_p.city 
AND supplier_s.city <> project_j.city 
AND detail_p.city <> project_j.city;

-- 2
SELECT * FROM project_j
WHERE city='Лондон';

-- 7
SELECT DISTINCT supplier_s.id, detail_p.id, project_j.id, supplier_s.city, detail_p.city, project_j.city 
FROM detail_p, supplier_s, project_j
WHERE supplier_s.city <> detail_p.city <> project_j.city;

-- 11
SELECT DISTINCT supplier_s.id,  project_j.id, supplier_s.city, project_j.city
FROM amount_of_details
JOIN supplier_s ON amount_of_details.supplier_id = supplier_s.id
JOIN project_j ON amount_of_details.project_id = project_j.id;

-- 35
SELECT DISTINCT s1.supplier_id, s2.detail_id
FROM amount_of_details AS s1, amount_of_details AS s2
GROUP BY s1.supplier_id, s2.detail_id
HAVING s2.detail_id NOT IN (
SELECT s2.detail_id
FROM amount_of_details AS s2
WHERE s1.supplier_id = s2.supplier_id
);

-- 16
SELECT DISTINCT SUM(amount) FROM amount_of_details
WHERE supplier_id='П1' AND detail_id='Д1'

-- 31
SELECT DISTINCT supplier_id FROM amount_of_details
GROUP BY supplier_id
HAVING COUNT(DISTINCT detail_id)<2;