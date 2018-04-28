#Simple PowerShell script to automate ping connection tests.
#Takes a .txt as parameter with IPs/names of computers (1 per line) to be tested one by one.
#Only tests if the connection could be made (reached) or not (unreached), doesn't return any other information.
#Prints all the reached and unreached machines after testing all IPs.

#https://stackoverflow.com/questions/43531688/unnecessary-space-in-output-when-using-write-host (helped me)

#Can be called in PowerShell: .\pinglist.ps1 ip_list.txt

param(
[Parameter(Mandatory=$True, Position=0, HelpMessage='Set path variable')]
  [string]$filePath
)

#Store file content in variable
$file = Get-Content -Path $filePath

#Get number of lines to use in for loop
$lines = Get-Content $filePath | Measure-Object -Line

#Variables to store reached and unreached connections (strings)
$reachedConnections
$unreachedConnections

#Variable to count unreached connections
$count_unreachedConnections = 0

#Indicates that the connection test will start
Write-Host ("`n" + "Testing connections:") -foreground yellow

#For every line in file, test connection, is either true or false
for ($i = 0; $i -lt $lines.Lines; $i++) {

    #Print the current machine that the connectivity is being tested
    Write-Host ($file)[$i] -NoNewline

    #Inform if the machine was reachable or not
    If (Test-Connection $file[$i] -count 1 -quiet){
        Write-Host " - REACHED" -foreground green
        #Adds the machine IP/name to reachable connections
        $reachedConnections += $file[$i] + "`n"
    }
    Else{
        Write-Host " - UNREACHED" -foreground red
        #Adds the machine IP/name to unreachable connections
        $unreachedConnections += $file[$i] + "`n"
        #Increment of the number of unreachable connections
        $count_unreachedConnections++
    }
}

#Print results
#Number of reached connections = all connections - unreached connections
Write-Host ("`n" + "REACHED CONNECTIONS (" + ($lines.Lines - $count_unreachedConnections) + "):") -foreground green
Write-Host $reachedConnections

Write-Host "UNREACHED CONNECTIONS ($count_unreachedConnections):" -foreground red
Write-Host $unreachedConnections