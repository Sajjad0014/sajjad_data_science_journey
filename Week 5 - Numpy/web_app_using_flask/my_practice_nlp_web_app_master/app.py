import json
from flask import Flask, render_template, request, redirect
from db import Database
import api

# flask runs on Server, and HTML and CSS files are sent to client
# Render template is function that loads HTML files and displays to the user
# request is to receive the data from any html file. in our case register.html and other html files

# Creating an object of flask
app = Flask(__name__)

dbo = Database()


# basically creating a URL
# / is the triggering point
@app.route('/')
def index():
    return render_template("login.html")


@app.route('/register')
def register():
    return render_template('register.html')


@app.route('/perform_registration', methods=['post'])
def perform_registration():
    name = request.form.get('user_ka_name')
    email = request.form.get('user_ka_email')
    password = request.form.get('user_ka_password')

    response = dbo.insert(name, email, password)

    if response:
        return render_template('login.html', message='Registration successful. Kindly login to proceed')
    else:
        return render_template('register.html', message="Email already exists")


@app.route('/perform_login', methods=["post"])
def perform_login():
    email = request.form.get('user_ka_email')
    password = request.form.get('user_ka_password')

    response = dbo.search(email, password)

    if response:
        return redirect('/profile')
    else:
        return render_template('login.html', message="Incorrect email/password")


@app.route('/profile')
def profile():
    return render_template("profile.html")


@app.route('/ner')
def ner():
    return render_template("ner.html")


@app.route('/perform_ner', methods=["post"])
def perform_ner():
    text = request.form.get('ner_text')
    # response = api.ner(text)
    with open('output.json', 'r') as rf:
        response = json.load(rf)

    return render_template("ner.html", response=response)


# debug = True means it will run automatically
app.run(debug=True)
