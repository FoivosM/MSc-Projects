# Set working dir as the -------
setwd("C:\\Users\\Foivos\\Desktop\\MS\\2 Data Visualization\\Assignments\\Assignment 1")
# Clear the environment
rm(list = ls())

# Import libs
library(ggplot2)
library(dplyr)
library(wesanderson)
library(ggrepel)
library(tibble)
library(GGally)
library(tidyr)
library(patchwork)
library(hrbrthemes)
library(viridis)
library(fmsb)
library(stringr)

# Read .Rdata file in a new df
load("pisa2018.Rdata")

# Tweak the pisa DF -----------
# Create a new data frame from the loaded data frame
pisa_data <- as.data.frame(newdata)

# Crete a new column with the average score of each subject as 'General Performance'
# GLCM is ignored due to a substantial proportion of missing values
pisa_data$Performance <-
  rowMeans(pisa_data[, c("MATH", "READ", "SCIE")], na.rm = TRUE)

# Reverse the order of levels in a factor column
pisa_data$Factor_Column <- factor(pisa_data$ST005Q01TA, levels = rev(levels(pisa_data$ST005Q01TA)))
pisa_data$Factor_Column <- factor(pisa_data$ST007Q01TA, levels = rev(levels(pisa_data$ST007Q01TA)))

# Colors --------------------------------------------------------------------------------
# Define custom color palette using HEX codes of Tableau colors
palette <-
  c(
    "#4E79A7",
    "#F28E2B",
    "#E15759",
    "#76B7B2",
    "#59A14F",
    "#EDC949",
    "#AF7AA1",
    "#FF9DA7",
    "#9C755F",
    "#BAB0AB"
  )

custom_palette <- c(
  "#00BFC4", # Cyan
  "#FB8072",  # Orange
  "#00BA38", # Green
  "#619CFF", # Blue
  "#F8766D", # Red
  "#F564E3", # Purple
  "#FFFFB3"  # Yellow
)
# Barplot --------------------------------------------------------------------------
# Calculating the mean performance score by country, ensuring data is not NaN and arranging in descending order
average_performance <- pisa_data %>%
  group_by(CNT) %>%
  summarise(Avg_Performance = mean(Performance, na.rm = TRUE)) %>%
  filter(!is.nan(Avg_Performance)) %>%
  arrange(desc(Avg_Performance))

# Adding a color column based on country, setting Greece to a specific color and others to another
average_performance$color <-
  ifelse(average_performance$CNT == "Greece", custom_palette[2], "gray40")

# Creating the bar plot with adjusted labels and customized x-axis label color for Greece
barchart <-
  ggplot(
    average_performance,
    aes(
      x = reorder(CNT, -Avg_Performance),
      y = Avg_Performance,
      fill = I(color)
    )
  ) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text_repel(
    data = subset(average_performance, CNT == "Greece"),
    aes(label = sprintf("%.0f", Avg_Performance), y = Avg_Performance + 0.5),
    vjust = -0.8,
    color = custom_palette[2]
  ) +
  geom_text(
    data = average_performance[which.max(average_performance$Avg_Performance), ],
    aes(label = sprintf("%.0f", Avg_Performance), y = Avg_Performance + 0.5),
    vjust = -0.5,
    color = "grey40"
  ) +
  geom_text_repel(
    data = average_performance[which.min(average_performance$Avg_Performance), ],
    aes(label = sprintf("%.0f", Avg_Performance), y = Avg_Performance + 0.5),
    vjust = -1.5,
    color = "grey40"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.35,
      color = ifelse(average_performance$CNT == "Greece", custom_palette[2], "grey40")
    ),
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.title.x = element_blank(),
    plot.margin = unit(c(1, 1, 1, 1), "cm"), # Adjust plot margins if necessary
    panel.grid = element_blank(),
  ) +
  labs(
    title = "STUDENT AVERAGE PERFORMANCE SCORE BY COUNTRY",
    caption = "Conclusion: Greece is below the median value 470 of student performance in all subjects",
    subtitle = "Calculated as the average of Math, Science, and Read competency"
  ) +
  guides(fill = FALSE) + # Hide the color legend
  coord_cartesian(xlim = c(0, length(average_performance$CNT) + 1)) # Increase xlim

