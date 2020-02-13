#Start, stop, or restart services en masse across various servers.

#serverFile with server names separate line by line
$serverFile ="C:\Servers.txt"
$serviceFile="C:\Services.txt"

#Function

function Service-Action{

Param($option)

foreach($serviceName in Get-Content $serviceFile){

    foreach($server in Get-Content $serverFile){
    
    $service = Get-Service -Name $serviceName -ComputerName $server -ErrorAction SilentlyContinue
    
    if ($option -eq 1){
    
        "Starting "+$serviceName+" on "+$server
        $service | Start-Service
    }
    if ($option -eq 2){
        "Stopping "+$serviceName+" on "+$server
        $service | Format-List Property Name,DependentServices
        $service | Stop-Service -Force
    }
    if ($option -eq 3){
        "Restarting "+$serviceName+" on "+$server
        $service | Restart-Service
    }

    if (-Not $service) {$serviceName + " does not exist on "+$server+". Skipping.."}
    
    }
}

foreach($serviceName in Get-Content $serviceFile){

    foreach($server in Get-Content $serverFile){
    
    $service = Get-Service -Name $serviceName -ComputerName $server -ErrorAction SilentlyContinue 
    $service | select Displayname,Status, @{l="Server";e={$server}} 
    
    }
}
}

#Implementation

$input = Read-Host -prompt '1) Start Services 2) Stop Services 3) Restart Service'

if (($input -eq 1 ) -or ($input -eq 2 ) -or ($input -eq 3 )){

    Service-Action($input)

}

else{

"Not a valid option."

}
