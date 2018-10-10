library(tidyverse)
dev_data <- read_csv('~/data/sfic_fx/Age_and_PDS_cleaned_deID.csv')

#within wave, shuffle IDs and add noise to age and PDS
dev_data_shuffled <- mutate(
  group_by(dev_data, wavenum),
  SID = sample(x = SID, size = n(), replace = FALSE),
  age = age + rnorm(n(), 0, .25),
  pds = pds + rnorm(n(), 0, .075))

dev_data_shuffled <- arrange(dev_data_shuffled,
                             wavenum, SID)

#ensure folks have a single value for 'sex'
dev_data_shuffled <- mutate(
  group_by(dev_data_shuffled, SID),
  sex = sex[1])

#check some correlations
nada <- lapply(1:3, function(x) {
  print(paste0('Wave ', x))
  print('Real data: ')
  c1 <- cor(dev_data[dev_data$wavenum == x,
               c('age', 'pds')],
      use = 'pairwise.complete.obs')
  print(c1)
  print('Shuffled data: ')
  c2 <- cor(dev_data_shuffled[dev_data_shuffled$wavenum == x,
                        c('age', 'pds')],
      use = 'pairwise.complete.obs')
  print(c2)
  print('Age cor, real w/shuffled: ')
  c3 <- cor(dev_data$age[dev_data$wavenum == x], 
      dev_data_shuffled$age[dev_data_shuffled$wavenum == x],
      use = 'pairwise.complete.obs')
  print(c3)
  print('PDS cor, real w/shuffled: ')
  c4 <- cor(dev_data$pds[dev_data$wavenum == x], 
      dev_data_shuffled$pds[dev_data_shuffled$wavenum == x],
      use = 'pairwise.complete.obs')
  print(c4)
})


write_csv(dev_data_shuffled, '~/data/not_sfic_fx/Age_and_PDS_cleaned_deID.csv')