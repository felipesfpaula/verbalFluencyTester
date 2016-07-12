

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
        f <- file ( "recorded.wav", "wb")
        buf <- reqInput$read()
        # print(length(buf)) 
        writeBin(buf,f, useBytes = TRUE)
        close(f)
        # simply dump the HTTP request (input) stream back to client
        shiny:::httpResponse(
          200, 'text/plain', buf
        )
      }          
    }
  )
  
  output$testResult <- renderText({
    paste("olaaaa", input$getwords)
    
  })
  
  words <- eventReactive(input$getwords, {
    return("ok")
  })
  
  
  session$sendCustomMessage("api_url", list(url=api_url))
  
  return(words)
  
}


