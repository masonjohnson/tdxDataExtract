# TDx Data Extract
Tools for extracting data from 
This repo has PowerShell scripts intended to pull data from [TeamDynamix](https://teamdynamix.com) \(TDx\) and insert that data into a MySQL database. They are in need of some "refinement," so please feel free to contribute feedback or other improvements.

## Helpful Links
[TeamDynamix API Documentation](https://app.teamdynamix.com/TDWebApi/)

## Prerequisites
- [cURL for Windows](https://curl.haxx.se/download.html)\*
- [MySQL .NET Connector](https://dev.mysql.com/downloads/connector/net/)

### Before you start:
\*These scripts rely on cURL to make the API calls to TDx instead of PowerShell's built-in functions. When I initially wrote these scripts, I was having problems getting PowerShell's functions to work correctly, and cURL was much simpler.
Follow the link above, and download Windows 64 bit \(or 32 bit\) binary package \(not cygwin, unless you're a cygwin user\).

This has not been tested on PowerShell Core, only Windows PowerShell.

## Getting Started
### Set up MySQL
- Create a database on your MySQL host. This will be the database that will store all of your TeamDynamix data.
- Run the `tdxData.sql` file to create the necessary tables, attributes, and relationships
  - If you chose to rename tables, note them for the connection settings section below
  - If you only want to extract certain portions of data from TeamDynamix, you can edit the tdxData.sql file suit your needs. Otherwise, you can run the file as is, and drop any unwanted tables afterwards.
- Create a service account that has permissions to at least select, insert, update, and delete on that database

### Add your connection settings
Edit the connectionSettings.ps1 file:
- Set `$curlExe` to the location of your cURL executable. 
  - You may want to add cURL to the PATH environment variable, in which case you would set you would set `$curlEXE` to `$curlExe = ($env:CURLDIR + "\curl.exe")`
- Set `$tdBEID` to your Web Services BEID from TeamDynamix
- Set `$tdWebServicesKey` to your Web Services Key from TeamDynamix
- Set `$mySQLHost` to your MySQL server name
- Set `$mySQLUsername` to your MySQL username
  (This should be the service account)
- Set `$mySQLPassword` to your MySQL password
- Set `$mySQLDatabase` to your MySQL database
  - \(Optional\) If you changed the table names, be sure to edit the rest of the table variables. Otherwise, leave them as is.
- Set `$ticketingAppID` to your TeamDynamix Ticketing App ID
  - If you have more than one ticketing app, you can create variables for each one, and add them all to the `$appIDs` list, i.e. -> `$appIDs = @($ticketAppA, $ticketAppB, $ticketAppC)`
- Be sure to save your changes!


### INITAL SETUP: Run the scripts
- The tables have relationships that necessitate running certain ones first, before running the rest
  - This also gives you an opportunity to test
- The primary relationship that most tables have in common is with the `users` table
- Run the `Users.ps1` script first to get your users extracted first
  - Due to dependencies of users on each other, you will likely need to run this a few times in order to get all of your users exported the first time.
  - This should not be an ongoing issue, and is really only necessary when you are first setting the extract up.
- Once your users are exported, you can run `TimeTypes.ps1`, then `Tickets.ps1`, and so forth


### Set up your scheduled tasks
- Set up a scheduled task for each of the data extract files you're planning to run
  - My advice would be to set these up to run with a service account as well
- Trigger
  - Pick a daily/weekly/monthly/etc. trigger for later in the day or evening
  - My suggestion would be around 9pm or later, as some of the scripts can take awhile to run
- Action
  - Create an action to "Start a program"
  - In the "Program/Script" box, enter the path to PowerShell, NOT to your script
    - Example: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
  - Under "Add Arguments," enter `-ExecutionPolicy bypass -command "<path_to_your_script"`
    - Example: `-ExecutionPolicy bypass -command "C:\TeamDynamix\DataExtract\TimeEntries.ps1"
  - Under "Start in," enter `<path_to_your_script_directory`
    - Example: `C:\TeamDynamix\DataExtract`


### Troubleshooting
- Each script outputs to a log file to `\Logs` each time it runs
  - Example: `C:\TeamDynamix\DataExtract\Logs\Tickets_2019_05_01.log`
  - Note that as of September 2019, these log files are kept indefinitely. You will likely want to clean them up periodically so they don't get out of hand.
  - One other thing to consider with these files: due to the way they are created, there can only be one per day
    - This shouldn't be an issue when running these scripts as scheduled tasks as they should only be run once per day, but during testing you will likely want to remove them.
    
