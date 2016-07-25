

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

recorder <- function(input, output, session) {
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
        saveBuffer(buf,input$name,input$category)
        # simply dump the HTTP request (input) stream back to client
        shiny:::httpResponse(
          200, 'text/plain', buf
        )
      }          
    }
  )
  
  # output$testResult <- renderText({
  #   paste("olaaaa", input$getwords)
  #   
  # })
  
  words <- eventReactive(input$getwords, {
    return(c(input$name, input$category, input$gender))
  })
  
  
  session$sendCustomMessage("api_url", list(url=api_url))
  
  return(words)
  
}



saveBuffer <- function(buffer,name, category){
  
  kaldiPath <-paste0("~/kaldi/egs/", category, "/audio/", "test/")
  folderName <- paste0(name,"_test")
  dir.create(file.path(kaldiPath, folderName), showWarnings = FALSE)
  final.path <- paste0(kaldiPath,folderName)
  # setwd(final.path)
  number.of.files <- length(list.files(path = final.path))
  raw.file.name <- paste0(final.path,"rawtest",number.of.files,".wav" )
  out.file <- file( raw.file.name , "wb" )
  writeBin(buffer,out.file, useBytes = TRUE)
  close(out.file)
  
 # system(paste0("ffmpeg -i ",raw.file.name ," -ar 16000 ",paste0(final.path,"test",number.of.files,".wav" ) ), ignore.stdout = TRUE, ignore.stderr = TRUE)


}

