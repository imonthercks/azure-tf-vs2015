iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

choco feature enable -n=allowGlobalConfirmation
choco install visualstudiocode
choco install nodejs
choco install git
choco install dotnetcore
choco install nimbletext
choco install cmder
choco install 7zip
choco install autohotkey