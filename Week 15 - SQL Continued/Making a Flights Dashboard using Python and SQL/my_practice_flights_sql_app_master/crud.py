import mysql.connector

# Connect to the database server
try:
    conn = mysql.connector.connect(
        host='127.0.0.1',
        user='root',
        password='',
        database='indigo'
    )
    my_cursor = conn.cursor()  # used to interact with the sql
    print('Connection Established')
except:
    print('Connection Error')

# Create a database on the db server
# my_cursor.execute("CREATE DATABASE indigo")
# conn.commit()

# After running above code, make changes in the conn = () block of the try block and add database = 'database_name'
# We do comm.commit() whenever we make a write operation


# Create a table
# Airport -> aiport_id | code | name | city
# my_cursor.execute("""
# CREATE TABLE airport(
#     airport_id INTEGER PRIMARY KEY,
#     code VARCHAR(10) NOT NULL,
#     city VARCHAR(50) NOT NULL,
#     name VARCHAR(255) NOT NULL
# )
# """)
# conn.commit()

# Insert data to the table
# my_cursor.execute("""
# INSERT INTO airport VALUES
# (1, 'Del', 'New Delhi', 'IGIA'),
# (2, 'CCU', 'Kolkata', 'NSCA'),
# (3, 'BOM', 'Mumbai', 'CSMA')
# """)
# conn.commit()

# Search/Retrieve
my_cursor.execute("SELECT * FROM indigo.airport WHERE airport_id > 1")
data = my_cursor.fetchall()
print(data)

print('For retrieving the airport names')
for i in data:
    print(i[3])

# Update
# my_cursor.execute("""
# UPDATE airport
# SET city = 'Bombay'
# WHERE airport_id = 3
# """)
# conn.commit()

# Search/Retrieve
my_cursor.execute("SELECT * FROM indigo.airport")
data = my_cursor.fetchall()
print(data)

print('For retrieving the airport names')
for i in data:
    print(i[3])

# DELETE
my_cursor.execute("DELETE FROM airport WHERE airport_id = 3")
conn.commit()
print('Deleted a row')

my_cursor.execute("SELECT * FROM indigo.airport")
data = my_cursor.fetchall()
print(data)