barchart

# Stacked Relative Bars -------------------------------------------------------------------------------------

# Calculating the mean scores for each subject by country
average_scores <- pisa_data %>%
  group_by(CNT) %>%
  summarise(
    Math = mean(MATH, na.rm = TRUE),
    Reading = mean(READ, na.rm = TRUE),
    Science = mean(SCIE, na.rm = TRUE),
  )

# Melting the data for easier plotting with ggplot
average_scores_long <- reshape2::melt(average_scores, id.vars = "CNT", variable.name = "Subject", value.name = "Average_Score")

# Reordering levels of 'CNT' factor based on the order in 'average_performance'
average_scores_long$CNT <- factor(average_scores_long$CNT, levels = average_performance$CNT)

# Remove rows with NaN values from average_scores_long
average_scores_long <- average_scores_long[complete.cases(average_scores_long), ]


subject_colors <- gray.colors(3)
# subject_colors <- c(custom_palette[3],custom_palette[4],custom_palette[5])

# Creating the bar plot
stacked_bars <- ggplot(average_scores_long, aes(x = CNT, y = Average_Score, fill = Subject)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values = subject_colors) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.35,
      color = ifelse(average_performance$CNT == "Greece", custom_palette[2], "grey40")
    ),
    axis.title.x = element_blank(),
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    panel.grid = element_blank()
  ) +
  labs(
    title = "STUDENT RELATIVE PERFORMANCE PER COUNTRY (IN EACH SUBJECT)",
    subtitle = "Calculated as the average of Math, Science, and Read competency",
    x = "Country",
    y = "Relative Average Score",
    fill = "Subject",
    caption = "Conclusion: All countries have similar relative performance in all subjects"
  ) +
  scale_y_continuous(expand = c(0, 0)) # Clip y-axis below 0

stacked_bars

# Schools Boxplot --------------------------------------------
# Compute Avg_Performance and create a column for fill color based on 'Greece'
boxDF <- pisa_data %>%
  group_by(CNT, CNTSCHID) %>%
  summarise(Avg_Performance = mean(Performance, na.rm = TRUE), .groups = 'drop') %>%
  mutate(
    Fill = ifelse(CNT == "Greece", custom_palette[2], "grey40"),
    Text_Color = ifelse(CNT == "Greece", custom_palette[2], "grey40")
  )%>%
  filter(complete.cases(.))

# Update factor levels based on average_performance
boxDF$CNT <- factor(boxDF$CNT, levels = average_performance$CNT)

# Create the boxplot
box_plot <- ggplot(boxDF, aes(x = CNT, y = Avg_Performance, fill = Fill)) +
  geom_boxplot(show.legend = FALSE) + # Remove legend
  scale_fill_identity() + # Use actual colors specified in the 'Fill' column
  theme_minimal() + # Use a minimal theme
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.35),
    plot.margin = unit(c(1, 1, 1, 1), "cm"), # Adjust plot margins if necessary
    axis.title.y = element_blank(),  # Remove the y-axis title
    axis.title.x = element_blank()   # Remove the x-axis title
  ) +
  labs(
    title = "SCHOOL AVERAGE PERFORMANCE BY COUNTRY",
    subtitle = "Calculated as the average of Math, Science, and Read competency",
    x = "Country",
    y = "Average Performance",
    caption = "Conclusion: School scores in Greece are skewed towards the high end, albeit there is a significant variability"
  )

box_plot

# ----

pisa_data <- pisa_data %>%
  mutate(line_size = ifelse(CNT %in% c("Greece", "B-S-J-Z (China)", "Dominican Republic"), 1.5, 0.1),  # Thicker line for Greece, China, and Kongo
         color = ifelse(CNT == "Greece", custom_palette[2], "grey50"))

# --------------------------------------------------
x_limits <- c(200, 750)
y_limits <- c(0, 0.007)

# Create the density plots
plot1 <- ggplot(pisa_data, aes(x = MATH)) + 
  geom_density(aes(group = CNT, color = color, size = line_size), alpha = 0.5) +
  labs(title = "Math",
       x = "Math Score",
       y = "Density") +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_color_identity() +
  scale_size_identity() +
  coord_cartesian(xlim = x_limits, ylim = y_limits) +
  annotate("text", x = 310, y = 0.0068, label = "Dominican Republic", color = "grey50") +
  annotate("text", x = 460, y = 0.0054, label = "Greece", color = custom_palette[2], fontface = "bold") +
  annotate("text", x = 615, y = 0.0059, label = "B-S-J-Z (China)", color = "grey50")+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank())

