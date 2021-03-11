import pyodbc
import interface

"""

 *************NOT FULLY IMPLEMENTED**************
 
# table contents in sql server -

use db_username;
 
CREATE TABLE users(
        userId int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
        username VARCHAR(50) NOT NULL
);
"""

dbconn = pyodbc.connect('Driver={ODBC Driver 17 for SQL Server};'
                        'Server=DESKTOP-9B83AMH;'
                        'Database =db_username;'
                        'Trusted_Connection=yes;')

cursor = dbconn.cursor()

cursor.execute('SELECT * from db_username.dbo.users')

for row in cursor:
    print(row)

dbconn.commit()
dbconn.close()
