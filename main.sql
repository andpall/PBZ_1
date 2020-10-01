CREATE DATABASE lab1;
USE lab1;
CREATE TABLE teacher(
id VARCHAR(5),
lastname VARCHAR (20),
position VARCHAR (20),
department VARCHAR (50),
specialty VARCHAR (50),
homephone INT (5),
PRIMARY KEY (id)
);
INSERT INTO teacher (id, lastname, position, department, specialty, homephone) VALUES('221Л', 'Фролов', 'Доцент', 'ЭВМ', 'АСОИ, ЭВМ', 487),
('222Л', 'Костин',	'Доцент', 'ЭВМ', 'ЭВМ',	543),
('225Л', 'Бойко', 'Профессор', 'АСУ', 'АСОИ, ЭВМ', 112),
('430Л', 'Глазов', 'Ассистент', 'ТФ', 'СД', 421),
('110Л', 'Петров', 'Ассистент', 'Экономики', 'Международная экономика', 324);
CREATE TABLE subject(
subjectID VARCHAR(5),
subjectName VARCHAR (20),
hours INT (5),
specialty VARCHAR (50),
semester INT (5)
);
INSERT INTO subject (subjectID, subjectName, hours, specialty, semester) 
VALUES('12П', 'Мини ЭВМ', 36, 'ЭВМ', 1),
('14П', 'ПЭВМ',	72,	'ЭВМ', 2),
('17П',	'СУБД ПК',	48,	'АСОИ',	4),
('18П',	'ВКСС',	52,	'АСОИ',	6),
('34П',	'Физика',	30,	'СД',	6),
('22П',	'Аудит',	24,	'Бухучета',	3);
CREATE TABLE subject(
subjectID VARCHAR(5),
subjectName VARCHAR (20),
hours INT (5),
specialty VARCHAR (50),
semester INT (5)
);
CREATE TABLE student_group (
 groupID VARCHAR(5),
 group_name VARCHAR(50),
 amount INT(5),
 specialty VARCHAR(50),
 headman_lastname VARCHAR(50)
 );
INSERT INTO student_group (groupID, group_name, amount, specialty, headman_lastname)
VALUES ('8Г', 'Э-12', 18, 'ЭВМ', 'Иванова'),
       ('7Г', 'Э-15', 22, 'ЭВМ', 'Сеткин'),
       ('4Г', 'АС-9', 24, 'АСОИ', 'Балабанов'),
       ('3Г', 'АС-8', 20, 'АСОИ', 'Чижов'),
       ('17Г', 'С-14', 29, 'СД', 'Амросов'),
       ('12Г', 'М-6', 16, 'Международная экономика', 'Трубин'),
       ('10Г', 'Б-4', 21, 'Бухучет', 'Зязюткин');
CREATE TABLE teacher_student_group (
 groupID VARCHAR(5),
 subjectID VARCHAR(5),
 id VARCHAR(5),
 audience_number INT(5)
 );
INSERT INTO teacher_student_group (groupID, subjectID, ID, audience_number)
VALUES ('8Г', '12П', '222Л', 112),
	   ('8Г', '14П', '221Л', 220),
       ('8Г', '17П', '222Л', 112),
       ('7Г', '14П', '221Л', 220),
       ('7Г', '17П', '222Л', 241),
       ('7Г', '18П', '225Л', 210),
       ('4Г', '12П', '222Л', 112),
	   ('4Г', '18П', '225Л', 210),
       ('3Г', '12П', '222Л', 112),
       ('3Г', '17П', '221Л', 241),
       ('3Г', '18П', '225Л', 210),
	   ('17Г', '12П', '222Л', 112),
       ('17Г', '22П', '110Л', 220),
       ('17Г', '34П', '430Л', 118),
       ('12Г', '12П', '222Л', 112),
	   ('12Г', '22П', '110Л', 210),
       ('10Г', '12П', '222Л', 210),
       ('10Г', '22П', '110Л', 210);
SELECT * FROM teacher;

SELECT * FROM student_group WHERE specialty = 'ЭВМ';

SELECT id, audience_number  FROM teacher_student_group WHERE subjectID = '18П';

SELECT DISTINCT subject.subjectID, subject.subjectName FROM teacher_student_group
JOIN teacher ON teacher.id = teacher_student_group.id
JOIN subject ON subject.subjectID = teacher_student_group.subjectID
WHERE lastname = 'Костин';

SELECT DISTINCT teacher_student_group.groupID FROM student_group
JOIN teacher_student_group ON teacher_student_group.groupID = student_group.groupID
JOIN teacher ON teacher_student_group.id = teacher.id
WHERE teacher.lastname = 'Фролов';

SELECT * FROM subject WHERE specialty = 'АСОИ';

