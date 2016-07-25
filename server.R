
server <- function(input, output) { 
  
  katz.form.ans <- callModule(katz, "katz")  
  lawton.form.ans<- callModule(lawton,"lawton")  
  recorder.ans <- callModule(recorder,"recorder")  
  
  
  observeEvent(recorder.ans(),{
    cat(recorder.ans())
  })
  
  observeEvent(katz.form.ans(),{
    cat(katz.form.ans())
    
  })
  
  observeEvent(lawton.form.ans(),{
    cat(lawton.form.ans())
    
  })
  
  
  
}
