from flask import Blueprint, redirect, render_template, request, session, flash
from .database import mysql
import re

auth = Blueprint('auth', __name__)

@auth.route('/login', methods=['GET', 'POST'])
def login():
    msg=''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.get_db().cursor()
        cursor.execute('SELECT * FROM accounts WHERE username = % s AND password = % s', (username, password, ))
        account = cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['id'] = account[0]
            session['username'] = account[1]
            if 'url' in session:
                url = session['url']
                session.pop('url', None)
                return redirect(url)
            return redirect('/')
        else:
            flash("Invalid Username or Password", category="error")
    return render_template("login.html", msg=msg)

@auth.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    return redirect("/")

@auth.route('/register', methods=['GET', 'POST'])
def register():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password1' in request.form and 'password2' in request.form and 'email' in request.form :
        username = request.form['username']
        password1 = request.form['password1']
        password2 = request.form['password2']
        email = request.form['email']
        if password1 == password2:
    
            cursor = mysql.get_db().cursor()
            cursor.execute('SELECT * FROM accounts WHERE username = % s OR email = %s', (username, email, ))
            account = cursor.fetchone()
            if account:
                flash('Account already exists !', category="error")
            elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
                flash('Invalid email address !', category="error")
            elif not re.match(r'[A-Za-z0-9]+', username):
                flash('Username must contain only characters and numbers !', category="error")
            else:
                cursor.execute('INSERT INTO accounts VALUES (NULL, % s, % s, % s)', (username, password1, email, ))
                mysql.get_db().commit()
                flash('You have successfully registered !', category="success")
        else:
            flash("Passwords don't match", category="error")
    elif request.method == 'POST':
        flash('Please fill out the form !', category="error")
    return render_template('register.html')