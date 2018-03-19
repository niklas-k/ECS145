# This is a sample application of Rposim's Process-Oriented DES
# 
# These are just the functions that need to be defined by the user
# in order to actually run the simulation, one must run three instances
# of R, one as the manager, a second as the baristas, and the third
# as the customers. This is the case as they need to be actively
# listening and interacting with the manager throughout the simulation
# 
# Instructions for running simulation:
#   1. Open a new terminal window and invoke R
#   2. Load Rposim.R and BaristaDES.R
#   3. Call the Rposim newsim function
#      a. pass a vector of processes into newsim
#      b. these are represented by the application specific flow functions
#         so we are basically passing functions into newsim
#      c. also pass a value for the time limit into newsim
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
maxTime <- 4000
baristas <- c(1, 1)              # represents 2 baristas and their initial states
customers <- c(1, 1, 1, 1, 1, 1) # represents 6 customers and their initial states



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
		# listen for an update from the manager aka an order
		# maybe represented by a boolean value in shared matrix
		# take the order and make the drink                     == adds event to queue
		# clean the machine                                     == adds event to queue
		
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
		# read menu and decide on an order                      == adds event to queue
		# listen for an update from the manager
		# place order                                           == adds event to queue
		
}

# run simulation
times <- newsim(c(baristaFlow, customerFlow), maxTime)
