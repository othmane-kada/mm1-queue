library(simmer)
library(simmer.plot)
library(progress)
library('mapfit')
set.seed(1234)
lambda=1 # any value
mu=1 # any value
ro=lambda/mu

m.queue <- trajectory() %>%
  seize("server", amount=1) %>%
  timeout(function()  rexp(1, rate=mu)) %>%
  release("server", amount=1)
mm1.env <- simmer() %>%
  add_resource("server", capacity=1, queue_size=Inf) %>%
  add_generator("arrival", m.queue, function() rexp(n=1, rate=lambda))%>%
  run(until =10000000, progress=progress_bar$new()$update, steps = 1)
a=get_mon_arrivals(mm1.env)%>%
  transform(waiting_time = ifelse ((end_time - start_time - activity_time)<0,0,(end_time - start_time -activity_time) ))
mean(a$waiting_time)
