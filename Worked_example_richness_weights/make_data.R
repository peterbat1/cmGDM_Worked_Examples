
library(stringr)

nSites <- 10
maxAbund <- 30

nSpecies <- 16

speciesNames <- paste0("spp", stringr::str_pad(as.character(1:nSpecies), side = "left", width = 2, pad = "0"))

siteNames <- c("Lump",
               "Sticks",
               "Wallow",
               "Wiffle",
               "Bump",
               "Hollow",
               "Dale",
               "Hillock",
               "Waffle",
               "Logs")

abundMatrix <- matrix(0, nSites, nSpecies)


# strong North-South
gradient_strong_NS <- seq(10, 1, by = -1)

# weak North-South
gradient_weak_NS <- c(rep(10, 3), rep(8, 3), rep(6, 3), 5)

# Random
gradient_random <- sample(0:15, 10, replace = FALSE)

sppGradientType <- c("strong", "weak", "weak", "strong",
                     "random", "weak", "strong", "random",
                     "weak", "random", "random", "strong",
                     "random", "weak", "strong", "random")


for (i in 1:nSpecies)
{
      for (j in 1:nSites)
    {

  if (sppGradientType[i] == "strong")
        abundMatrix[j, i] <- sum(runif(20*gradient_strong_NS[j], 0, gradient_strong_NS[j]) < gradient_strong_NS[j]/10)
  
  if (sppGradientType[i] == "weak")
    abundMatrix[j, i] <- sum(runif(2*gradient_weak_NS[j], 0, gradient_weak_NS[j]) < gradient_weak_NS[j]/10)
  
  if (sppGradientType[i] == "random")
    abundMatrix[j, i] <- sample(0:5, 1, replace = FALSE)
  
  
      
      
    }
  
}


print(rowSums(ifelse(abundMatrix > 0, 1, 0)))