plot2 <- ggplot(pisa_data, aes(x = SCIE)) + 
  geom_density(aes(group = CNT, color = color, size = line_size), alpha = 0.5) +
  labs(title = "Science",
       x = "Science Score",
       y = "") +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_color_identity() +
  scale_size_identity() +
  coord_cartesian(xlim = x_limits, ylim = y_limits) +
  annotate("text", x = 260, y = 0.0067, label = "Dominican Republic", color = "grey50") +
  annotate("text", x = 465, y = 0.0054, label = "Greece", color = custom_palette[2], fontface = "bold") +
  annotate("text", x = 625, y = 0.0054, label = "B-S-J-Z (China)", color = "grey50")+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank())

plot3 <- ggplot(pisa_data, aes(x = READ)) + 
  geom_density(aes(group = CNT, color = color, size = line_size), alpha = 0.5) +
  labs(title = "Reading",
       x = "Reading Score",
       y = "") +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_color_identity() +
  scale_size_identity() +
  coord_cartesian(xlim = x_limits, ylim = y_limits) +
  annotate("text", x = 220, y = 0.0043, label = "Dominican Republic", color = "grey50") +
  annotate("text", x = 495, y = 0.0048, label = "Greece", color = custom_palette[2], fontface = "bold") +
  annotate("text", x = 625, y = 0.0048, label = "B-S-J-Z (China)", color = "grey50")+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank())

# Combine plots into one with one subplot per row
density <- plot1 + plot2 + plot3 +
  plot_layout(ncol = 1, guides = 'collect') +
  plot_annotation(title = "DISTRIBUTION OF STUDENT PERFORMANCES BY COUNTRY",
                  caption="Conclusion: Reading is the hardest subject for students. Greece holds almost the same position in all subjects. Dominican Republic is no longer the lowest performing country in Reading.",
                  ) +
  plot_annotation(theme = theme(plot.margin = margin(1, 1, 1, 1, "cm")))

print(density)

# Save as png

