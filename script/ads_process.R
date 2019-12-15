library(tm)
library(stringi))
library(udpipe)

# Import csv files (as dataframes)
ads <- read.delim('script/metadata/832495182_output/1915.csv', header = T)

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
oc_file <- read.table("script/output.txt", header = TRUE)
oc_file$V1 <- gsub("[^[:alpha:]]", "", oc_file$V1)
oc_file$V1 <- gsub("\\b[[:alpha:]]{13,}\\b", '', oc_file$V1) #remove long occupations
oc_file <- subset(oc_file, oc_file$V1 != '')
words <- paste0(oc_file$V1, collapse = "|")

#Set POS-Tagger
dl <- udpipe_download_model(language = "dutch")
udmodel_dutch <- udpipe_load_model(file = dl$file_model)

########################## TOTAL ####################################33333
ads_f <- function(x, words) {
  corpus<-Corpus(VectorSource(x$ocr))
  corpus<-tm_map(corpus, removeNumbers)
  corpus<-tm_map(corpus, content_transformer(tolower))
  corpus<-tm_map(corpus, removeWords, stopwords('dutch'))
  corpus<-tm_map(corpus, removePunctuation)
  
  x$ocr<-unlist(as.list(corpus))  
  x_subset <- x[stri_detect_regex(x$ocr, words), ]
  
  x_subset$tags <- lapply(x_subset$ocr, tag_f)
  x_subset$tags <- lapply(x_subset$tags, unlist_f)
 # x_subset$adjectives <- str_extract(x_subset$tags,"<?=\\_ADJ")
  x_subset
}

tags <- ads_f(ads, words = words)

# Save output
adstags_210_1910 <- tags
adstags_210_1910$adj <- for(i in adstags_210_1910$tags){
  string <- unlist(i)
  string <- as.character(string)
  stri_detect_regex(string, "ADJ")
}
# write.table(tags, file = "~/Downloads/textmining/hhucap/scripts/metadata/852115210_1885_output/852115210-1885-tags.csv")

tags$adjectives[1] <- stri_extract_all_regex(tags$tags[1],"(\\w+)\\_ADJ")

tags$adjectives[1] <- gsub("(?!ADJ\\b)", "", tags$tags[1])
