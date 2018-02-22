# AscendNums constructor
makeAscendNums <- function(x) {
    #check if list is nondecreasing
    if(is.unsorted(x)) {
        stop("not nondecreasing")
    }

    me <- x

    #checks if list is strictly ascending
    if(anyDuplicated(x) != 0) {
        attributes(me)$strictAscend <- F
    } else {
        attributes(me)$strictAscend <- T
    }

    class(me) <- 'ascendNums'
    return(me)
}

'+.ascendNums' <- function(a,b) {
    merged <- integer()
    len <- length(a) + length(b)

    for(i in 1:len) {
        if(length(a) == 0) {
            return(makeAscendNums(c(merged,b)))
        }
        else if(length(b) == 0) {
            return(makeAscendNums(c(merged,a)))
        }
        #finds min
        min <- min(c(a[1],b[1]))

        #if min is in both vectors remove only from a and b and add duplicate
        if(min %in% a && min %in% b) {
            a <- a[-1]
            b <- b[-1]
            merged <- c(merged,min)
        }
        #if min is in a
        else if(min %in% a) {
            a <- a[-1]
        }
        #if min is in b
        else {
            b <- b[-1]
        }

        merged <- c(merged, min)
    }
    makeAscendNums(merged)
}

'[<-.ascendNums' <- function(self, i, value) {
    stop("read-only")
}