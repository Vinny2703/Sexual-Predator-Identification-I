#packages
library("keras")
install_keras()
library("tensorflow")

#Feature Extractor CNN und Autoren Klassifikation 
word_vector <- layer_input(shape = (NULL))
other_feature <- layer_input(shape = (extraInput)) 
  a_embedding<- layer_embedding(one_hot_vectorsize,embedd_v_dim)(autorvec)
  conv1D_1 <- layer_conv_1d(40, 1,padding = 'same', activation ='relu' )(a_embedding) 
  conv1D_3 <- layer_conv_1d(40,3,padding = 'same',activation ='relu')(a_embedding)
  conv1D_5 <- layer_conv_1d(40,5,padding = 'same',activation ='relu')(a_embedding)
  conv1D_7 <- layer_conv_1d(40,7,padding = 'same', activation ='relu')(a_embedding) 
  x<- layer_concatenate(list(conv1D_1, conv1D_3,conv1D_5,conv1D_7))
  autor_embedding <-layer_embedding()

  model <- keras_model_sequential()
model%>% word_vector
  embedding %>% 
  x %>%
  y<-layer_max_pooling_1d()%>%
  layer_concatenate(list(y, other_feature))%>%
  layer_dense(units=20, activation ='tanh' )%>%
  layer_dropout(0,5) %>%
  layer_dense(units=1, activation = 'sigmoid')


summary(model)
