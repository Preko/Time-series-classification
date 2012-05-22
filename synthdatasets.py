import random
import math
import sys
import os



#########################
# Control Charts
# @article{pham1998ccp,
#  title={{Control chart pattern recognition using a new type of self-organizing neural network}},
#  author={Pham, D.T. and Chan, A.B.},
#  journal={Proceedings of the Institution of Mechanical Engineers, Part I: Journal of Systems and Control Engineering},
#  volume={212},
#  number={2},
#  pages={115--127},
#  year={1998},
#  publisher={Prof Eng Publishing}
#}
######################

NORMAL = 1
CYCLIC = 2
INCREASING = 3
DECREASING = 4
UPWARD = 5
DOWNWARD = 6

def controlcharts(o,n = 60):
  m = 30
  s = 2
  if(o == NORMAL): 
    return [m+random.uniform(-3,3)*s for t in range(1,n+1)]
  if(o ==  CYCLIC):
    a = random.uniform(10,15)
    T = random.uniform(10,15)
    return [m+random.uniform(-3,3)*s+a*math.sin(2*math.pi*t/T) for t in range(1,n+1)]
  if(o ==  INCREASING):
    g= random.uniform(0.2,0.5)
    return [m+random.uniform(-3,3)*s+g*t for t in range(1,n+1)]
  if( o == DECREASING) :
    g= random.uniform(0.2,0.5)
    return [m+random.uniform(-3,3)*s-g*t for t in range(1,n+1)]
  if( o == UPWARD) :
    x = random.uniform(7.5,20)
    assert(n/3 * 3 == n)
    t3 = random.uniform(n/3,2*n/3)
    def k(t): 
      if(t< t3): return 0
      return 1
    return [m+random.uniform(-3,3)*s+k(t)*x for t in range(1,n+1)]
  if( o == DOWNWARD) :
    x = random.uniform(7.5,20)
    assert(n/3 * 3 == n)
    t3 = random.uniform(n/3,2*n/3)
    def k(t): 
      if(t< t3): return 0
      return 1
    return [m+random.uniform(-3,3)*s-k(t)*x for t in range(1,n+1)]
  return None

#######################
# Waveform 
# L. Breiman, J.H. Friedman, A. Olshen, and 
# C.J. Stone. Classification and Regression Trees. 
#Chapman & Hall, New York, 1993. Previ- 
#ously published by Wadsworth & Brooks/Cole 
#in 1984. 
def __h1(i): return max(6-abs(i-7),0)
def __h2(i): return __h1(i-8)
def __h3(i): return __h1(i-4)

def wave(o):
  u = random.uniform(0,1)
  if(o == 1):
    return [u*__h1(i)+(1-u)*__h2(i)+random.normalvariate(0.0,1.0) for i in range(1,22)]
  if(o == 2):
    return [u*__h1(i)+(1-u)*__h3(i)+random.normalvariate(0.0,1.0) for i in range(1,22)]
  if(o == 3):
    return [u*__h2(i)+(1-u)*__h3(i)+random.normalvariate(0.0,1.0) for i in range(1,22)]
  return None

#######################
# Wave+Noise
#@article{gonzalez2000tsc,
#  title={{Time Series Classification by Boosting Interval Based Literals}},
#  author={Gonzalez, C.A. and Diez, J.J.R.},
#  journal={Inteligencia Artificial, Revista Iberoamericana de Inteligencia Artificial},
#  volume={11},
#  pages={2--11},
#  year={2000}
#}

def waveplusnoise(o):
  return wave(o)+[random.normalvariate(0.0,1.0) for i in range(19)]
  

######################
# CBF data set (Cylinder, Bell and Funnel)
# Naoki Saito. Local Feature Extraction and Its 
# Applications Using a Library of Bases. PhD 
# thesis, Department of Mathematics, Yale Uni- 
# versity, 1994. 
######################

CYLINDER=1
BELL=2
FUNNEL=3

def cbf(o):
  """
  This is the Cylinder-Bell-Funnel (CBF)
   N. Saito, Local feature extraction and its application
  using a library of bases. Ph.D. thesis, Department of Mathematics,
  Yale University, 1994."""
  a = random.randint(16,32)
  b = random.randint(32,96) + a
  n = random.normalvariate(0.0,1.0)
  def xab(t):
    if ( (t>=a) and (t <=b) ):
      return 1.0
    return 0.0
  if(o == CYLINDER):
    return [ (6+n)*xab(t) + random.normalvariate(0.0,1.0) for t in range(1,129)]
  elif(o == BELL) :
    return [ (6+n)*xab(t) *(t - a) / (b - a)  + random.normalvariate(0.0,1.0) for t in range(1,129)]    
  elif (o == FUNNEL):
    return [ (6+n)*xab(t) *(b - t) / (b - a)  + random.normalvariate(0.0,1.0) for t in range(1,129)]    
  else :
    return None
    



######################
# Variation of the CBF data set (Cylinder, Bell and Funnel)
# Naoki Saito. Local Feature Extraction and Its 
# Applications Using a Library of Bases. PhD 
# thesis, Department of Mathematics, Yale Uni- 
# versity, 1994. 
#
# This version was modified to match what Eamonn Keogh has
# been using
######################

CYLINDER=1
BELL=2
FUNNEL=3

def keoghcbf(o):
  """
  This is the Cylinder-Bell-Funnel (CBF)
   N. Saito, Local feature extraction and its application
  using a library of bases. Ph.D. thesis, Department of Mathematics,
  Yale University, 1994."""
  a = random.randint(16,32)
  b = 32 + random.randint(32,96)
  n = random.normalvariate(0.0,1.0)
  def xab(t):
    if ( (t>=a) and (t <=b) ):
      return 1.0
    return 0.0
  if(o == CYLINDER):
    return [ (6+n)*xab(t) + random.normalvariate(0.0,1.0) for t in range(1,129)]
  elif(o == BELL) :
    return [ (6+n)*xab(t) *(t - a) / (b - a)  + random.normalvariate(0.0,1.0) for t in range(1,129)]    
  elif (o == FUNNEL):
    return [ (6+n)*xab(t) *(b - t) / (b - a)  + random.normalvariate(0.0,1.0) for t in range(1,129)]    
  else :
    return None





######################
# Toy dataset 
######################

FIRST=1
LAST=2
ENDS=3

def toy(o):
  if(o == FIRST):
    return [ random.normalvariate(0.0,0.1), random.normalvariate(0.0,0.1), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0) ]
  if(o == LAST):
    return [ random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,0.1), random.normalvariate(0.0,0.1) ]
  if(o == ENDS):
    return [ random.normalvariate(0.0,0.1), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,1.0), random.normalvariate(0.0,0.1) ]

def writedata(fileout,label,data):
    fileout.write(label)
    fileout.write(",")
    for i in range(len(data)-1):
        fileout.write(str(data[i])+",")
    fileout.write(str(data[len(data)-1])+os.linesep)

if __name__=="__main__":
    N=128
    print "creating the controlcharts.txt file"
    fileout = open("controlcharts.txt","w")
    for param in range(1,7):
        for i in range(N):
            writedata(fileout,str(param),controlcharts(param))
    fileout.close()
        