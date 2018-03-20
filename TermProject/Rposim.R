library(bigmemory) # used to share memory between the manager and the different processes

# newsim
# 
# Inputs: processVec - vector of application specific processes
#         endOfSim - time limit for the simulation
#         ncols - based off the number of instances in each process, this is the max number
#                 of cols necessary in the shared matrix
# 
# Creates a new manager object, links the processes to the manager, and runs the manager

newsim <- function(processVec, endOfSim) {
    # creation of manager, which keeps track of time and waking up of each process
    mgr <- managerInit(processVec, endOfSim)
    
    # creates shared matrix
    data <- big.matrix(10, 10, type='integer') # 10x10 big matrix
    mgr$data <- data
    
    # creation of a thread for each item in processVec and manages each process
    id <- 1
    for (process in processVec) {
        makeThread(process, id, data)
        id <- id + 1
    }
    
    # now that everything is set up, we will run the simulation
    # returns a times object, which includes all necessary analysis
    run(mgr)
}

# managerInit
# 
# Inputs: processVec - vector of application specific processes
#         endOfSim - time limit for the simulation
# 
# Attributes: processes - vector containing all processes for the simulation, these will
#                         end up being run in different instances of R (pseudo-threads)
#             numProcesses - total number of processes in the simulation
#             curTime - current time in the simulation
#             maxTime - maximum duration of simulation
#             events - vector containing all unreacted events in the simulation
# 
# Creates a manager object which controls the simulation - i.e. keeps track of current time, 
# max time, processes, number of processes, and the pending events in the simulation

managerInit <- function(processVec, endOfSim) {
    me <- list()
    
    me$processes <- processVec
    me$numProcesses <- length(processVec)
    me$curTime <- 0
    me$maxTime <- endOfSim
    me$events <- c()
    
    class(me) <- 'manager'    
    return(me)
}

# makeThread
# 
# Inputs: process - function which will be called in the R instance, this is a function
#                   set-up to listen for the manager as it represents a process in the DES
#         processID - each process has an id in order to keep track of it
#         data - the shared matrix, which needs to be linked to the process
# 
# Creates a new terminal instance of R calling the appropriate process function

makeThread <- function(process, processID, data) {
    # open new instance of R
    system2(command="xterm", args=print("R")) # is there a better way to create a new R terminal??
    
    # need to figure out how to call the process function in that new instance of R
    # this will hopefully be correctly linked with the bigmemory matrix
    
    # one possible approach to this would be to create a .R file for each process
    # and open the xterm with the command Rscript process_n.R where the file would
    # load Rposim.R and the implementation (such as BaristaDES.R) and then simply
    # run the processFlow function for the particular process
}

# newEvent
# 
# Inputs:  time - given time, make event for that time
#		   eventType - given event type, used when event is pulled out of list at execution time
# Outputs: me - new event object to add to list
# 
# creates event object for list

newEvent(time, eventType) {
	me <- list()
	me$time <- time
	me$eventType <- eventType
	class(me) <- "listEntry"
	return(me)
}

# addEvent
# 
# Inputs: eventList - mgr$list, list to add new event to
#		  time - given time, add event for that time
#		  eventType - given event type, used when event is pulled out of list at execution time
# 
# Outputs: eventList - list which contains new event
# 
# Adds new event to event list

addEvent <- function(eventList,time,eventType) {
	newEntry <- newEvent(time,eventType)
	eventList.append(me)
	return(eventList)
}

# getTimedEvents
# 
# Inputs: eventList - mgr$list, list of all scheduled events
#		  time - current time, check for events at time
# 
# Outputs: events - list of events at this time, usually only one
# 
# gets the events scheduled for the current time

getTimedEvents <- function(eventList,time) {
	events <- list()
	for (i in eventList) {
		if(i$time == time)
			events.append(i)
			#remove from eventList after end of function
	}
	return(events)
}

# run
# 
# Inputs: mgr - manager object which has all the neccessary attributes of the simulation
# 
# Outputs: results - list which contains all of the results of the simulation
# 
# Runs the simulation until the maxTime is reached or there are no more events to be processed

run <- function(mgr) {
    results <- list()
	# set remove condition for events to be triggered
    removeCondition <- sapply(mgr$events, function(x) x$time != mgr$curTime)
    while (mgr$curTime < mgr$maxTime) {  
        # ...
		triggeredEvents <- getTimedEvents(mgr$events, mgr$curTime)
		mgr$events <- mgr$events[removeCondition]
        for (i in triggeredEvents){ # loop only relevant if multiple events at same time
			# handle event function from sim implementation as well as stats updating
			results <- handleEvent(i$eventType, results)
		}
        mgr$curTime <- mgr$curTime + 1
    }
    
    class(results) <- 'times'
    return(results)
}

# yield
# 
# Function necessary for applications, this waits for a signal from the manager that
# the process may proceed to the next step in its flowchart

yield <- function() {
    while (True) {
        # figure out how to signal from the manager that the process may proceed
        # probably easiest with a boolean variable in the shared matrix
    }
}
