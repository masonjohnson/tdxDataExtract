################################################################################
############################# TeamDynamix Settings #############################
################################################################################
## DO NOT CHANGE ANY VARIABLE NAMES IN THIS FILE
## These variables may be used in the data extract scripts.

## Note: Update the CURLDIR environment variable when updating cURL
## You can also add curl to the PATH environment variable
$curlExe = ($env:CURLDIR + "\curl.exe")

########## API variables ##########
$tdBEID = ""
$tdWebServicesKey = ""


## This function gets a new API bearer token from TeamDynamix.
function Get-Token{
   param(
      [String] $beid,
      [String] $webServicesKey
   )
   $url = "https://app.teamdynamix.com/TDWebApi/api/auth/loginadmin"
   
   if ($beid -Like $null){
      $beid = $tdBEID
      $webServicesKey = $tdWebServicesKey
   }

   $body ="{'BEID':'" + $beid + "','WebServicesKey':'" + $webServicesKey + "'}"

   return (& $curlExe --request POST --http1.1 --url $url --header 'content-type: application/json' --data $body)
}


## Get a new Bearer Token for the API call
$tdBearerToken = Get-Token -beid $tdBEID -webServicesKey $tdWebServicesKey


################################################################################
################################ MySQL Settings ################################
################################################################################

## Load the MySQL .NET Connector
[System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

## Database server settings
[string]$mySQLHost = ''
[string]$mySQLUsername = ''
[string]$mySQLPassword = ''
[string]$mySQLDatabase = ''

## Build the database connection string
[string]$connectionString = "server=" + $mySQLHost + ";port=3306;uid=" + $mySQLUsername + ";pwd=" + $mySQLPassword + ";database=" + $mySQLDatabase +";Allow User Variables=True;SslMode=None"

## Initialize a MySQLConnection object. This is used when executing queries.
$mySQLConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)
$Error.Clear()
try{
   $mySQLConnection.Open()
   $connectionStatus = 1
   Write-Output "Connection Successful!"
}
catch{
   write-warning ("Could not open a connection to Database $mySQLDatabase on Host $mySQLHost. Error: "+$Error[0].ToString())
   $connectionStatus = 0
   Write-Output "Connection Failed!"
   exit
}


################################# MySQL Tables #################################
## Table for storing TD Projects
[string]$projectsTable = 'projects'

## Table for storing TD Time Types
[string]$timeTypesTable = 'timetypes'

## Table for storing TD Users
[string]$usersTable = 'users'

## Table for storing TD Time Entries
[string]$timeEntriesTable = 'timeentries'

## Table for storing TD Groups
[string]$groupsTable = 'groups'



############### TD Ticketing Settings ###############
## Table for storing TD Tickets
[string]$ticketsTable = 'tickets'

## Table for storing TD Ticket Attributes
[string]$ticketAttributesTable = 'ticketattributes'

## Table for storing TD Ticket Attribute Choices
[string]$ticketAttributeChoices = 'ticketattribute_choices'

## Table for storing TD Ticket Attribute Links
[string]$ticketAttriubeLinks = 'tickets_attributes_link'



##### Ticketing Application IDs #####
## Create a variable for each application. This makes it easy to identify the ID without having to check TD.
[string]$ticketingAppID = 0

## Add the variable you created for the ticketing application to the array of all application IDs
$appIDs = @($ticketingAppID)
