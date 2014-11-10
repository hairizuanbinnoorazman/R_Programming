
## Function stores the cache
## Upon storing of new matrices, the Inverse is cleared
## It is recommended not to use the setInverse method as this would spoil program flow
makeCacheMatrix <- function(x = matrix()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setInverse <- function(inverse) m <<- inverse
  getInverse <- function() m
  list(set = set, get = get,
       setInverse = setInverse,
       getInverse = getInverse)
}


## Calculates out the inverse of the matrix
## However, this function is dependent on the makeCacheMatrix
## The parameter is one that requires a list of functions

cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  m <- x$getInverse()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- solve(data, ...)
  x$setInverse(m)
  m
}

## Uncomment to use
## To mass uncomment, use Ctrl + Shift + c
## sample usage:

# sampleMatrix<-matrix(c(1,2,3,4),2,2)
# sampleMatrix2<-matrix(c(2,3,4,5),2,2)
# cacheMatrix<-makeCacheMatrix(sampleMatrix2)
# cacheMatrix$get()
# cacheMatrix$set(sampleMatrix)
# cacheMatrix$get()
# cacheMatrix$getInverse()
# cacheSolve(cacheMatrix)
# cacheMatrix$getInverse()