# Parcoord plot ----------------------------------------------------------------------------------------------------
# Prepare the data for Mother's Education Level
mother_performance <- pisa_data %>%
  group_by(CNT, ST005Q01TA) %>%
  summarise(Avg_Performance = mean(Performance, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = ST005Q01TA, values_from = Avg_Performance) %>%
  select(-'NA') %>%
  select(1, ncol(.) : 2) %>%
  mutate(alpha = ifelse(CNT %in% c("B-S-J-Z (China)", "Dominican Republic", "Greece"), 1, 0.1),
         Country = factor(case_when(
           CNT %in% c("Greece", "Dominican Republic", "B-S-J-Z (China)") ~ CNT,
           TRUE ~ "Other"
         ))) %>%  
  rename("Did not complete" = "She did not complete  ISCED level 1")%>%  
  rename(" " = "ISCED level 3A")

# Prepare the data for Father's Education Level
father_performance <- pisa_data %>%
  group_by(CNT, ST007Q01TA) %>%
  summarise(Avg_Performance = mean(Performance, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = ST007Q01TA, values_from = Avg_Performance) %>%
  select(-'NA') %>%
  mutate(alpha = ifelse(CNT %in% c("B-S-J-Z (China)", "Dominican Republic", "Greece"), 1, 0.1),
         Country = factor(case_when(
           CNT %in% c("Greece", "Dominican Republic", "B-S-J-Z (China)") ~ CNT,
           TRUE ~ "Other"
         ))) %>%  
  rename("Did not complete" = "He did not complete  ISCED level 1")

cChina <- "gray40"
cGreece <- custom_palette[2]
cDominican <- "gray40"
# Plot for Mother's Education Level
plot1 <- ggparcoord(
  data = mother_performance,
  columns = 2:6,
  groupColumn = 8,
  scale = "globalminmax",
  alpha = "alpha",
  showPoints = FALSE
) +
  scale_color_manual(values = c(cChina, cDominican, cGreece, "gray20")) +
  theme_minimal() +
  theme(
    # axis.text.y = element_blank(),
    # axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.x = element_blank(),
    # axis.title.y = element_blank(),
    legend.position = "none",
    panel.grid.major.x = element_line(color = "gray", linewidth = 0.5),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = unit(c(0, 0, 0, 0), "points")  # Remove all margins
  )+
  labs(title = 'Mother', y="Avg. Performance Score (per Country)") +
  scale_x_discrete(expand = c(0, 0))


# Plot for Father's Education Level
plot2 <- ggparcoord(
  data = father_performance,
  columns = 2:6,
  groupColumn = 8,
  scale = "globalminmax",
  alpha = "alpha",
  showPoints = FALSE
) +
  scale_color_manual(values = c(cChina, cDominican, cGreece, "gray20")) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    # axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none",
    panel.grid.major.x = element_line(color = "gray", linewidth = 0.5),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = unit(c(0, 0, 0, 0), "points")  # Remove all margins
  )+
  labs(title = "Father")+
  scale_x_discrete(expand = c(0, 0))

plot3 <- ggplot() +
  annotate("text", x = 0, y = 320, label = "Dominican Republic", 
           vjust=-3.5, 
           color = cDominican) +
  annotate("text", x = 0, y = 380, label = "Greece", 
           hjust=1.2,
           color = cGreece, fontface = "bold") +
  annotate("text", x = 0, y = 550, label = "B-S-J-Z (China)", 
           vjust = 12,
           color = cChina)+
  theme_void()

# Combine the plots directly
parcoord <- plot1 + plot2+ plot3 +
  plot_layout(width = c(1,1,0.33), ncol = 3, guides = 'collect') +
  plot_annotation(title = "STUDENT PERFORMANCE BY PARENT EDUCATION LEVEL",
                  subtitle = "Education level is highest in the middle and falls off towards the edges",
                  caption="Conclusion: In most cases student performance increases with parent's education level. Father's education level has slightly greater impact.",
  ) +
  plot_annotation(theme = theme(plot.margin = margin(1, 1, 1, 1, "cm")))

# Print the combined plot
print(parcoord)


# Rename Pisa Columns ----------------------------------
pisa_data <- pisa_data %>%
  rename(Country = CNT,
         School = CNTSCHID,
         Grade = ST001D01T,
         MonthOB = ST003D02T,
         YearOB = ST003D03T,
         Gender = ST004D01T,
         Mother = ST005Q01TA,
         Father = ST007Q01TA)

str(pisa_data)

# YOB log ------------------------------------
df <- as.data.frame(table(pisa_data$Country, pisa_data$YearOB))
names(df) <- c('Country','Year','Participants')

# Plot heatmap
heatmap_actual <- ggplot(df, aes(x = Country, y = Year, fill = Participants)) +
  geom_tile(color = "gray80") +
  scale_fill_gradient(low = "white", high = "black") +  # Adjust color gradient as needed
  # scale_fill_viridis(discrete=FALSE) +
  labs(x = "Year", y = "Country") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.35,
      # face = "bold",
      color = ifelse(df$Country == "Greece", custom_palette[2], "grey40"),
    ),
    axis.title.x = element_blank(),
    legend.position = "right",
    plot.margin = margin(1,1,1,1,"cm")
  )+
  labs(title = "STUDENT PARTITIPATION",
       subtitle = "Actual scale",
       y = "Year of birth",
       caption = "Conclusion: Spain leads in participations. Israel is the country with the youngest participating students. Cyprus and Moscow City did not report student age.")

print(heatmap_actual)

df <- df %>%
  mutate(log_Participants = log(Participants + 0.1))

# Plot heatmap
heatmap_log <- ggplot(df, aes(x = Country, y = Year, fill = log_Participants)) +
  geom_tile(color = "gray80") +
  scale_fill_gradient(low = "white", high = "black") +  # Adjust color gradient as needed
  # scale_fill_viridis(discrete=FALSE) +
  labs(x = "Year", y = "Country") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.35,
      # face = "bold",
      color = ifelse(df$Country == "Greece", custom_palette[2], "grey40"),
    ),
    axis.title.x = element_blank(),
    legend.position = "none",
    plot.margin = margin(1,1,1,1,"cm")
  )+
  labs(title = "STUDENT PARTITIPATION",
       subtitle = "Logarithmic scale",
       y = "Year of birth",
       caption = "Conclusion: Spain leads in participations. Israel is the country with the youngest participating students. Cyprus and Moscow City did not report student age.")

