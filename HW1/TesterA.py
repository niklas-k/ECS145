import ProblemA
import random
import numpy

# tests if two lists have the exact same values and order
# there has to be a nicer way to do this probably ...
def listsEquivalent(l1, l2):
	if len(l1) != len(l2):
		return False
	
	for i in range(len(l1)):
		if l1[i] != l2[i]:
			return False
	
	return True

for testNo in range(5): # perform 5000 random tests on ProblemA
	
	for i in xrange(1, 8): # size of the first polynomial
		coef1 = random.sample(xrange(-20, 20), i) # random list of size i		
		p1 = ProblemA.polynom(coef1)
		
		for j in xrange(1, 8): # size of the second polynomial
			coef2 = random.sample(xrange(-20, 20), j)
			p2 = ProblemA.polynom(coef2) # random list of size j
			
			# let's test our addition vs numpy polynomial module
			p = p1 + p2
			npP = numpy.polynomial.polynomial.polyadd(coef1[::-1], coef2[::-1]) # "pythonic" way of reversing our list, since numpy uses acending order for coefficients
			
			if not listsEquivalent(p.poly, npP[::-1]):
				print "addition error!\n", p1.poly, " + ", p2.poly, " != ", p.poly, "\n"
			
			# let's test our subtraction vs numpy polynomial module
			p = p1 - p2
			npP = numpy.polynomial.polynomial.polysub(coef1[::-1], coef2[::-1])
			
			if not listsEquivalent(p.poly, npP[::-1]):
				print "subtratction error!\n", p1.poly, " - ", p2.poly, " != ", p.poly, "\n"
			
			# let's test our multiplication vs numpy polynomial module
			p = p1 * p2
			npP = numpy.polynomial.polynomial.polymul(coef1[::-1], coef2[::-1])
			
			if not listsEquivalent(p.poly, npP[::-1]):
				print "multiplication error!\n", p1.poly, " * ", p2.poly, " != ", p.poly, "\n"
			
			# let's test our derivative calculator vs numpy polynomial module
			dp2 = p2.drv() # we can just assume it works for p1
			npdP = numpy.polynomial.polynomial.polyder(coef2[::-1])
			
			if not listsEquivalent(dp2.poly, npdP[::-1]):
				print "derivation error!\n", "d of ", p2.poly, " != ", dp2.poly, "\n"
			
			# let's test our integral calculator vs numpy polynomial module
			# IMPLEMENT ME
			
			