"""
 Flask REST application

"""

from flask import Flask, request, jsonify, make_response
from models import Database

# ==========
#  Settings
# ==========

app = Flask(__name__)
app.config['STATIC_URL_PATH'] = '/static'
app.config['DEBUG'] = True

# ==========
#  Database
# ==========

# Creates an sqlite database in memory
db = Database(filename=':memory:', schema='schema.sql')
db.recreate()


# ===========
#  Web views
# ===========

@app.route('/')
def index():
    return app.send_static_file('index.html')


# ===========
#  API views
# ===========
'''
# FOR TESTING ONLY
# Will return all users in the database
# IMPORTANT: if left un-commented, it will "override" the user_detail() method

@app.route('/api/user/', methods=['GET'])
def get_users():
    """
    Returns all users.

    """

    query = db.execute_query(f'SELECT * FROM user').fetchall()
    if request.method == 'GET':
        userList = query
        return make_response(jsonify(userList), 200)
'''


@app.route('/api/user/register/', methods=['POST'])
def user_register():
    """
    Registers a new user.
    Does not require authorization.

    """

    usernames = []
    if request.method == 'POST':
        req = request.get_json()
        user_query = db.execute_query(f'SELECT username FROM user')
        for row in user_query:
            names = "{Name}".format(Name=row['username'])
            usernames.append(names)
        if req['username'] not in usernames:
            query = db.execute_query(f"INSERT INTO user VALUES (null,'%s', '%s', '%s', '%s')" % (req['name'],
                                                                                                 req['email'],
                                                                                                 req['username'],
                                                                                                 req['password']))
            return make_response(jsonify(req), 201)
        else:
            error = "Username is already taken."
            return make_response(jsonify(error), 405)
    else:
        return make_response(jsonify(), 400)


@app.route('/api/user/', methods=['GET', 'PUT'])
def user_detail():
    """
    Returns or updates current user.
    Requires authorization.

    """
    query = db.execute_query(f'SELECT * FROM user WHERE username=? AND password=?', (
        request.authorization.username,
        request.authorization.password,
    )).fetchone()

    if request.authorization.username == "no-user" and request.authorization.password == "no-password" \
            or not request.authorization.username and not request.authorization.password:
        return make_response(jsonify(), 403)

    if request.authorization.type == "basic":
        if request.method == "GET":
            return make_response(jsonify(query), 200)
        elif request.method == "PUT":
            req = request.get_json()
            query = db.execute_query(
                f"UPDATE user SET name='%s',email='%s',username='%s',password='%s' WHERE id='%s'" % (
                    req['name'],
                    req['email'],
                    req['username'],
                    req['password'],
                    req['id']))
            return make_response(jsonify(), 201)
        else:
            return make_response(jsonify(), 404)

    else:
        error = "Username and/or password missing. Authentication required"
        return make_response(jsonify(error), 403)


@app.route('/api/projects/', methods=['GET', 'POST'])
def project_list():
    """
    Project list.
    Requires authorization.

    """
    if request.authorization.type == "basic":
        if request.method == 'GET':
            projects = db.execute_query('SELECT * FROM project').fetchall()
            return make_response(jsonify(projects), 200)
        elif request.method == 'POST':
            req = request.get_json()
            query = db.execute_query(f"INSERT INTO project VALUES (null,'%s', '%s', '%s', '%s')" %
                                     (req['user_id'],
                                      req['title'],
                                      req['creation_date'],
                                      req['last_updated']))
            return make_response(jsonify(req), 201)
        else:
            return make_response(jsonify(), 404)
    else:
        return make_response(jsonify(), 401)


@app.route('/api/projects/<int:pk>/', methods=['GET', 'PUT', 'DELETE'])
def project_detail(pk):
    """
    Project detail.
    Requires authorization.

    """
    if request.authorization.type == "basic":
        if request.method == 'GET':
            project = db.execute_query('SELECT * FROM project WHERE id=?', (pk,)).fetchone()
            return make_response(jsonify(project), 200)
        elif request.method == 'PUT':
            req = request.get_json()
            project = db.execute_query(
                f"UPDATE project SET user_id='%s',title='%s',creation_date='%s',last_updated='%s'"
                f" WHERE id=?" % (
                    req['user_id'], req['title'], req['creation_date'], req['last_updated']),
                (pk,)).fetchone()
            return make_response(jsonify(req), 201)
        elif request.method == 'DELETE':
            project = db.execute_query(f'DELETE FROM project WHERE id=?', (pk,)).fetchone()
            return make_response(jsonify(), 200)
        else:
            return make_response(jsonify(), 404)
    else:
        return make_response(jsonify(), 401)


@app.route('/api/projects/<int:pk>/tasks/', methods=['GET', 'POST'])
def task_list(pk):
    """
    Task list.
    Requires authorization.

    """
    if request.authorization.type == "basic":
        if request.method == 'GET':
            tasks = db.execute_query('SELECT * FROM task WHERE project_id=?', (pk,)).fetchall()
            return make_response(jsonify(tasks))
        elif request.method == 'POST':
            req = request.get_json()
            tasks = db.execute_query(f"INSERT INTO task VALUES (null,'%s', '%s', '%s', '%s')" %
                                     (pk,
                                      req['title'],
                                      req['creation_date'],
                                      req['completed']))
            return make_response(jsonify(), 201)
        else:
            return make_response(jsonify(), 404)
    else:
        return make_response(jsonify(), 401)


@app.route('/api/projects/<int:pk>/tasks/<int:task_pk>/', methods=['GET', 'PUT', 'DELETE'])
def task_detail(pk, task_pk):
    """
    Task detail.
    Requires authorization.

    """
    if request.authorization.type == "basic":
        if request.method == 'GET':
            task = db.execute_query('SELECT * FROM task WHERE project_id=? and id=?', (pk, task_pk)).fetchone()
            return make_response(jsonify(task), 200)
        elif request.method == 'PUT':
            req = request.get_json()
            task = db.execute_query(f"UPDATE task SET project_id=?,title='%s',creation_date='%s',completed='%s'"
                                    f" WHERE project_id=? AND id=?" % (
                                        req['title'], req['creation_date'], req['completed']),
                                    (pk, pk, task_pk)).fetchone()
            return make_response(jsonify(), 201)
        elif request.method == "DELETE":
            task = db.execute_query(f'DELETE FROM task WHERE project_id=? AND id=?', (pk, task_pk)).fetchone()
            return make_response(jsonify(), 200)
        else:
            return make_response(jsonify(), 404)
    else:
        return make_response(jsonify(), 401)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)
