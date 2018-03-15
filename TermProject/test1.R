library(simmer)

PT_MEAN <- 10.0         # Avg. processing time in minutes
PT_SIGMA <- 2.0         # Sigma of processing time
MTTF <- 300.0           # Mean time to failure in minutes
BREAK_MEAN <- 1 / MTTF  # Param. for exponential distribution
REPAIR_TIME <- 30.0     # Time it takes to repair a machine in minutes
JOB_DURATION <- 30.0    # Duration of other jobs in minutes
NUM_MACHINES <- 10      # Number of machines in the machine shop
SIM_TIME <- 50000       # Simulation time in stuff

# setup
set.seed(42)
env <- simmer()

runMach <- function(machine)
    trajectory() %>%
        set_attribute("upTime", 0) %>%
        set_attribute("repairs",0) %>%
        timeout(function() rexp(1, BREAK_MEAN)) %>%
        seize("repairman",1) %>%
        timeout(REPAIR_TIME) %>%
        release("repairman",1) %>%
        set_attribute("repairs", 1, mod="+") %>%
        set_attribute("upTime", (function() now(env)-get_attribute(env, "upTime")-get_attribute(env,"repairs")*REPAIR_TIME), mod="+") %>%
        rollback(6, Inf) # go to 'timeout' over and over

machines <- paste0("machine", 1:NUM_MACHINES-1)

for (i in machines) env %>%
    add_generator(i, runMach(i), at(0), mon = 2)

env %>%
    add_resource("repairman", 1, Inf, preemptive = TRUE) %>% invisible

env %>%
    run(SIM_TIME) %>% invisible

get_mon_attributes(env) %>%
    dplyr::group_by(name) %>%
    dplyr::slice(n()) %>%
    dplyr::arrange(name)
