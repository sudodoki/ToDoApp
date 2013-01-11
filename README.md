#Ruby Garage Test Exercise
## www part
On sunny day can be found over [here]:(https://dashboard.dotcloud.com/applications/todoapp/logs)

Using [*github.com/maxatwork/expressjs_template*]:(https://github.com/maxatwork/expressjs_template) with 
[*https://github.com/felixge/node-mysql*]:(https://github.com/felixge/node-mysql) to create proof-of-concept ToDoApp.
*Node* + *ExpressJS* + *Coffeescript* + *Stylus* + *Twitter bootstrap* + *Jade* + assets pipeline + Mocha + Should + Supertest project template.
Feel free to fork.

##SQL task:
Given tables:
tasks (id, name, status, project_id)
projects (id, name)
Write the queries for:
get all statuses, not repeating, alphabetically ordered
'''sql
SELECT DISTINCT status FROM tasks ORDER BY status;
'''
get the count of all tasks in each project, order by tasks count descending
SELECT COUNT(*) AS amount FROM tasks GROUP BY project_id ORDER BY amount DESC;

get the count of all tasks in each project, order by projects names
SELECT COUNT(*) AS amount, projects.name FROM tasks INNER JOIN projects ON project_id = projects.id GROUP BY projects.name ORDER BY projects.name ASC;

get the tasks for all projects having the name beginning with “N” letter
SELECT * FROM tasks WHERE name like 'N%';

get the list of all projects containing the ‘a’ letter in the middle of the name, and show the
tasks count near each project. Mention that there can exist projects without tasks and
tasks with project_id=NULL
SELECT projects.name, COUNT(tasks.id) FROM projects RIGHT JOIN tasks ON projects.id = project_id WHERE projects.name LIKE '_%o%_' GROUP BY projects.name;

get the list of tasks with duplicate names. Order alphabetically
SELECT tasks.name, tasks.id FROM tasks INNER JOIN (SELECT id, name FROM tasks GROUP BY name HAVING count(id) > 1) dup  ON tasks.name = dup.name ORDER BY tasks.name ;

get the list of tasks having several exact matches of both name and status, from the
project ‘Garage’. Order by matches count
SELECT tasks.name, tasks.id, tasks.status FROM tasks INNER JOIN (SELECT id, status, name FROM tasks GROUP BY status HAVING count(id) > 1) dup ON tasks.status = dup.status WHERE project_id = (SELECT id FROM projects WHERE name = 'GARAGE') ORDER BY tasks.name;

get the list of project names having more than 10 tasks in status ‘completed’. Order by
project_id
SELECT projects.name, COUNT(tasks.id) as count FROM projects RIGHT JOIN tasks ON projects.id = tasks.project_id WHERE tasks.status = 'completed' GROUP BY projects.name HAVING count > 10 ORDER BY projects.id;
