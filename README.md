# WebExample1

This project consists of a simple registration application to demonstrate the integration of the following tools:

- [WD Web Libraries (v2.0.3)](https://github.com/wdonadelli/wd);
- [PHP/SQLite Interaction System Via Web Request (v1.0.0)](https://github.com/wdonadelli/PSWrequest); and
- [SQLite Structure Builder in XML Notation (v2.0.0)](https://github.com/wdonadelli/XSQLite).

The app has a table for recording customer data, another table for recording product data and a third table for recording product sales to customers. The app was called "My Sales".

The tables were built using the XML structure contained in the [mySales.xml](https://github.com/wdonadelli/WebExample1/objects/mySales.xml) file that resulted in the (mySales.sql)[https://github.com/wdonadelli/WebExample1/objects/mySales.sql] file (see [XSQLite](https://github.com/wdonadelli/XSQLite)), no improvements were made to SQL statements.

The SQL statements were compiled using the sqlite3 package for Ubuntu (*Linux wd 4.15.0-72-generic #81-Ubuntu SMP Tue Nov 26 12:20:02 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux*) version *3.22.0-1ubuntu0.2*.

```sh
$ sqlite3 -init mySales.sql
```
For each table the following actions were created:

- data entry;
- data update;
- deletion of data;
- general consultation; and
- change query (log).

Given that the purpose of the application is to demonstrate how the tools work together, there were no extra safety or performance concerns.






