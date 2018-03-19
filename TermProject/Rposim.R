# used to share memory between the different processes and the manager
library(bigmemory) # or library(Rdsm)

# newsim - creates and runs a new DES simulation
# 
# Input:
#   processVec - vector of application specific processes
#   endOfSim - time limit for the simulation
# 
# Creates a new manager object, links the processes to the manager, and runs the manager

newsim <- function(processVec, endOfSim) {
    # creation of manager, which keeps track of time and waking up of each process
    mgr <- managerInit(processVec, endOfSim)
    
    # creation of a thread for each item in processVec and manages each process
    # need to figure out how to use Rdsm to open new R instances that share their memory
    # 
    
        
    # now that everything is set up, we will run the simulation
    # returns a times object, which includes all necessary analysis
    run(mgr)
}

# managerInit - 

managerInit <- function(processVec, timeLimit) {
    me <- list()
    
    me$processVec <- processVec
    me$numProcesses <- length(processVec)
    me$curTime <- 0
    me$maxTime <- timeLimit
    
    class(me) <- 'manager'    
    return(me)
}

# run - runs the simulation

run <- function(mgr) {
    results <- list()
    
    while (mgr$curTime < mgr$maxTime) {
        mgr$processVec[[1]]() 
        mgr$processVec[[2]]()
        mgr$curTime <- mgr$curTime + 1
    }
    
    class(results) <- 'times'
    return(results)
}
