# This is a sample application of Rposim's Process-Oriented DES
# 
# These are just the functions that need to be defined by the user. Rposim
# will automatically set up the three necessary instances of R to successfully
# run the simulation. One instance will act as the manager, while a second
# and third will act as the baristas and the customers, respectively.
# This is the case as the processes need to be actively listening and
# interacting with the manager throughout the simulation.
# 
# Instructions for running simulation:
#   1. Open a new terminal window and invoke R
#   2. Load Rposim.R
#   3. Load BaristaDES.R
#      a. this file contains executable code, which will be called upon load
#   4. This will automatically launch new R instances, calling each
#      process function (thus setting up the listening)
#   5. The simulation will be run
#   6. Corresponding information will be displayed

source('Rposim.R')

# Here there are two processes: (1) the Barista making the coffee
#                               (2) the customers placing the orders
# 
# These are described in a continuous flowchart (user defined functions)

# initialize simulation variables
maxTime <- 28800 # 28,800 seconds in 8 hours, or a typical cafe opening duration

baristas <- c(1, 1)              # represents 2 baristas  and their initial states
customers <- c(1, 1, 1, 1, 1, 1) # represents 6 customers and their initial states

# average times for the events in the barista and customer processes
DECISION_TIME <- 120 # time it takes the customer to decide upon an order
ORDER_TIME <- 80     # time it takes to place an order
DRINK_PREP <- 200    # represents the amount of time the barista needs to make the drink
MACH_CLEAN <- 45     # time it takes the barista to clean the machine

# Flowchart to describe the process of a barista, as follows:
#   1. Wait for order from customer
#   2. Recieve order and make coffee
#   3. Clean machine
# This cycle repeats until the end of the simulation
# 
# There can be any number of baristas working, these are represented
# by a vector of size n, which stores either a 1, 2 or 3 for the current
# state the barista is in
# 
# As the DES progresses the manager will tell the baristaFlow process when
# to update, thus allowing any number of baristas to move to the next step
# in their flowchart

baristaFlow <- function(baristas) {
	# while currentTime < timeLimit
		# barista is currently waiting for an order
		# yield() - listen for an update from the manager aka an order
		# addEvent() - take the order and make the drink
		# addEvent() - clean the machine
}


# Flowchart to describe the process of a customer, as follows:
#   1. Read the menu and decide
#   2. Place coffee order
# This cycle repeats until the end of the simulation
# 
# There can be any number of customers at the cafe, they are represented
# by a vector of size n, which stores either a 1 or 2 for the current
# state the customer is in
# 
# As the DES progresses the manager will tell the customerFlow process when
# to update, thus allowing any number of customers to move to the next step
# in their flowchart

customerFlow <- function(customers) {
	# while currentTime < timeLimit
		# addEvent() - read menu and decide on an order
		# yield() - listen for an update from the manager
		# addEvent() - place order
}

# run simulation
times <- newsim(c(baristaFlow, customerFlow), c(baristas, customers), maxTime)
