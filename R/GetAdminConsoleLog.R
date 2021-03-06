#GetAdminConsoleLog  - By report suite, get all admin actions for a period of time
#There's a limit of 1000 records returned, so put in documentation to be careful
  
GetAdminConsoleLog <- function(start_date=as.character(Sys.Date()-1), end_date=as.character(Sys.Date()), report_suites) {
  #Make sure dates are in right order
  if(start_date > end_date) {
    return(print("Error:  'start_date' is more recent than 'end_date'"))
  }
  
  
  #A bit of slop to format report_suites into JSON
  if(length(report_suites)>1){
    report_suites <- toJSON(report_suites)
  } else {
    report_suites <- toJSON(list(report_suites))
  }
  

#Make API call - Numerous parameters left out, this returns all info for all users, instead of single user
json <- postRequest("Logs.GetAdminConsoleLog", paste('{"start_date":', toJSON(start_date), "," , '"end_date":', toJSON(end_date), "," , '"rsid_list":', report_suites, '}'))

if(json$status != 200) {
  return(jsonResponseError(json$status))
} else {  
#Convert JSON raw into list
results <- content(json)
}

if(length(results) > 0) {

#Return formatted dataframe
return(ldply(results, quickdf))

} else {
  return(print("There are no results for the timeperiod selected"))
}

}

