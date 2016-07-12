
twoRadios <- function(id,headerText,op1,op2,op1Text,op2Text){
  ns <- NS(id)
  aux <- list()
  aux[[op1Text]] <- op1
  aux[[op2Text]] <- op2
  
  radioButtons(id, headerText, aux, width = "70%",  selected = FALSE)
  
}

katzTotal <- function(input){
  
  vec <- c(input$bathing, input$dressing, input$toileting, input$transferring, input$continence, input$feeding)
  vec <- as.numeric(vec)
  return(sum(vec))
  
}

katzUI <- function(id){
  
  ns <- NS(id)
  
  tagList(
    h3("This is katz test module page"),
    twoRadios(ns("bathing"), "Bathing", "1", "0", 
                   "Bathes self completely or needs help in bathing only a single part of the body such as the back, genital area or disabled extremity.",
                   "Need help with bathing more than one part of the body, getting in or out of the tub or shower. Requires total bathing."),
    twoRadios(ns("dressing"), "Dressing", "1", "0", 
              "Get clothes from closets and drawers and puts on clothes and outer garments complete with fasteners. May have help tying shoes.",
              "Needs help with dressing self or needs to be completely dressed."),
    twoRadios(ns("toileting"), "Toileting", "1", "0", 
              "Goes to toilet, gets on and off, arranges clothes, cleans genital area without help.",
              "Needs help transferring to the toilet, cleaning self or uses bedpan or commode."),
    twoRadios(ns("transferring"), "Transferring", "1", "0", 
              "Moves in and out of bed or chair unassisted. Mechanical transfer aids are acceptable.",
              "Needs help in moving from bed to chair or requires a complete transfer."),
    twoRadios(ns("continence"), "Continence", "1", "0", 
              "Exercises complete self control over urination and defecation.",
              "Is partially or totally incontinent of bowel or bladder."),
    twoRadios(ns("feeding"), "Feeding", "1", "0", 
              "Gets food from plate into mouth without help. Preparation of food may be done by another person.",
              "Needs partial or total help with feeding or requires parenteral feeding."),
    actionButton(ns("action"), "Save test")
    
    
    )
  
}

katz <- function(input,output,session){
  
  total <- eventReactive(input$action, {
   katzTotal(input)
  })
  
  return(total)
}