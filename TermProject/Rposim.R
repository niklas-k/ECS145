library(bigmemory) # used to share memory between the different processes and the manager

# newsim - creates and runs a new DES simulation
# 
# Input:
#   processVec - vector of application specific processes
#   endOfSim - time limit for the simulation
# 
# Creates a new manager object, links the processes to the manager, and runs the manager

newsim <- function(processVec, endOfSim) {
    # creation of manager, which keeps track of time and waking up of each process
    mgr <- managerInit(length(processVec), endOfSim)
    
    # creation of a thread for each item in processVec and manages each process
    
    # link processes to the manager
    
    # now that everything is set up, we will run the simulation
    run(mgr)
}

# managerInit - 

managerInit <- function(numProcesses, timeLimit) {
    me <- list()
    
    
    
    class(me) <- 'manager'
    return(me)
}

# run - runs the simulation

run <- function(mgr) {
    cat("running simulation")
#    while (mgr$curTime < mgr$maxTime) {
#        
#    }
}

