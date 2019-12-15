library(tm)
library(stringr)
library(plyr)
library(dplyr)
library(udpipe)
library(tidyr)
library(tidytext)

# Import csv files (as dataframes)
ads <- read.delim('~/Downloads/textmining/hhucap/scripts/metadata/83249531X_1900_output/1900.csv', header = T)

# Set functions
#Tagger
tag_f <- function(arg1) {
  x <- as.data.frame(udpipe_annotate(udmodel_dutch, x = arg1, tagger = "default", parser = "none") )
  tags <- paste(x$token, sep = '_', x$upos)
  tags
}

# Unlister
unlist_f <- function(arg2){
  paste(unlist(arg2), collapse = ' ')
}

#Set Occupations Titles for Matching
# Note! List of occupations is checked for duplicates in linux terminal -->
oc_file <- read.table("~/Downloads/textmining/hhucap/scripts/output.txt")
oc_file$V1 <- gsub("[^[:alpha:]]", "", oc_file$V1)
oc_file$V1 <- gsub("\\b[[:alpha:]]{13,}\\b", '', oc_file$V1) #remove long occupations
oc_file <- oc_file %>% filter(oc_file$V1 != '')
words <- paste0(oc_file$V1, collapse = "|")

#Set POS-Tagger
dl <- udpipe_download_model(language = "dutch")
udmodel_dutch <- udpipe_load_model(file = dl$file_model)

########################## TOTAL ####################################33333
ads_f <- function(x) {
  corpus<-Corpus(VectorSource(x$ocr))
  corpus<-tm_map(corpus, removeNumbers)
  corpus<-tm_map(corpus, content_transformer(tolower))
  corpus<-tm_map(corpus, removeWords, stopwords('dutch'))
  corpus<-tm_map(corpus, removePunctuation)
  
  x$ocr<-unlist(as.list(corpus))  
  
  subset <- x %>% 
    filter(str_detect(x$ocr, words))
  
  subset$tags <- lapply(subset$ocr, tag_f)
  subset$tags <- lapply(subset$tags, unlist_f)
 # subset$adjectives <- str_extract(subset$tags,"<?=\\_ADJ")
  subset
}

tags <- ads_f(ads)

# Save output
adstags_210_1910 <- tags
adstags_210_1885$adj <- for(i in adstags_210_1885$tags){
  string <- unlist(i)
  string <- as.character(string)
  grepl(string, "ADJ")
}
write.table(tags, file = "~/Downloads/textmining/hhucap/scripts/metadata/852115210_1885_output/852115210-1885-tags.csv")

tags_$adjectives[1] <- str_extract(tags_$tags[1],"<?=\\_ADJ")

tags_$adjectives[1] <- gsub("(?!ADJ\\b)", "", tags_$tags[1])
