# načíst či vytvořit autorizační soubor

if (file.exists('token.rds')) {
  url <- readRDS('token.rds')  # gitignored file :)
   } else {
  url <- paste0('https://ckc-emea.cisco.com/corev4/token/?client_secret=',
                rstudioapi::showPrompt(title = "Client Secret", message = "Client Secret", default = ""),
                '&client_id=',
                rstudioapi::showPrompt(title = "Client ID", message = "Client ID", default = ""),
                '&grant_type=password&username=',
                rstudioapi::showPrompt(title = "Username", message = "Username (incl. @prague-city.com)", default = "@prague-city.com"),
                '&password=',
                rstudioapi::showPrompt(title = "Password", message = "Password", default = ""))
  
  saveRDS(url, 'token.rds') # uložit ještě před otestováním
  
  }

response <- POST(url)

if (response$status_code != 200) file.remove('token.rds') # když nefunguje, tak smazat...

