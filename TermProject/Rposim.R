library(bigmemory)

# We need a manager which tells the clients (in different R terminal instances)
# when they are supposed to be paused and when they can execute their events

# The clients keep track of their tasks, and perform the necessary processes once
# they are allowed to

