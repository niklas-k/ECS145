'''This is Problem A from Homework 1 of ECS 145. It adds, subtracts, multiplies,
    derives, or integrates polynom objects, which represent polynomials with a list of numbers'''

class polynom:
    '''polynom class with required functions'''
    def __init__(self, polyList = None):
        while(len(polyList) > 0 and polyList[0] == 0):
            polyList.pop(polyList[0])
        self.poly = polyList
    
    def drv(self):
        derived = []
        mult = self.poly[:-1] #constant will go away in derivation
        for i in range(1, len(mult)+1):
            derived.append(i * mult[-i]) #flipping list at start to line up with i
        derived = derived[::-1] # flip list back
        index = 0
        while len(derived) > 0 and derived[index] == 0: #remove leading 0's
            derived.pop(derived[index])
        ret = polynom(derived)
        return ret
    
    def intg(self, a, b):
        Fx = [] #array for integrand (I think that's the term I have no internet rn)
        for i in range(1, len(self.poly)+1):
            Fx.append(float(self.poly[-i])/i)
        Fx = Fx[::-1] #flip it as in drv()
        Fb = Fa = 0
        for i in range(1, len(self.poly)+1):
            Fb = Fb + Fx[-i]*(b**i)
            Fa = Fa + Fx[-i]*(a**i)
        #ret = polynom(Fb-Fa) #substract F(b)-F(a) for final answer
        return (Fb-Fa) #ret
    
    def __add__(self, rhs):
        maxLen = max(len(self.poly), len(rhs.poly)) #lengths of lists for different procedures
        minLen = min(len(self.poly), len(rhs.poly))
        if len(self.poly) > len(rhs.poly):
            longerList = self
        else:
            longerList = rhs
        added = []
        for i in range(1, minLen+1): #while both lists have a number
            added.append(self.poly[-i] + rhs.poly[-i])
        for i in range(minLen + 1, maxLen+1): #while only one has a number
            added.append(longerList.poly[-i])
        added = added[::-1] #flip back
        while len(added) > 0 and added[0] == 0: #remove leading 0's
            added.pop(added[0])
        ret = polynom(added)
        return ret
    
    def __sub__(self, rhs):
        maxLen = max(len(self.poly), len(rhs.poly)) #lengths again as with the add overload
        minLen = min(len(self.poly), len(rhs.poly))
        if len(self.poly) > len(rhs.poly):
            longerList = self
        else:
            longerList = rhs
        subtracted = []
        for i in range(1, minLen + 1):
            subtracted.append(self.poly[-i] - rhs.poly[-i])
        for i in range(minLen + 1, maxLen + 1):
            if longerList == self: #add leading numbers if left side has higher degree
                subtracted.append(longerList.poly[-i])
            else: #subtract leading numbers if right side has higher degree
                subtracted.append(-longerList.poly[-i])
        subtracted = subtracted[::-1]
        while len(subtracted) > 0 and subtracted[0] == 0:
            subtracted.pop(subtracted[0])
        ret = polynom(subtracted)
        return ret
    
    def __mul__(self, rhs):
        selfRev = self.poly[::-1] #flip both lists
        rhsRev = rhs.poly[::-1]
        mult = [0] * (len(selfRev) + len(rhsRev))
        for i in range(len(selfRev)):
            for j in range(len(rhsRev)):
                mult[i + j] = mult[i + j] + (selfRev[i] * rhsRev[j]) #add degrees of expressions
        mult = mult[::-1] #flip back
        while len(mult) > 0 and mult[0] == 0:
            mult.pop(mult[0])
        ret = polynom(mult)
        return ret