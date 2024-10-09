from flask import Flask, render_template, request
import requests

# The requests is used for calling the api
# On the contrary the request in the flask is a flask method

app = Flask(__name__)


@app.route('/')
def home():
    response = requests.get('http://127.0.0.1:5000/api/teams')
    teams = response.json()['teams']
    return render_template('index.html', teams=sorted(teams))


@app.route('/teamvteam')
def team_vs_team():
    response = requests.get('http://127.0.0.1:5000/api/teams')
    teams = response.json()['teams']

    team1 = request.args.get('team1')
    team2 = request.args.get('team2')
    response = requests.get(f"http://127.0.0.1:5000/api/teamvteam?team1={team1}&team2={team2}")
    response = response.json()

    return render_template('index.html', teams=sorted(teams), result=response)


app.run(debug=True, port=8000)
