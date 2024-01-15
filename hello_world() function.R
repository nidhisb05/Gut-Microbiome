#Defining a function for temperature check
temperature_check <- function(temperature)

#Defining degrees celsius, will be used in all conditional statements
celsius_symbol <- "\u2103"

#Depending on what the temperature is different conditional statements
temperature_check <- function(temperature) {
  if (temperature > 0) {
    print(paste("It's", temperature, celsius_symbol,"! Time to get the short sleeves out!"))
  } else if (temperature == 0) {
    print(paste("Maybe I should start layering up! It's", temperature, celsius_symbol,"!"))
  } else {
    cat("I can't believe it's", temperature, celsius_symbol, "! I am so c")
    for (i in 1:(0-temperature))
      cat("o") #The number of "o's" is based on the temperature, e.g.; -2 will be "coold"
    cat("ld!!")
  }
}
