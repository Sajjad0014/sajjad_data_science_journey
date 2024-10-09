import mysql.connector


class DB:
    def __init__(self):
        # Connect to the database
        try:
            self.conn = mysql.connector.connect(
                host='127.0.0.1',
                user='root',
                password='',
                database='flights'
            )
            self.my_cursor = self.conn.cursor()  # used to interact with the sql
            print('Connection Established')
        except:
            print('Connection Error')

    def fetch_city_name(self):

        city = []

        self.my_cursor.execute("""
        SELECT DISTINCT(Source) FROM flights.flights
        UNION
        SELECT DISTINCT(Destination) FROM flights.flights
        """)

        data = self.my_cursor.fetchall()

        for item in data:
            city.append(item[0])

        return city

    def fetch_all_flights(self, source, destination):
        self.my_cursor.execute("""
        SELECT Airline, Route, Dep_Time, Duration FROM flights.flights
        WHERE Source = '{}' AND Destination = '{}'
        """.format(source, destination))

        data = self.my_cursor.fetchall()

        return data

    def fetch_airline_frequency(self):

        airline = []
        frequency = []
        self.my_cursor.execute("""
        SELECT Airline, COUNT(*) FROM flights
        GROUP BY Airline
        """)

        data = self.my_cursor.fetchall()

        for item in data:
            airline.append(item[0])
            frequency.append(item[1])

        return airline, frequency

    def busy_airport(self):

        city = []
        frequency = []

        self.my_cursor.execute("""
        SELECT Source, COUNT(*) FROM (SELECT Source FROM flights
                                      UNION ALL
                                      SELECT Destination FROM flights) t
        GROUP BY t.Source
        ORDER BY COUNT(*) DESC
        """)

        data = self.my_cursor.fetchall()

        for item in data:
            city.append(item[0])
            frequency.append(item[1])

        return city, frequency

    def daily_frequency(self):

        date = []
        frequency = []

        self.my_cursor.execute("""
        SELECT Date_of_Journey, COUNT(*) FROM flights
        GROUP BY  Date_of_Journey
        """)

        data = self.my_cursor.fetchall()

        for item in data:
            date.append(item[0])
            frequency.append(item[1])

        return date, frequency