SELECT * FROM teacher WHERE specialty LIKE '%АСОИ%';

SELECT DISTINCT teacher.lastname FROM teacher
JOIN teacher_student_group ON teacher_student_group.id = teacher.id
WHERE teacher_student_group.audience_number = 210;

SELECT subject.subjectName, student_group.group_name FROM teacher_student_group
JOIN subject ON subject.subjectID = teacher_student_group.subjectID
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE audience_number BETWEEN 100 AND 200;

SELECT DISTINCT s1.groupID, s2.groupID
FROM student_group AS s1, student_group AS s2
WHERE s1.specialty = s2.specialty AND s1.groupID <> s2.groupID;

SELECT SUM(amount) FROM student_group 
WHERE specialty = 'ЭВМ';  

SELECT DISTINCT teacher.id FROM teacher
JOIN teacher_student_group ON teacher_student_group.id = teacher.id
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE student_group.specialty = 'ЭВМ';

SELECT DISTINCT subjectID FROM teacher_student_group
GROUP BY subjectID
HAVING count(1) = (SELECT count(1) FROM student_group);

SELECT DISTINCT lastname 
FROM teacher AS t
JOIN teacher_student_group AS tsg ON t.id = tsg.id
WHERE tsg.id IN (
    SELECT DISTINCT teacher_student_group.id 
    FROM teacher_student_group
    WHERE subjectID IN (
        SELECT DISTINCT subjectID
        FROM teacher_student_group
        WHERE id IN (
            SELECT DISTINCT id 
                FROM teacher_student_group
                WHERE subjectID = '14П'
                )
    )
);

SELECT DISTINCT * FROM subject
JOIN teacher_student_group ON teacher_student_group.subjectID = subject.subjectID
WHERE teacher_student_group.id <> '221П';

SELECT DISTINCT * FROM subject
WHERE subject.subjectID NOT IN (
SELECT distinct teacher_student_group.subjectID
FROM teacher_student_group
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE student_group.group_name = 'М-6');

SELECT DISTINCT *
FROM teacher 
WHERE teacher.position = 'Доцент' AND teacher.id IN (
SELECT DISTINCT teacher_student_group.id 
FROM teacher_student_group
WHERE teacher_student_group.groupID IN ('8Г', '3Г')
);

SELECT DISTINCT teacher_student_group.subjectID,
                teacher_student_group.id,
				teacher_student_group.groupID
FROM teacher_student_group
JOIN teacher ON teacher.id = teacher_student_group.id
WHERE teacher.department = 'ЭВМ' AND teacher.specialty LIKE '%АСОИ%';

SELECT DISTINCT student_group.groupID
FROM student_group
JOIN teacher_student_group ON teacher_student_group.groupID = student_group.groupID
JOIN teacher ON teacher.id = teacher_student_group.id
WHERE student_group.specialty = teacher.specialty;

SELECT DISTINCT teacher.id
FROM teacher
JOIN teacher_student_group ON teacher_student_group.id = teacher.id
JOIN subject ON subject.subjectID = teacher_student_group.subjectID
WHERE teacher.specialty = 'ЭВМ' AND subject.specialty IN (
SELECT DISTINCT student_group.specialty
FROM student_group);

SELECT DISTINCT student_group.specialty
FROM student_group
JOIN teacher_student_group ON teacher_student_group.groupID = student_group.groupID
JOIN teacher ON teacher.id = teacher_student_group.id
WHERE teacher.department = 'АСУ' AND teacher.specialty REGEXP student_group.specialty;

SELECT DISTINCT subject.subjectID
FROM subject
JOIN teacher_student_group ON teacher_student_group.subjectID = subject.subjectID
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE student_group.group_name = 'АС-8';

SELECT DISTINCT student_group.groupID
FROM student_group
JOIN teacher_student_group ON teacher_student_group.groupID = student_group.groupID
WHERE teacher_student_group.subjectID IN (
SELECT teacher_student_group.subjectID
FROM teacher_student_group
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE student_group.group_name = 'АС-8');

SELECT DISTINCT student_group.groupID
FROM student_group
JOIN teacher_student_group ON teacher_student_group.groupID = student_group.groupID
WHERE teacher_student_group.subjectID NOT IN (
SELECT teacher_student_group.subjectID
FROM teacher_student_group
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE student_group.group_name = 'АС-8');

SELECT DISTINCT groupID
FROM teacher_student_group
WHERE subjectID NOT IN (
SELECT subjectID
FROM teacher_student_group
WHERE id = '430Л');

SELECT DISTINCT id
FROM teacher_student_group
JOIN student_group ON student_group.groupID = teacher_student_group.groupID
WHERE student_group.group_name = 'Э-15' AND subjectID NOT IN (
SELECT subjectID
FROM teacher_student_group
WHERE subjectID = '12П');