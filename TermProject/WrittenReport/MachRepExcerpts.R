# Line 12: Simmer Environment
    env <- simmer()

# Lines 34-35: Runtime for Environment
    env %>%
        run(SIM_TIME) %>% invisible

# Lines 28-29: Machine Generator Loop
    for (i in machines) env %>%
        add_generator(i, runMach(i), at(0), mon = 2)

# Line 24: Rollback
    rollback(6, Inf)

# Lines 37-40: Printing Attributes
    get_mon_attributes(env) %>%
        dplyr::group_by(name) %>%
        dplyr::slice(n()) %>%
        dplyr::arrange(name)

# Line 19: Seize Repairman Resource
    seize("repairman",1) %>%

# Line 21: Release Repairman Resource
    release("repairman",1) %>%