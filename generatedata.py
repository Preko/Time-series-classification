import os,sys
from synthdatasets import *

if __name__=="__main__":
  def CC(N):
    return [[controlcharts(o) for x in range(N)] for o in [NORMAL,CYCLIC,INCREASING,DECREASING,UPWARD,DOWNWARD]]
  def Wave(N):
    return [[wave(o) for x in range(N)] for o in [1,2,3]]
  def CBF(N):
    return [[cbf(o) for x in range(N)] for o in [CYLINDER,BELL,FUNNEL]]
  def KEOGHCBF(N):
    return [[keoghcbf(o) for x in range(N)] for o in [CYLINDER,BELL,FUNNEL]]
  def TOY(N):
    return [[toy(o) for x in range(N)] for o in [FIRST,LAST,ENDS]]
  if(not( os.path.exists("data"))):os.mkdir("data")
  for cnt in range(1,11):
    for gen in [CC,Wave,CBF,KEOGHCBF,TOY]:
      # Generate test data set
      data = gen(1000)
      path = 'synthdata'
      if(not( os.path.exists(path))):os.mkdir(path)
      filename = "/" + gen.__name__ + '_TEST' 
      f = open(path + filename, 'w')
      for classid,rows in enumerate(data):
        for row in rows:
          toprint = ''
          for value in row:
            toprint = toprint + ' ' + str(value)           
          f.write(str(classid+1) + ' ' + toprint + '\n')
      f.close()
      # Generate training data sets
      for N in [10,20,50,100,200,500,1000]:
        data = gen(N)
        path = 'synthdata/'+ gen.__name__ + str(cnt) + '_' + str(N)
        if(not( os.path.exists(path))):os.mkdir(path)
        filename = "/" + gen.__name__ + str(cnt) + '_' + str(N) + '_TRAIN' 
        f = open(path + filename, 'w')
        for classid,rows in enumerate(data):
          for row in rows:
            toprint = ''
            for value in row:
              toprint = toprint + ' ' + str(value)           
            f.write(str(classid+1) + ' ' + toprint + '\n')
        f.close()