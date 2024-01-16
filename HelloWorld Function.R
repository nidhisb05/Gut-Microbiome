#temperature_check <- function(temperature)

#Defining degrees celsius, will be used in all conditional statements
degree_celsius <- "\u00B0C"

#Depending on what the temperature is different conditional statements
temperature_check <- function(temperature) {
  if (temperature > 0) #Any temperature greater than 0 
    {print(paste("It's", temperature, degree_celsius,"! Time to get the short sleeves out!"))
  } else if (temperature == 0) #Only when the temperature is 0 
    {
    print(paste("Maybe I should start layering up! It's", temperature, degree_celsius,"!"))
  } else {
    cat("I can't believe it's", temperature, degree_celsius, "! I am so c")
    for (i in 1:(0-temperature)) #Range of temperatures below 0, no stop, "o's" will continue to be added
      cat("o") #The number of "o's" is based on the temperature, e.g.; -2 will be "coold"
    cat("ld!!") #Using cat here combined the "cold" together without adding a line after every letter
  }
}

