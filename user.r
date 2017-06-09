#Importing the Libraries

library(dplyr)
library(purrr)
library(twitteR)
library(ROAuth)
library(tidyr)
library(wordcloud)
library(tm)
library(RColorBrewer)



#Settting Up the authentication keys.
consumer_key <- "EUxZ38sUm0c3S55R1b0Xm"
consumer_secret <- "OrHmCpQhnEOpiVYYoGrykWmI2TDKHQZGs4bCkNCE9OH4D"
access_token <- "375521614-2UU02lfzuXBKSyemTYeXihDUOhQtmqrbPx"
access_secret <- "B3llgFYzISEGGbOEnDyCT14Oc1cdrYSR84eRBV70"


#You'd need to set global options with an authenticated app
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


#We can request only 3200 tweets at a time; it will return fewer
#depending on the API

nm_tweets <- userTimeline("nomadicmatt", n = 3200)
nm_tweets_df <- tbl_df(map_df(nm_tweets, as.data.frame))

###########################################################
# (tidyr)
###########################################################

tweets <- nm_tweets_df %>%
  select(id, statusSource, text, created) %>%
  extract(statusSource,"source", "Twitter for (.*?)<") %>%
  filter(source %in% c("iPhone", "Android"))

#Overall, this includes r sum(tweets$source == "iPhone") tweets from iPhone, and r sum(tweets$source == "Android") tweets from android.
#One consideration is what time of the day tweets occur, which we'd expect to be a "signature" of their user. Here we can
# certainly spot a difference.


#############################################################
# (wordcloud)
# (tm)
#############################################################

set.seed(1234) #to always get the same wordcloud and for better reproductibility

wc_tweets <- unlist(lapply(nm_tweets, function(t) { t$text}))

#to extract only the text of each status object

words <- unlist (strsplit(wc_tweets, " "))
words <- tolower(words)

clean_words <- words[-grep("http|@|#|ü|ä|ö", words)] 

#remove urls, usernames, hashtags and umluats(the latter can not be displayed by all fonts)

wordcloud(clean_words, min.freq = 2)
wordcloud(clean_words, min.freq=2, vfont=c("serif", "plain"))
wordcloud(clean_words, min.freq=2, vfont=c("script", "plain"))
wordcloud(clean_words, min.freq=2, vfont=c("gothic italian", "plain"))

############################################################
#(RColorBrewer)
############################################################

#Designing the wordcloud
pal<-brewer.pal(7, "Pastel1")
par(bg="darkgray")
wordcloud(clean_words, min.freq=2, vfont=c("script", "plain"), colors=pal)


# Done
