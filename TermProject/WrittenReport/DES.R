newsim <- function(timelim,maxesize,appcols=NULL,aevntset=FALSE,dbg=FALSE) {
   simlist <- new.env()
   simlist$currtime <- 0.0  # current simulated time
   simlist$timelim <- timelim
   simlist$timelim2 <- 2 * timelim
   simlist$passedtime <- function(z) z > simlist$timelim
   simlist$evnts <- matrix(nrow=maxesize,ncol=2+length(appcols))
   colnames(simlist$evnts) <- c('evnttime','evnttype',appcols)
   simlist$evnts[,1] <- simlist$timelim2
   simlist$aevntset <- aevntset
   if (aevntset) {
      simlist$aevnts <- NULL
      simlist$nextaevnt <- 1
   }
   simlist$dbg <- dbg
   simlist
}

# eventAdd
schedevnt <- function(simlist,evnttime,evnttype,appdata=NULL) {
   evnt <- c(evnttime,evnttype,appdata)
   fr <- getfreerow(simlist)
   simlist$evnts[fr,] <- evnt
}
# endEventAdd

getfreerow <- function(simlist) {
   evtimes <- simlist$evnts[,1]
   tmp <- Position(simlist$passedtime,evtimes)
   if (is.na(tmp)) stop('no room for new event')
   tmp
}

getnextevnt <- function(simlist) {
   etimes <- simlist$evnts[,1]
   whichnexte <- which.min(etimes)
   nextetime <- etimes[whichnexte]
   if (simlist$aevntset) {
      nextatime <- simlist$aevnts[simlist$nextaevnt,1]
      if (nextatime < nextetime) {
         oldrow <- simlist$nextaevnt 
         simlist$nextaevnt <- oldrow + 1
         return(simlist$aevnts[oldrow,])
      }
   }
   head <- simlist$evnts[whichnexte,]
   simlist$evnts[whichnexte,1] <- simlist$timelim2
   return(head)
}

mainloop <- function(simlist) {
   simtimelim <- simlist$timelim
   while(TRUE) {
      # skipTime
      head <- getnextevnt(simlist)  
      etime <- head['evnttime']
      if (etime > simlist$timelim) return()
      simlist$currtime <- etime
      # endSkipTime
      # eventHandleReact
      simlist$reactevent(head,simlist)
      # endEventHandleReact
      if (simlist$dbg) {
         print("event occurred:")
         print(head)
         print("events list now")
         print(simlist$evnts)
         browser()
      }
   }
}

cancelevnt <- function(rownum,simlist) {
   simlist$evnts[rownum,1] <- simlist$timelim2
}

newqueue <- function(simlist) {
   if (is.null(simlist$evnts)) stop('no event set')
   q <- new.env()
   q$m <- matrix(nrow=0,ncol=ncol(simlist$evnts))
   q
}

appendfcfs <- function(queue,jobtoqueue) {
   if (is.null(queue$m)) {
      queue$m <- matrix(jobtoqueue,nrow=1)
      return()
   }
   queue$m <- rbind(queue$m,jobtoqueue)
}

delfcfs <- function(queue) {
   if (is.null(queue$m)) return(NULL) 
   qhead <- queue$m[1,]
   queue$m <- queue$m[-1,,drop=F]
   qhead
}

exparrivals <- function(simlist,meaninterarr,batchsize=10000) {
   if (!simlist$aevntset) 
      stop("newsim() wasn't called with aevntset TRUE")
   es <- simlist$evnts
   cn <- colnames(es)
   if (cn[3] != 'arrvtime') stop('col 3 must be "arrvtime"')
   if (cn[4] != 'jobnum') stop('col 3 must be "jobnum"')
   erate <- 1 / meaninterarr
   s <- 0
   allarvs <- NULL
   while(s < simlist$timelim) {
      arvs <- rexp(batchsize,erate)
      s <- s + sum(arvs)
      allarvs <- c(allarvs,arvs)
   }
   cuallarvs <- cumsum(allarvs)
   allarvs <- allarvs[cuallarvs <= simlist$timelim]
   nallarvs <- length(allarvs)
   if (nallarvs == 0) stop('no arrivals before timelim')
   cuallarvs <- cuallarvs[1:nallarvs]
   maxesize <- nallarvs + nrow(es)
   newes <- matrix(nrow=maxesize,ncol=ncol(es))
   nonempty <- 1:nallarvs
   newes[nonempty,1] <- cuallarvs
   if (is.null(simlist$arrvevnt)) stop('simlist$arrvevnt undefined')
   newes[nonempty,2] <- simlist$arrvevnt
   newes[nonempty,3] <- newes[nonempty,1]
   newes[nonempty,4] <- 1:nallarvs
   newes[-nonempty,1] <- simlist$timelim2
   colnames(newes) <- cn
   simlist$aevnts <- newes
}