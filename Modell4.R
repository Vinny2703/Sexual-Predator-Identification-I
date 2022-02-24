#Modell4 eigener Corpus und Spam Feature und Conversationsstart Feature
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

model4 <- keras_model_sequential()
model4%>% word_vector
embedding %>% 
  x %>%
  y<-layer_max_pooling_1d()%>%
  layer_concatenate(list(y, other_feature))%>%
  layer_dense(units=20, activation ='tanh' )%>%
  layer_dropout(0,5) %>%
  layer_dense(units=1, activation = 'sigmoid')

set.seed(123)
inp <- sample(2, nrow(tc_e), replace = TRUE, prob c(0.7, 0.3))
training_tc_e <- tc_e[inp==1, ]
test_tc_e <- tc_e[inp==2, ]

#Training
#Metric festlegen
metric <- c(metric_precision(name = 'precision'), metric_recall(name = 'recall'))
#compile
model4%>% compile(
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
    callback_model_checkpoint(file.path(path,"model4_checkpoint.hdf5"), period = 10, save_freq = 'epoch'),
    callback_tensorboard(log_dir = file.path(path,"model4_logs"))
))
save_model_hdf5(model4,"model4/")

#testen
#Modell4 laden
model4<-load_model_hdf5("model4/")

