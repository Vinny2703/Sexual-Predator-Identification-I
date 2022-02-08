#Modell1 orginal Corpus und Conversationsstart Feature
#Variablen
epochs<-30
batch_s<-8
lr<-0.0001
word_vector <- layer_input(shape = (NULL))
other_feature <- layer_input(shape = (extraInput)) 
a_embedding<- layer_embedding(one_hot_vectorsize,embedd_v_dim)(autorvec)
conv1D_1 <- layer_conv_1d(40, 1,padding = 'same', activation ='relu' )(a_embedding) 
conv1D_3 <- layer_conv_1d(40,3,padding = 'same',activation ='relu')(a_embedding)
conv1D_5 <- layer_conv_1d(40,5,padding = 'same',activation ='relu')(a_embedding)
conv1D_7 <- layer_conv_1d(40,7,padding = 'same', activation ='relu')(a_embedding) 
x<- layer_concatenate(list(conv1D_1, conv1D_3,conv1D_5,conv1D_7))
autor_embedding <-layer_embedding()

model1 <- keras_model_sequential()
model1%>% word_vector
embedding %>% 
  x %>%
  y<-layer_max_pooling_1d()%>%
  layer_concatenate(list(y, other_feature))%>%
  layer_dense(units=20, activation ='tanh' )%>%
  layer_dropout(0,5) %>%
  layer_dense(units=1, activation = 'sigmoid')

#Training
#Metric festlegen
metric <- c(metric_precision(name = 'precision'), metric_recall(name = 'recall'))
#compile
model1%>% compile(
  loss = 'binary_crossentropy',
  optimizer=optimizer_adam(lr=lr),
  metrics=metric
)
#fit
tensorboard("logs/run_a")
hist1<-fit_generator(
  #object,
  epochs = epochs,
  batch_size =batch_s,
  callbacks = list(
    callback_model_checkpoint(file.path(path,"model1_checkpoint.hdf5"), period = 10, save_freq = 'epoch'),
    callback_tensorboard(log_dir = file.path(path,"model1_logs"))
))
save_model_hdf5(model1,"model1/")

#testen
#Model1 laden
model1<-load_model_hdf5("model1/")