print(heatmap_log)

# Stars --------------------------------------------------------

# Define the dimensions of the grid
num_plots <- 80
cols <- 10
rows <- 8

# Scale factor for increasing space between plots
scale_factor <- 3  # Adjust this factor to increase/decrease spacing

# Generate the x and y coordinates
x_coords <- seq(1, cols, length.out = cols)
y_coords <- seq(1, rows, length.out = rows)
scaled_x_coords <- x_coords * scale_factor
scaled_y_coords <- (rows - y_coords + 1) * scale_factor  # Reverse the order for y
coordinates <- expand.grid(x = scaled_x_coords, y = scaled_y_coords) # Create a two-column matrix with all combinations of scaled x and y coordinates
coordinates <- coordinates[order(-coordinates$y, coordinates$x), ] # Order coordinates from top to bottom
coord_matrix <- as.matrix(coordinates) # Convert to a matrix, if needed

starsDF <- pisa_data %>%
  group_by(Country, Grade) %>%
  summarise(Avg_Performance = mean(Performance, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = Grade, values_from = Avg_Performance) %>% 
  column_to_rownames(var = "Country")

# Order starsDF based on the indices
indices <- match(rownames(starsDF), average_performance$CNT)
starsDF <- starsDF[order(indices), ]
rownames(starsDF)[rownames(starsDF) == "Vietnam"] <- ""

stars(
  starsDF,
  main = "AVERAGE PERFORMANCE PER GRADE",
  # sub = "Notice the relationship between Country and Grade-over-Grade fluctuation",
  key.labels = names(starsDF),
  key.loc = c(31, 2.9),
  cex=0.7,
  full = T,
  draw.segments = TRUE,
  col.segments = palette,
  locations = coord_matrix,
)

# Scatter -------------------------------------------------------------------
# Data preparation with color assignment
df <- pisa_data %>%
  group_by(Country, Gender) %>%
  summarise(Avg_Performance = mean(Performance, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = Gender, values_from = Avg_Performance) %>%
  select(-`NA`) %>%
  na.omit() %>%
  mutate(Color = ifelse(Female < Male, custom_palette[1], 
                        ifelse(Country == "Greece", custom_palette[2], "grey40")))

# Plotting
scatterplot <- ggplot(data = df, aes(x = Male, y = Female)) +
  geom_point(aes(color = Color), size = 3, shape = 19) +  # Specify 'color' within aes()
  geom_text_repel(aes(label = ifelse(Female < Male, as.character(Country), ""), color = "gray40"),
                  nudge_x = 20, nudge_y = -10,
                  box.padding = 0.40, 
                  point.padding = 0.3,
                  max.overlaps = Inf) +
  geom_text_repel(aes(label = ifelse(Country == "Greece", as.character(Country), ""), color = Color),
                  nudge_x = -20, nudge_y = 5,
                  vjust = -1,
                  hjust = 0,) +
  geom_abline(intercept = 0, slope = 1, color = "black", linetype = "longdash", alpha = 0.5) +
  theme_minimal() +
  labs(title = "GENDER PERFORMANCE COMPARISON", subtitle = "Comparison of Male and Female Average Performance by Country", 
        caption = "Conclusion: With the exception of Latin America region, Females constantly outperform Males.",
        x = "Male (Avg. Score)", y = "Female (Avg. Score)") +
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
  scale_color_identity() +  # Use actual color names in 'Color' column
  scale_x_continuous(limits = c(300, 600)) +
  scale_y_continuous(limits = c(300, 600))


print(scatterplot)

oldDF <- df
# H bars gender gap ----------------------------
# Reshape the data for plotting
df <- oldDF %>%
  arrange((Female))%>%
  mutate(Color = ifelse(Female < Male, custom_palette[1], 
                        ifelse(Country == "Greece", custom_palette[2], "gray40"))) %>%
  arrange((Female))

# Convert Country to a factor and specify the order directly from the dataframe
df$Country <- factor(df$Country, levels = df$Country)

# df <- df[match(average_performance$CNT, df$Country), ]
# df <- factor(df$Country, levels = df$Country)

# Plot
lollipop <- ggplot(df) +
  geom_segment( aes(x=Country, xend=Country, y=Male, yend=Female), color=df$Color, size=2 ) +
  geom_point( aes(x=Country, y=Female), shape=18, color=df$Color, size=2.5 ) +
  coord_flip() +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.title.y = element_blank(),
    axis.text.y = element_text(size = rel(0.8), color=df$Color),
    axis.ticks.y = element_blank(),
    strip.text.x = element_text(size = rel(0.8), color=df$Color),
    axis.ticks.x = element_blank(),
    plot.margin = margin(1,1,1,1, "cm"),
    panel.grid.major.y = element_blank(),  # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(),  # Remove minor horizontal grid lines
    panel.grid = element_line(color = rgb(235, 235, 235, 100, maxColorValue = 255), linewidth = 0.5),  # Adjust opacity of vertical grid lines
  ) +
  scale_y_continuous(limits = c(300, NA)) +
  labs(
    title = "GENDER PERFORMANCE GAP",
    subtitle = "How much Females outperform Males in Average Performance by Country",
    caption = "Conclusion: With a few exceptions, Females constantly outperform Males.",
    y = "Avg. Score",
  ) +
  geom_text(data = df[df$Country == 'Singapore',], aes(x = Country, y = Female, label = 'Female'), hjust = -0.1, vjust = 0.3, fontface="bold", color="gray40") +
  geom_text(data = df[df$Country == 'Singapore',], aes(x = Country, y = Male, label = 'Male'), hjust = 1.1, vjust = 0.3, fontface="bold", color="gray40") 

print( lollipop )

oldDF <- df
# Waterfalls----
# Prepare and transform the data
df <- pisa_data %>%
  group_by(Country, Gender) %>%
  summarise(
    Math = mean(MATH, na.rm = TRUE),
    Science = mean(SCIE, na.rm = TRUE),
    Reading = mean(READ, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(
    cols = c("Math", "Science", "Reading"),
    names_to = "Subject",
    values_to = "Score"
  ) %>%
  group_by(Country, Subject) %>%
  summarise(
    Difference = -diff(Score),
    .groups = "drop"
  ) %>%
  filter(complete.cases(.)) %>%
  mutate(mycolor = ifelse(Difference > 0, "Female", "Male"))

# Reorder factors
df$Country <- factor(df$Country, levels = oldDF$Country)

# Modify the dataframe to include a color for each country, especially handling 'Greece'
df <- df %>%
  mutate(axis_color = ifelse(Country == "Greece", custom_palette[2], "gray40"))

# Plot using the modified dataframe
waterfall<- ggplot(df, aes(x = Difference, y = Country, group = Country)) +
  geom_segment(aes(x = 0, xend = Difference, yend = Country, color = mycolor), size = 2 ) +
  facet_grid(cols = vars(Subject)) +
  scale_color_manual(values = c("Female" = custom_palette[5], "Male" = custom_palette[4])) +
  labs(
    title = "GENDER DIFFERENCES IN EDUCATIONAL PERFORMANCE",
    subtitle = "Comparison across Countries by Subject",
    caption = "",
    x = "Difference in Scores",
    y = NULL,  # Removes the y-axis title
    color = "Best \nPerformance"  # Rename legend
  ) +
  theme_minimal() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    legend.position = "right",
    axis.text.y = element_text(color = df$axis_color, size = rel(0.8)),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  )
print(waterfall)

#----
# Set up the PDF file
pdf("01_Report.pdf", width = 11, height = 8.5)  # Landscape orientation
barchart
box_plot
stacked_bars
density
parcoord
stars( starsDF, main = "AVERAGE PERFORMANCE PER GRADE", key.labels = names(starsDF), key.loc = c(31, 2.9), cex=0.7, full = T, draw.segments = TRUE, col.segments = palette, locations = coord_matrix,)
heatmap_actual
heatmap_log
scatterplot
lollipop
waterfall
dev.off()
