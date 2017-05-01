library(ggplot2)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

data <- read.csv(args[1]) 
data[, 1] <- as.numeric(as.character( data[, 1] ))
data[, 2] <- as.numeric(as.character( data[, 2] ))
data[, 3] <- as.numeric(as.character( data[, 3] ))

data["circle"] <- NA
levels(data$circle) <- c(levels(data$circle), "None", "Top-Left", "Top-Right", "Center","Bottom-Left","Bottom-Right")
data$circle <- 'None'

threshold=70
data$circle[data$x >= 150 - threshold & data$x <= 150 + threshold & data$y >= 150 - threshold & data$y <= 150 + threshold] <- 'Top-Left'
data$circle[data$x >= 450 - threshold & data$x <= 450 + threshold & data$y >= 150 - threshold & data$y <= 150 + threshold] <- 'Top-Right'
data$circle[data$x >= 300 - threshold & data$x <= 300 + threshold & data$y >= 300 - threshold & data$y <= 300 + threshold] <- 'Center'
data$circle[data$x >= 150 - threshold & data$x <= 150 + threshold & data$y >= 450 - threshold & data$y <= 450 + threshold] <- 'Bottom-Left'
data$circle[data$x >= 450 - threshold & data$x <= 450 + threshold & data$y >= 450 - threshold & data$y <= 450 + threshold] <- 'Bottom-Right'

cpdata <- data.frame(data$circle, data$time_span)
cpdata <- with(cpdata, aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))
cpdata["data.color"] <- NA
levels(cpdata$data.color) <- c(levels(cpdata$data.color), args[2], args[3], args[4], args[5], args[6], "white")
cpdata$data.color <- 'white'

cpdata$data.color[cpdata$data.circle == "bottom-left"] <- args[3]
cpdata$data.color[cpdata$data.circle == "bottom-right"] <- args[5]
cpdata$data.color[cpdata$data.circle == "top-left"] <- args[2]
cpdata$data.color[cpdata$data.circle == "top-right"] <- args[4]
cpdata$data.color[cpdata$data.circle == "center"] <- args[6]

write.csv(cpdata, file=args[7])
