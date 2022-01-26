Import-WslCommand "apt", "awk", "emacs", "grep", "head", "less", "man", "sed", "seq", "ssh", "sudo", "tail", "docker", "xargs"

# [enable scoop-completion](https://github.com/Moeologist/scoop-completion)
# enable completion in current shell, use absolute path because PowerShell Core not respect $env:PSModulePath
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"

$vim_config_path = "~\AppData\Local\nvim"

# ENVS
$Env:MYVIMRC = "$vim_config_path\init.vim"

# Aliases Functions

function Set-MyCustomRefreshShell {
  $Env:Path = `
    [System.Environment]::GetEnvironmentVariable("Path", "Machine") + `
    ";" + `
    [System.Environment]::GetEnvironmentVariable("Path", "User")

  . "$PSScriptRoot\$scriptName"
}

$scriptName = $MyInvocation.MyCommand.Name
function Set-SourceMyProfile {
  . "$PSScriptRoot\$scriptName"
}

function Switch-Nvm {
  if (Test-Path .nvmrc) {
    nvm use $(Get-Content .nvmrc)
  }
}

function Get-MyCustomCd1 {
  Set-Location ..
}

function Get-MyCustomCd2 {
  Set-Location ../..
}

function Get-MyCustomCd3 {
  Set-Location ../../..
}

function Get-MyCustomCd4 {
  Set-Location ../../../..
}

function Get-Which {
  param (
    $command
  )

  where.exe $command
}

function Get-Nvim {
  param (
    $command
  )

  nvim.exe -u $Env:MYVIMRC $command
}

function New-MyCustomLink {
  param (
    $target,
    $link
  )

  New-Item -Path $link -ItemType SymbolicLink -Value $target
}

# YARN

function Get-MyCustomYarnStart {
  param (
    $command
  )

  yarn start $command
}

function Get-MyCustomYarnNps {
  param (
    $command
  )

  yarn nps $command
}

function Get-MyCustomYarnWhy {
  param (
    $command
  )

  yarn why $command
}

# END YARN

function Get-MyCustomAliasFzf {
  Get-Alias | fzf
}

function Get-MyCustomEnvFzf {
  Get-ChildItem env: | fzf
}

function Get-MyCustomClearShell {
  Clear-Host
}

$regex = [Regex]::new('\$\{?([\w]+)\}?')
function Set-ValForCustomEnv {
  param (
    [Parameter(Mandatory)]
    [string]$val,

    [Parameter(Mandatory)]
    [string]$key,

    [Parameter(Mandatory)]
    [Hashtable]$hash
  )

  $val = $val.Trim(@('"', "'", " "))

  $matched = $regex.Matches($val)

  if ($matched) {
    foreach ($m in $matched) {
      $original = $m.Groups[0].Value;
      $captured = $m.Groups[1].Value

      if ($hash.ContainsKey($captured)) {
        $val = $val.replace($original, $hash[$captured] )
      }
    }
  }


  New-Item -Name $key -Value $val -ItemType Variable -Path Env: -Force > $null

  $hash[$key] = $val;
}

function Get-MyCustomSetenv {
  param (
    $envFileName
  )

  $hash = @{}

  if (Test-Path $envFileName) {
    foreach ($line in (Get-Content $envFileName )) {
      $line = $line.Trim()

      if ($line -Match '^\s*$' -Or $line -Match '^#') {
        continue
      }

      $key, $val = $line.Split("=")

      Set-ValForCustomEnv -val $val -key $key -hash $hash
    }
  }

  Write-Output $hash;
}

# END Aliases Functions

# Aliases
New-Alias -Name ".." Get-MyCustomCd1
New-Alias -Name "..." Get-MyCustomCd2
New-Alias -Name "c3" Get-MyCustomCd3
New-Alias -Name "c4" Get-MyCustomCd4
New-Alias -Name "ll" Get-ChildItem

# ENVIRONMENT AND SHELL
New-Alias -Name "setenvs" Get-MyCustomSetenv
New-Alias -Name "eshell" Set-MyCustomRefreshShell
New-Alias -Name ".b" Set-SourceMyProfile
New-Alias -Name "C" Get-MyCustomClearShell

New-Alias -Name "usenvm" Switch-Nvm
New-Alias -Name "which" Get-Which
New-Alias -Name "ln" New-MyCustomLink

# VIM
New-Alias -Name "vim" Get-Nvim

# YARN
New-Alias -Name "ys" Get-MyCustomYarnStart
New-Alias -Name "yn" Get-MyCustomYarnNps
New-Alias -Name "ywhy" Get-MyCustomYarnWhy

# FZF
New-Alias -Name "aff" Get-MyCustomAliasFzf
New-Alias -Name "eff" Get-MyCustomEnvFzf
