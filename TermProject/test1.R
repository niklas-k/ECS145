library(simmer)

MTTF <- 300.0           # Mean time to failure in minutes
BREAK_MEAN <- 1 / MTTF  # Param. for exponential distribution
REPAIR_TIME <- 30.0     # Time it takes to repair a machine in minutes
NUM_MACHINES <- 10      # Number of machines in the machine shop
SIM_TIME = 5000         # Given time to simulate

# setup
env <- simmer()

getTime <- function() rexp(1,BREAK_MEAN)

run_machine <- function(machine)
    trajectory() %>%
        set_attribute("upTime", 0) %>%
        set_attribute("nextStop", getTime()) %>%
        timeout(function() get_attribute(env,"nextStop")) %>%
        set_attribute("upTime", (function () get_attribute(env,"nextStop")), mod="+") %>% 
        seize("repairman",1) %>%
        timeout(REPAIR_TIME) %>%
        release("repairman",1) %>%
        set_attribute("nextStop", getTime()) %>%
        rollback(6, Inf) # go to 'timeout' over and over 

machines <- paste0("machine", 1:NUM_MACHINES-1)

for (i in machines) env %>%
    add_resource(i, 1, 0, preemptive = TRUE) %>%
    add_generator(paste0(i, ""), run_machine(i), at(0), mon = 2)

env %>%
    add_resource("repairman", 1, Inf, preemptive = TRUE) %>%
    invisible

env %>%
    run(SIM_TIME) %>% invisible

get_mon_attributes(env)
