# Tours reservations database
Project is to controll reservations of people to tours.  
  
The names of all databases, variables, functions etc. are in Polish.   
  
The whole project was based on solving task for lab classes.

## About database
DB consist of 4 tables: *Persons* (*Osoby*), *Tours* (*Wycieczki*), *Reservations* (*Rezerwacje*) and *ReservationLog* (*RezerwacjeLog*). Table *Reservations* shows the reservations of the person from *Persons* table for the tour from *Tours* table. *ReservationLog* table logs every change of the *Reservation* table.  
  
There are some views and functions for easier assess to data, some procedures that allow to modify data in tables and triggers.  
  
## Tech used
- [PL/SQL](https://www.tutorialspoint.com/plsql/index.htm)
