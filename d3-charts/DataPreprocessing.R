library(mongolite)
library(tm)
library(SnowballC)

mongo = mongo(collection = "events", db = "precog_fb_data", url = "mongodb://localhost", verbose = TRUE)
categories = c('travel', 'food', 'music', 'art', 'education')

all_events = list()
for(cat in categories){
  temp_cursor = mongo$find(paste('{"category":"',cat,'"}',sep=""))
  temp = paste(temp_cursor$description, collapse = '')
  all_events[[cat]] = gsub("\n"," ", temp)
  all_events[[cat]] = gsub("\t"," ", all_events[[cat]])
  #print(all_events[[cat]])
  dat2 <- unlist((strsplit(all_events[[cat]], split=" ")))
  dat3 <- grep("dat2", iconv(dat2, "latin1", "ASCII", sub="dat2"))
  dat4 <- dat2[-dat3]
  all_events[[cat]] <- paste(dat4, collapse = " ")
  print(paste0("Number of characters in category : ",cat," - ",nchar(all_events[cat])))
}

#text preprocessing
words_list = list()
for(cat in categories){
  docs = Corpus(VectorSource(all_events[[cat]]))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english common stopwords
  docs <- tm_map(docs, removeWords, stopwords("english"))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Stemming
  #docs <- tm_map(docs,stemDocument)
  #creating a document term matrix for each category
  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  write.csv(d,paste0("dtm-",cat,".csv"))
  #create a list of words and removing two letter words
  words_list_temp = strsplit(docs[[1]]$content, split=" ")
  j = 1
  for(i in 1:length(words_list_temp[[1]])){
    if(nchar(words_list_temp[[1]][[i]])>2 & nchar(words_list_temp[[1]][[i]])<=15){
      words_list[[cat]][[j]] = words_list_temp[[1]][[i]]
      j=j+1
    }
  }
}

for(cat in names(words_list)){
  print(paste0("Category: ", cat))
  print(length(words_list[[cat]]))
  print(words_list[[cat]][seq(1:25)])
}