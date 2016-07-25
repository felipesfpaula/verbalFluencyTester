library(shinydashboard)

# I assume that doing very deep navigation in a single tab is not a very
# good practice in Shiny. Instead, to avoid complexity, in this version 
# we are going to use a tab for a page.


dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Katz test", tabName = "katz", icon = icon("th")),
      menuItem("Lawton test", tabName = "lawton", icon = icon("th")),
      menuItem("Verbal fluency test", tabName = "recorder", icon = icon("th"))
      
    )
    
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "katz",
              fluidPage(
                katzUI("katz")
              )
      ),
      
      # Second tab content
      tabItem(tabName = "lawton",
              fluidPage(
              lawtonUI("lawton")
              )
      ),
      # Second tab content
      tabItem(tabName = "recorder",
              fluidPage(
                recorderUI("recorder")
              )
      )      
    )    
    
  )
)