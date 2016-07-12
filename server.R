
server <- function(input, output) { 
  
  katz.form.ans <- callModule(katz, "katz")  
  lawton.form.ans<- callModule(lawton,"lawton")  
  
  observeEvent(katz.form.ans(),{
    cat(katz.form.ans())
    
  })
  
  observeEvent(lawton.form.ans(),{
    cat(lawton.form.ans())
    
  })
  
  
  
}
