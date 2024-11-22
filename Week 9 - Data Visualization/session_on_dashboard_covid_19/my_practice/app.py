import dash
import numpy as np
import pandas as pd
import plotly.graph_objs as go
from dash import html
from dash import dcc
from dash.dependencies import Input, Output

# external CSS Stylesheets
# external_stylesheets = [
#     {
#         'href': 'https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css',
#         'rel': 'stylesheet',
#         'integrity': 'sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkF0JwJ8ERdknLPMO',
#         'crossorigin': 'anonymous'
#     }
# ]

external_stylesheets = [
    'https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.2/css/bootstrap.min.css'
]

patients = pd.read_csv('IndividualDetails.csv')

total = patients.current_status.count()
active = patients.query('current_status == "Hospitalized"').shape[0]
recovered = patients.query('current_status == "Recovered"').shape[0]
deaths = patients.query('current_status == "Deceased"').shape[0]

options = [
    {'label': 'All', 'value': 'All'},
    {'label': 'Hospitalized', 'value': 'Hospitalized'},
    {'label': 'Recovered', 'value': 'Recovered'},
    {'label': 'Deceased', 'value': 'Deceased'}
]

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div([
    html.H1("Corona Virus Pandemic", style={'color': 'white', 'text-align': 'center'}),
    html.Div([
        html.Div([
            html.Div([
                html.Div([
                    html.H3('Total Cases', className='card-title text-light'),
                    html.H4(total, className='card-text text-light')
                ], className='card-body')
            ], className='card bg-danger')
        ], className='col-md-3'),
        html.Div([
            html.Div([
                html.Div([
                    html.H3('Active', className='card-title text-light'),
                    html.H4(active, className='card-text text-light')
                ], className='card-body')
            ], className='card bg-info')
        ], className='col-md-3'),
        html.Div([
            html.Div([
                html.Div([
                    html.H3('Recovered', className='card-title text-light'),
                    html.H4(recovered, className='card-text text-light')
                ], className='card-body')
            ], className='card bg-warning')
        ], className='col-md-3'),
        html.Div([
            html.Div([
                html.Div([
                    html.H3('Deaths', className='card-title text-light'),
                    html.H4(deaths, className='card-text text-light')
                ], className='card-body')
            ], className='card bg-success')
        ], className='col-md-3')
    ], className='row'),

    html.Div([], className='row'),

    html.Div([
        html.Div([
            html.Div([
                html.Div([
                    dcc.Dropdown(id='picker', options=options, value='All'),
                    dcc.Graph(id='bar')
                ], className='card-body')
            ], className='card')
        ], className='col-md-12')
    ], className='row')
], className='container')


@app.callback(Output('bar', 'figure'), [Input('picker', 'value')])
def update_graph(type_of_graph):
    if type_of_graph == 'All':
        patient_bar = patients.detected_state.value_counts().reset_index()
        return {'data': [go.Bar(x=patient_bar['detected_state'], y=patient_bar['count'])],
                'layout': go.Layout(title='State Total Count')}
    else:
        no_of_patients = patients[patients['current_status'] == type_of_graph]
        patient_bar = no_of_patients.detected_state.value_counts().reset_index()
        return {'data': [go.Bar(x=patient_bar['detected_state'], y=patient_bar['count'])],
                'layout': go.Layout(title='State Total Count')}


if __name__ == '__main__':
    app.run_server(debug=True)
