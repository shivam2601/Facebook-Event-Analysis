library(Rfacebook)
library(jsonlite)
library(rjson)
library(httr)

getEventsbyGroup <- function(page, token, api="v2.9"){
  
  url <- paste0('https://graph.facebook.com/', page,'/events?fields=description,name,start_time,end_time,place,id,attending_count,declined_count,maybe_count,noreply_count')
  print(url)
  # making query
  content <- fromJSON(paste(url,"&access_token=",token,sep=""))
  df <- content$data
  #retrying 3 times if error was found
  error <- 0
  while (length(content$error_code)>0){
    cat("Error!\n")
    Sys.sleep(0.5)
    error <- error + 1
    content <- callAPIforGroup(url=url, token=token, api=api)		
    if (error==3){ stop(content$error_msg) }
  }
  return(df)

}



######################################################################################

library(Rfacebook)
fb_oauth = "EAACEdEose0cBAAorZBTpLPimQdXZBz71RyRuy2sUolUTZASAtFXHUlABo1nQPWzgGuGo87wcoDU6j3lPOZCQCxEZB13VqK6cv1CImvY05KgYgAEDu83srZBnV0NuI6bZBmJ46LIyY4Uc5W5kUXNKhaAYdI3NMCaAlCq5o0KloLxLr22W9qLejngkMriucHEfxsc0Wrle01dEAZDZD"
cb = getEvents("codingblocksindia", token = fb_oauth)
gdg = getEvents("gdgnewdelhi", token = fb_oauth)
ilugd = getEvents("ILUGD", token = fb_oauth)
whcd = getEvents("womenwhocodedelhi", token = fb_oauth)
pydelhi = getEvents("pydelhi", token = fb_oauth)
android = getEventsbyGroup(249598592040574, token = fb_oauth)



