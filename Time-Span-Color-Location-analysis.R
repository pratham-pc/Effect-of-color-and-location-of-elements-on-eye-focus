library(ggplot2)
library(dplyr)

data <- read.csv('merged-aggregate-merged.csv')

#histogram color-location wise
ggplot(data, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location\nand Color vs Time-span") +
  labs(x="Location",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffffff", "#ffff00"))

#25+1 rows containing 5x5 combination of color and location
cpdata <- with(data, aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle), data.color = tolower(data.color)), sum))

#total color distibution irrespective of the position
cpdata_color <- with(data, aggregate(list(data.time_span = data.time_span), list(data.color = tolower(data.color)), sum))

ggplot(cpdata_color, aes(x="", y=cpdata_color$data.time_span/sum(cpdata_color$data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Color vs %-Time-span") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffffff", "#ffff00"))

ggplot(cpdata_color, aes(x=data.color, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Color vs %-Time-span") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffffff", "#ffff00"))

#total color distribution location-wise
cpdata_color_tl <- with(subset(data, data.circle=='top-left'), aggregate(list(data.time_span = data.time_span), list(data.color = tolower(data.color)), sum))
ggplot(cpdata_color_tl, aes(x=data.color, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Color vs %-Time-span for Top-Left circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000ff", "#00ff00", "#ff4500", "#ff0000", "#ffff00"))

ggplot(cpdata_color_tl, aes(x="", y=cpdata_color_tl$data.time_span/sum(cpdata_color_tl$data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Color vs %-Time-span for Top-Left circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))

cpdata_color_tr <- with(subset(data, data.circle=='top-right'), aggregate(list(data.time_span = data.time_span), list(data.color = tolower(data.color)), sum))
ggplot(cpdata_color_tr, aes(x=data.color, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Color vs %-Time-span for Top-Right circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000ff", "#00ff00", "#ff4500", "#ff0000", "#ffff00"))

ggplot(cpdata_color_tr, aes(x="", y=cpdata_color_tr$data.time_span/sum(cpdata_color_tr$data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Color vs %-Time-span\nfor Top-Right circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))

cpdata_color_bl <- with(subset(data, data.circle=='bottom-left'), aggregate(list(data.time_span = data.time_span), list(data.color = tolower(data.color)), sum))
ggplot(cpdata_color_bl, aes(x=data.color, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Color vs %-Time-span\nfor Bottom-Left circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000ff", "#00ff00", "#ff4500", "#ff0000", "#ffff00"))

ggplot(cpdata_color_bl, aes(x="", y=cpdata_color_bl$data.time_span/sum(cpdata_color_bl$data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Color vs %-Time-span\nfor Bottom-Left circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))

cpdata_color_br <- with(subset(data, data.circle=='bottom-right'), aggregate(list(data.time_span = data.time_span), list(data.color = tolower(data.color)), sum))
ggplot(cpdata_color_br, aes(x=data.color, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Color vs %-Time-span\nfor Bottom-Right circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000ff", "#00ff00", "#ff4500", "#ff0000", "#ffff00"))

ggplot(cpdata_color_br, aes(x="", y=cpdata_color_br$data.time_span/sum(cpdata_color_br$data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Color vs %-Time-span\nfor Bottom-Right circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))


cpdata_color_c <- with(subset(data, data.circle=='center'), aggregate(list(data.time_span = data.time_span), list(data.color = tolower(data.color)), sum))
ggplot(cpdata_color_c, aes(x=data.color, y=data.time_span/sum(data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Color vs %-Time-span\nfor Center circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000ff", "#00ff00", "#ff4500", "#ff0000", "#ffff00"))

ggplot(cpdata_color_c, aes(x="", y=cpdata_color_c$data.time_span/sum(cpdata_color_c$data.time_span)*100, fill=data.color))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Color vs %-Time-span\nfor Center circle") +
  labs(x="Color",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))

#total distribution at a location irrespective of the color
cpdata_location <- with(data, aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))

ggplot(cpdata_location, aes(x="", y=data.time_span/sum(data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Location vs %-Time-span") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffffff", "#ffff00"))

ggplot(cpdata_location, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location vs %-Time-span") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ffffff", "#ff0000", "#ffff00"))

#total time_span of focus location wise for each color
cpdata_location_red <- with(subset(data, data.color=='Red'), aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))
ggplot(cpdata_location_red, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=""))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location vs %-Time-span\nfor Red-Colored circle") +
  labs(x="Location",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#ff0000", "#ff0000", "#ff0000", "#ff0000", "#ff0000", "#ffff00"))

ggplot(cpdata_location_red, aes(x="", y=cpdata_location_red$data.time_span/sum(cpdata_location_red$data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Location vs %-Time-span\nfor Red Color") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF0000", "#ff4500", "#ffff00", "#ffff00"))


cpdata_location_blue <- with(subset(data, data.color=='Blue'), aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))
ggplot(cpdata_location_blue, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=""))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location vs %-Time-span\nfor Blue-Colored circle") +
  labs(x="Location",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#0000FF", "#0000FF", "#0000FF", "#0000FF", "#ffff00"))

ggplot(cpdata_location_blue, aes(x="", y=cpdata_location_blue$data.time_span/sum(cpdata_location_blue$data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Location vs %-Time-span\nfor Blue Color") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#ffff00", "#00ff00", "#FF4500", "#ff0000", "#0000FF", "#ffff00"))


cpdata_location_green <- with(subset(data, data.color=='Green'), aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))
ggplot(cpdata_location_green, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=""))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location vs %-Time-span\nfor Green-Colored circle") +
  labs(x="Location",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#00ff00", "#00ff00", "#00ff00", "#00ff00", "#00ff00", "#ffff00"))

ggplot(cpdata_location_green, aes(x="", y=cpdata_location_green$data.time_span/sum(cpdata_location_green$data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Location vs %-Time-span\nfor Green Color") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF4500", "#ff0000", "#ffff00", "#ffff00"))


cpdata_location_orange <- with(subset(data, data.color=='Orange'), aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))
ggplot(cpdata_location_orange, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=""))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location vs %-Time-span\nfor Orange-Colored circle") +
  labs(x="Location",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#FF4500", "#FF4500", "#FF4500", "#FF4500", "#FF4500", "#ffff00"))

ggplot(cpdata_location_orange, aes(x="", y=cpdata_location_orange$data.time_span/sum(cpdata_location_orange$data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Location vs %-Time-span\nfor Orange Color") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#0000FF", "#00ff00", "#FF0000", "#FF4500", "#ffff00", "#ffff00"))

cpdata_location_yellow <- with(subset(data, data.color=='Yellow'), aggregate(list(data.time_span = data.time_span), list(data.circle = tolower(data.circle)), sum))
ggplot(cpdata_location_yellow, aes(x=data.circle, y=data.time_span/sum(data.time_span)*100, fill=""))+
  geom_bar(width = 1, stat = "identity") +
  ggtitle("Bar-Plot for Location vs %-Time-span\nfor Yellow-Colored circle") +
  labs(x="Location",y="%-Time-span") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#ffff00", "#ffff00", "#ffff00", "#ffff00", "#ffff00", "#ffff00"))

ggplot(cpdata_location_yellow, aes(x="", y=cpdata_location_yellow$data.time_span/sum(cpdata_location_yellow$data.time_span)*100, fill=data.circle))+
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0)+
  ggtitle("Pie-Plot for Location vs %-Time-span\nfor Yellow Color") +
  labs(x="Location",y="%-Time-span", fill="data.position") +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  scale_fill_manual(values=c("#ffff00", "#00ff00", "#FF0000", "#FF4500", "#0000ff", "#0000FF"))

