library(ggplot2)
library(dplyr)

first_data <- read.csv('first-focus.csv')
ggplot(first_data, aes(x=data.circle, y="", fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for First-focus with\nrespect to Location") +
  labs(x="Location",y="Relative Count", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))
ggplot(first_data, aes(x=data.color, y="", fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for First-focus with\nrespect to Color") +
  labs(x="Color",y="Relative Count") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))

second_data <- read.csv('second-focus.csv')
ggplot(second_data, aes(x=data.circle, y="", fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Second-focus with\nrespect to Location") +
  labs(x="Location",y="Relative Count", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))
ggplot(second_data, aes(x=data.color, y="", fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Second-focus with respect to Color") +
  labs(x="Color",y="Relative Count") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))
