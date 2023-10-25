library(ggplot2)
library(dplyr)

#Assigning df from the imported file.
df <- 

#Assigning new column names
colnames(df) <- c("ExperimentFileName","Well", "Sample_Name", "Target_Name", "Ct")

#NA introduced by coercion
df$Ct <- as.numeric(as.character(df$Ct))


#Average out Ct values based on sample name, remember backticks are required, cause '' is treated like a regular string
df_average <- df %>%
  group_by(`Sample_Name`, `Target_Name`) %>%
  summarise(mean_Ct = mean(Ct, na.rm = TRUE),
            sd_Ct = sd(Ct, na.rm = TRUE), 
            .groups = 'drop')

#Visualizes data in bar graph. 
ggplot(df_average, aes(x = `Sample_Name`, y = `mean_Ct`, fill = `Target_Name`)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
  geom_errorbar(
    aes(ymin = mean_Ct - sd_Ct, ymax = mean_Ct + sd_Ct),
    width = 0.25, 
    position = position_dodge(width = 0.8)
  ) +
  geom_rect(
    aes(xmin = -Inf, xmax = Inf, ymin = 28, ymax = 31.5),
    data = ~ subset(., `Target_Name` == "IC"),
    fill = "gray",
    alpha = 0.3
  ) +
  geom_text(
    aes(label = round(mean_Ct, 2), y = mean_Ct), 
    position = position_dodge(width = 0.8), 
    vjust = -0.5
  ) +
  geom_hline(
    aes(yintercept = 38.5),
    data = ~ subset(., `Target_Name` != "IC"),
    linetype = "dotted",
    color = "black",
    size = 0.85
  ) +
  labs(title = "20231024_EntroGen_qPCR_1", 
       y = "Mean Ct", 
       x = "Sample Name", 
       fill = "Target Name") +
  theme() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  ) +
  facet_wrap(~`Target_Name`, scales = "free_x")


