import pandas as pd
import numpy as np

ipl_matches = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRy2DUdUbaKx_Co9F0FSnIlyS-8kp4aKv_I0-qzNeghiZHAI_hw94gKG22XTxNJHMFnFVKsO4xWOdIs/pub?gid=1655759976&single=true&output=csv"
matches = pd.read_csv(ipl_matches)

print(matches.head())


def teamsAPI():
    teams = list(set(list(matches['Team1']) + list(matches['Team2'])))
    teams_dict = {
        'teams': teams
    }

    return teams_dict


def players():
    all_team_players = matches.apply(lambda row: eval(row['Team1Players']) + eval(row['Team2Players']), axis=1)
    all_players = set([player for sublist in all_team_players for player in sublist])

    unique_players = sorted(list(all_players))
    return {"unique_players": unique_players}


def teamVsteamAPI(team1, team2):
    valid_teams = list(set(list(matches['Team1']) + list(matches['Team2'])))

    if team1 in valid_teams and team2 in valid_teams:
        temp_df = matches[(matches['Team1'] == team1) & (matches['Team2'] == team2) | (matches['Team1'] == team2) & (
                matches['Team2'] == team1)]
        total_matches = temp_df.shape[0]

        matches_won_team1 = temp_df['WinningTeam'].value_counts()[team1]
        matches_won_team2 = temp_df['WinningTeam'].value_counts()[team2]

        draws = total_matches - (matches_won_team1 + matches_won_team2)

        response = {
            'total_matches': str(total_matches),
            team1: str(matches_won_team1),
            team2: str(matches_won_team2),
            'draws': str(draws)
        }

        return response

    else:
        return {'message': 'Invalid team name'}
