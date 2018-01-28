import ProblemA
import random
import numpy

# tests if two lists have the exact same values and order
# there has to be a nicer way to do this probably ...
def listsEquivalent(l1, l2):
	if len(l1) != len(l2): return False
	for i in range(len(l1)):
		if l1[i] != l2[i]: return False
	return True

for testNo in range(5000): # perform 5000 random tests on ProblemA
	for i in xrange(1, 8): # size of the first polynomial
		coef1 = random.sample(xrange(-20, 20), i) # random list of size i		
		p1 = ProblemA.polynom(coef1)
		if (len(coef1) == 0): coef1 = [0]
		
		for j in xrange(1, 8): # size of the second polynomial
			coef2 = random.sample(xrange(-20, 20), j)
			p2 = ProblemA.polynom(coef2) # random list of size j
			if (len(coef2) == 0): coef2 = [0]
			
			# let's test our addition vs numpy polynomial module
			p = p1 + p2
			npP = numpy.polynomial.polynomial.polyadd(coef1[::-1], coef2[::-1]) # "pythonic" way of reversing our list, since numpy uses acending order for coefficients
			
			if not listsEquivalent(p.poly, npP[::-1]):
				if not (p.poly == [] and npP[::-1] == [0]):
					print "addition error!\n", p1.poly, " + ", p2.poly, " != ", p.poly, "\n"
			
			# let's test our subtraction vs numpy polynomial module
			p = p1 - p2
			npP = numpy.polynomial.polynomial.polysub(coef1[::-1], coef2[::-1])
			
			if not listsEquivalent(p.poly, npP[::-1]):
				if not (p.poly == [] and npP[::-1] == [0]):
					print "subtratction error!\n", p1.poly, " - ", p2.poly, " != ", p.poly, "\n"
			
			# let's test our multiplication vs numpy polynomial module
			p = p1 * p2
			npP = numpy.polynomial.polynomial.polymul(coef1[::-1], coef2[::-1])
			
			if not listsEquivalent(p.poly, npP[::-1]):
				if not (p.poly == [] and npP[::-1] == [0]):
					print "multiplication error!\n", p1.poly, " * ", p2.poly, " != ", p.poly, "\n"
			
			# let's test our derivative calculator vs numpy polynomial module
			dp2 = p2.drv() # we can just assume it works for p1
			npdP = numpy.polynomial.polynomial.polyder(coef2[::-1])
			
			if not listsEquivalent(dp2.poly, npdP[::-1]):
				if not (dp2.poly == [] and npdP[::-1] == [0]):
					print "derivation error!\n", "d of ", p2.poly, " != ", dp2.poly, "but = ", npdP[::-1], "\n"
			
			# let's test our integral calculator vs numpy polynomial module
#			a = random.randint(-100,100)
#			b = random.randint(-100,100)
#			ip2 = p2.intg(a,b)
#			npiP = numpy.polynomial.polynomial.polyint(coef2[::-1])
#			
#			if ip2 != (npiP(b) - npiP(a)):
#				print "integration error!\n", "int of ", p2.poly, " != ", ip2, "but = ", npiP(b) - npiP(a), "\n"
			
			