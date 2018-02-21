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
        #finds min
        min <- min(c(min(a),min(b)))
        #if min is in both vectors remove only from a
        if(min %in% a && min %in% b) {
            a <- a[a != min]
        }
        #if min is in a
        else if(min %in% a) {
            a <- a[a != min]
        }
        #if min is in b
        else {
            b <- b[b != min]
        }

        merged <- c(merged, min)
    }
    makeAscendNums(merged)
}

'[<-.ascendNums' <- function(self, i, value) {
    stop("read-only")
}

a <- makeAscendNums(c(1,2,3,4,5))
b <- makeAscendNums(c(7,8,9))
print(a+b)