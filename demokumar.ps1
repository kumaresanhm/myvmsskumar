

#---------------------------------------------------------- 
#Renaming static to custom name with zip extensions
#---------------------------------------------------------- 

Rename-Item "C:\kumaresana\vmss\Verimoto.PpsrLogProcessChangePassword.zip" "ChangePassword.zip"

Rename-Item "C:\kumaresana\vmss\Verimoto.PpsrLogProcessJobSchedular.zip" "ProcessJobSchedular.zip"

Rename-Item "C:\kumaresana\vmss\Verimoto.Admin.zip" "Adminportal.zip"

Rename-Item "C:\kumaresana\vmss\Verimoto.PpsrRequestJobScheduler.zip" "RequestJobScheduler.zip"

Rename-Item "C:\kumaresana\vmss\Verimoto.RemoveImages.zip" "RemoveImages.zip"

Rename-Item "C:\kumaresana\vmss\Verimoto.UpdateStatus.zip" "UpdateStatus.zip"

Rename-Item "C:\kumaresana\vmss\Verimoto.zip" "API.zip"

Set-StrictMode -Version latest 
 
#---------------------------------------------------------- 
#STATIC VARIABLES 
#---------------------------------------------------------- 
$search = "PackageTmp" 
$dest   = "C:\inetpub" 
$zips   = "C:\kumaresana\vmss" 
 
#---------------------------------------------------------- 
#FUNCTION GetZipFileItems 
#---------------------------------------------------------- 
Function GetZipFileItems 
{ 
  Param([string]$zip) 
   
  $split = $split.Split(".") 
  $dest = $dest + "\" + $split[0] 
  If (!(Test-Path $dest)) 
  { 
    Write-Host "Created folder : $dest" 
    $strDest = New-Item $dest -Type Directory 
  } 
 
  $shell   = New-Object -Com Shell.Application 
  $zipItem = $shell.NameSpace($zip) 
  $items   = $zipItem.Items() 
  GetZipFileItemsRecursive $items 
} 
 
#---------------------------------------------------------- 
#FUNCTION GetZipFileItemsRecursive 
#---------------------------------------------------------- 
Function GetZipFileItemsRecursive 
{ 
  Param([object]$items) 
 
  ForEach($item In $items) 
  { 
    If ($item.GetFolder -ne $Null) 
    { 
      GetZipFileItemsRecursive $item.GetFolder.items() 
    } 
    $strItem = [string]$item.Name 
    If ($strItem -Like "*$search*") 
    { 
      If ((Test-Path ($dest + "\" + $strItem)) -eq $False) 
      { 
        Write-Host "Copied file : $strItem from zip-file : $zipFile to destination folder" 
        $shell.NameSpace($dest).CopyHere($item)
      } 
      Else 
      { 
        Write-Host "Copied file : $strItem from zip-file : $zipFile to destination folder" 
        $shell.NameSpace($dest).CopyHere($item,16)
        #Write-Host "File : $strItem already exists in destination folder" 
      } 
    } 
  } 
} 
 
#---------------------------------------------------------- 
#FUNCTION GetZipFiles 
#---------------------------------------------------------- 
Function GetZipFiles 
{ 
  $zipFiles = Get-ChildItem -Path $zips -Recurse -Filter "*.zip" | % { $_.DirectoryName + "\$_" } 
   
  ForEach ($zipFile In $zipFiles) 
  { 
    $split = $zipFile.Split("\")[-1] 
    Write-Host "Found zip-file : $split" 
    GetZipFileItems $zipFile 
  } 
} 
#RUN SCRIPT  
GetZipFiles -Force
"SCRIPT FINISHED" 
