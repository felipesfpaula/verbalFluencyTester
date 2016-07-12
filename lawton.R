
lawtonRadios <- function(id,headerText,tagVec,textVec){
  
  ns <- NS(id)
  
  names(tagVec) <- textVec
  radioButtons(id, headerText, tagVec, width = "70%", selected = FALSE)
  
}


lawtonTotal <- function(input){
  
  vec <- c(input$telephone, input$shopping, input$food, 
           input$house, input$laundry, input$transpor, 
           input$medication, input$finances)
  
  vec <- as.numeric(vec)
  return(sum(vec))
  
}

telephone <- c("Operates telephone on own initiative-looks up and dials numbers, etc. (1)",
       "Dials a few well-known numbers. (1)",
       "Answers telephone but does not dial. (1)",
       "Does not use telephone at all. (0)")

telephone.val <- c("1","1","1","0")
       
shopping <- c("Takes care of all shopping needs independently. (1)",
        "Shops independently for small purchases. (0)",
        "Needs to be accompanied on any shopping trip. (0)",
        "Completely unable to shop. (0)")

shopping.val <- c("1","0","0","0")


food <- c("Plans, prepares, and serves adequate meals independently. (1)",
        "Prepares adequate meals if supplied with ingredients. (0)",
        "Heats and serves prepared meals or prepares meals but does not maintain adequate diet. (0)",
        "Needs to have meals prepared and served. (0)")

food.val <- c("1","0","0","0")


house <- c("Maintains house alone with occasion assistance (heavy work). (1)",
        "Performs light daily tasks such as dishwashing, bed making. (1)",
        "Performs light daily tasks, but cannot maintain acceptable level of cleanliness. (1)",
        "Needs help with all home maintenance tasks. (1)",
        "Does not participate in any housekeeping tasks. (0)")

house.val <- c("1","1","1","1","0")


laundry <- c("Does personal laundry completely. (1)",
        "Launders small items, rinses socks, stockings, etc. (1)",
        "All laundry must be done by others. (0)")

laundry.val <- c("1","1","0")


transpor <- c("Travels independently on public transportation or drives own car. (1)",
        "Arranges own travel via taxi, but does not otherwise use public transportation. (1)",
        "Travels on public transportation when assisted or accompanied by another. (1)",
        "Travel limited to taxi or automobile with assistance of another. (0)",
        "Does not travel at all. (0)")

transpor.val <- c("1","1","1","0","0")


medication <- c("Is responsible for taking medication in correct dosages at correct time. (1)",
        "Takes responsibility if medication is prepared in advance in separate dosages. (0)",
        "Is not capable of dispensing own medication. (0)")

medication.val <- c("1","0","0")

finances <- c("Manages financial matters independently (budgets, writes checks, pays rent and bills, goes to bank); collects and keeps track of income. (1)",
        "Manages day-to-day purchases, but needs help with banking, major purchases, etc. (1)",
        "Incapable of handling money. (0)")

finances.val <- c("1","1","0")



lawtonUI <- function(id){
  ns <- NS(id)
  nms <- c("1","2","3","4","5")
  tagList(
    h3("Lawton Instrumental Activities of Daily Living"),
    lawtonRadios(ns("telephone"), "Ability to Use Telephone ", telephone.val , telephone),
    lawtonRadios(ns("shopping"), "Shopping", shopping.val , shopping),
    lawtonRadios(ns("food"), "Food Preparation", food.val , food),
    lawtonRadios(ns("house"), "Housekeeping", house.val , house),
    lawtonRadios(ns("laundry"), "Laundry", laundry.val , laundry),
    lawtonRadios(ns("transpor"), "Mode of Transportation", transpor.val , transpor),
    lawtonRadios(ns("medication"), "Responsibility for Own Medications", medication.val , medication),
    lawtonRadios(ns("finances"), "Ability to Handle Finances", finances.val , finances),
    
    actionButton(ns("action"), "Save test")
    
  )
  
}


lawton <- function(input,output,session){
  
  total <- eventReactive(input$action, {
    lawtonTotal(input)
  })
  
  return(total)
  
}

