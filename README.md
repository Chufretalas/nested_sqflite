# nested_sqflite - V2.0
This is my test of making two sqlite tables interact with each other using sqflite.  
In this case an "activity" is created and each activity refers to a table of it's own were dates can be stored.  
  
## Changes   
The first big change is that the database structure makes some sense now. Before, an whole new database would be created everytime an activity was created, this was bad, so I changed it to have a single database for dates, where just a new table is created for each activity's dates. I maybe could have done all this in the activities db, but I wanted to have something separate for the dates.  
Other than that, I put some async await's in functions where there were async functions before setState's, this makes sure all setState's work properly. There were also some small changes to the UI, but this really isn't the focus of this project.