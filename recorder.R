

recorderUI <- function(id){
  
  ns <- NS(id)
  
  tagList(
    tags$head(tags$script(src="recorder.js")),
    tags$head(tags$script(src="logic.js")),
    singleton(tags$head(HTML(" 
                             <script type='text/javascript'>
                             
                             $(document).ready(function() {
                             Shiny.addCustomMessageHandler('api_url', function(message) {
                             console.log('olar');
                             
                             api_url = message.url;
                             console.log(api_url)
                             
                             });    
                             
                             console.log('ondoc ready endend');
                             
                             })
                             
                             
                             </script>
                             " ))),
    
    h2("Verbal fluency"),
    textInput(ns("name"), "Patient Name", "name"),
    selectInput(ns("category"), "Test category", 
                choices = c("animal", "supermarket-product", "verb")),
    selectInput(ns("gender"), "Recorder gender option", 
                choices = c("female", "male")),
    
    actionButton(ns("getwords"), "GET WORDS"),
    textOutput(ns("testResult")),
    tags$body(tags$input(type = "button", 
                         value = "START", 
                         id = "button1", 
                         onClick = "startRecording(this)")),
    tags$body(tags$input(type = "button", 
                         value = "STOP", 
                         id = "button1", 
                         onClick = "stopRecording(this)"))
    
    
    
    )
}


person.name <<- "name"
category.name <<- "nocat"
gender.name <<- "m"


recorder <- function(input, output, session) {
  
  
  observe({
    person.name <<- input$name
    category.name <<- input$category
    gender.name <<- input$gender})
  
  api_url <- session$registerDataObj( 
    name   = 'api', # an arbitrary but unique name for the data object
    data   = list(), # you can bind some data here, which is the data argument for the
    # filter function below.
    filter = function(data, req) {
      print(ls(req))  # you can inspect what variables are encapsulated in this req
      
      if (req$REQUEST_METHOD == "POST") {
        # handle POST requests here
        
        reqInput <- req$rook.input
        
        # read a chuck of size 2^16 bytes, should suffice for our test
        buf <- reqInput$read()
        # print(length(buf))
        #saveBuffer(buf,input$name,input$category)
        
        # observeEvent(input$name, {saveBuffer(buf,input$name,input$category)})
        
        saveBuffer(buf,person.name,category.name,gender.name)
        
        # simply dump the HTTP request (input) stream back to client
        shiny:::httpResponse(
          200, 'text/plain', buf
        )
      }
      
      
    }
  )
  
  output$testResult <- renderText({
    input$getwords
    #return(c(input$name, input$category, input$gender))
    kaldiPath <-paste0("~/verbalFluencyTester/result/", category.name,"/",person.name)
    final.path <- paste0(kaldiPath,"/")
    # setwd(final.path)
    number.of.files <- length(list.files(path = final.path))
    number <- number.of.files-1
    file.name <- paste0(final.path,"test",number,".txt")
    tehFile <- file(file.name,open = 'r')
    txt <- scan(tehFile, character(0),quiet = TRUE)
    close(tehFile)
    return(txt)
    
  })
  
  words <- eventReactive(input$getwords, {
    #return(c(input$name, input$category, input$gender))
    kaldiPath <-paste0("~/verbalFluencyTester/result/", category.name,"/",person.name)
    final.path <- paste0(kaldiPath,"/")
    # setwd(final.path)
    number.of.files <- length(list.files(path = final.path))
    number <- number.of.files-1
    file.name <- paste0(final.path,"test",number,".txt")
    tehFile <- file(file.name,open = 'r')
    txt <- scan(tehFile, character(0),quiet = TRUE)
    close(tehFile)
    return(txt)
  })
  
  
  session$sendCustomMessage("api_url", list(url=api_url))
  return(words)
  
}



saveBuffer <- function(buffer,name, category, gender){
  
  kaldiPath <-paste0("~/verbalFluencyTester/kaldi/egs/", category, "/audio/", "test/")
  # folderName <- paste0(name,"_test")
  # dir.create(file.path(kaldiPath, folderName), showWarnings = FALSE)
  # final.path <- paste0(kaldiPath,folderName,"/")
  
  dir.create(file.path(kaldiPath,name), showWarnings = FALSE)
  final.path <- paste0(kaldiPath,name,"/")
  # setwd(final.path)
  number.of.files <- length(list.files(path = final.path))
  #number.of.files <- 3
  
  raw.file.name <- paste0(final.path,"rawtest",number.of.files,".wav" )
  out.file <- file( raw.file.name , "wb" )
  writeBin(buffer,out.file, useBytes = TRUE)
  close(out.file)
  
  system(paste0("ffmpeg -i ",raw.file.name ," -ar 16000 ",paste0(final.path,"test",number.of.files,".wav" ) ), ignore.stdout = TRUE, ignore.stderr = TRUE)
  system(paste0("rm ", raw.file.name))
  if(gender == "male")
  {system(paste0("./process_info.sh ",category," ",name," m"))}
  else
  {system(paste0("./process_info.sh ",category," ",name," f"))}
  
  
  
}

