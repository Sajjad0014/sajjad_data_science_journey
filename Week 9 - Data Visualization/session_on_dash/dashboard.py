import dash
import pandas as pd
import plotly.graph_objs as go
import plotly.express as px
from dash import html
from dash import dcc

data = px.data.gapminder()

# print(data.head())

app = dash.Dash()

# app.layout = html.H1(children="My First Dashboard", style={'color': '#dc3da2', 'text-align': 'center'})
app.layout = html.Div([
    html.Div(children=[
        html.H1('My First Dashboard', style={'color': '#b51c76', 'text-align': 'center'})
    ], style={'border': '1px black solid', 'float': 'left', 'width': '100%', 'height': '50px'}),
    html.Div(children=[
        dcc.Graph(id='scatter-plot',
                  figure={'data': [go.Scatter(x=data['pop'],
                                              y=data['gdpPercap'],
                                              mode='markers')],
                          'layout': go.Layout(title='Scatter Plot')})
    ], style={'border': '1px black solid', 'float': 'left', 'width': '49.5%'}),
    html.Div(children=[
        dcc.Graph(id='box-plot',
                  figure={'data': [go.Box(x=data['gdpPercap'])],
                          'layout':go.Layout(title='Box Plot')})
    ],style={'border': '1px black solid', 'float': 'left', 'width': '49.5%'})
])

if __name__ == '__main__':
    app.run_server()
