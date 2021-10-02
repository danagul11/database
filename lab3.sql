/*Task1*/
SELECT * from course WHERE credits > 3;
SELECT * FROM classroom WHERE building='Watson' or building='Packard';
SELECT * FROM course WHERE dept_name='Comp. Sci.';
SELECT course_id FROM section WHERE semester='Fall';
SELECT * FROM student WHERE tot_cred>45 and tot_cred<90;
SELECT * FROM student WHERE name like '%a' or name like '%e' or name like '%i' or name like '%o' or name like '%u' or name like '%y';
SELECT * FROM prereq WHERE prereq_id='CS-101';




/*Task2*/
SELECT dept_name, avg (salary)
    FROM instructor
    group by dept_name
    ORDER BY avg(salary);

SELECT building, num FROM (
         SELECT building, count(course_id) as num FROM section
         group by building) sub
WHERE num in (SELECT max(num)
    FROM (SELECT building, count(course_id) as num
         FROM section group by building) sub);

SELECT dept_name , num FROM (
         SELECT dept_name, count(course_id) as num FROM course
         group by dept_name) sub
WHERE num in (SELECT min(num)
    FROM (SELECT dept_name, count(course_id) as num
         FROM course group by dept_name) sub);

SELECT takes.id, student.name
FROM takes, course, student
WHERE course.course_id = takes.course_id and course.dept_name = 'Comp. Sci.' and student.id = takes.id
group by 1,2
having count(*)>3;

SELECT name, dept_name FROM instructor
    WHERE dept_name = 'Biology' or dept_name = 'Music' or dept_name = 'Philosophy';

SELECT id FROM teaches WHERE year = 2018 and
      id not in (SELECT id FROM teaches WHERE year= 2017);




/*Task 3*/
SELECT name,grade FROM takes, student
WHERE dept_name='Comp. Sci.' and (grade='A' or grade='A-')
order by name;

SELECT i_id FROM advisor WHERE s_id NOT in (
    select id from takes where NOT grade LIKE 'A%' and NOT grade LIKE 'B%' );

SELECT dept_name FROM department
WHERE dept_name NOT in (
    SELECT dept_name FROM student WHERE id in (
        SELECT id FROM takes WHERE grade='F' or grade='C'));

SELECT name FROM instructor
WHERE id NOT in (
    SELECT  id FROM teaches WHERE course_id in (
        SELECT course_id FROM takes WHERE grade = 'A'));

SELECT title FROM course WHERE course_id not in (
    SELECT  course_id FROM section WHERE time_slot_id in (
        SELECT distinct time_slot_id FROM time_slot WHERE (end_hr=13 and end_min>1) OR end_hr>13));