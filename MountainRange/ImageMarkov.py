

import cv2
import numpy as np



def choosethird(f,two,im,tol=200,stepmax=50,scaling=1):
	Xlen = len(im[0])
	Ylen = len(im)

	#choose starting position on original image
	i = int((Ylen-2*f)*random())
	j = int((Xlen-2*f)*random())
	best = im[i:i+f,j+f:j+2*f]
	bestvec = vector(im[i:i+f,j:j+f].flatten().tolist()+im[i+f:i+2*f,j:j+f].flatten().tolist())
	twovec = vector(two[0].flatten().tolist()+two[1].flatten().tolist())
	bestnorm = norm(bestvec-twovec)

	#count steps so if we don't converge we still output the stuff
	step = 0
	while bestnorm > tol and step < stepmax:
		#jump to new position
		i = int((Ylen-2*f)*random())
		j = int((Xlen-2*f)*random())		

		#get vector at that position
		newvec = vector(im[i:i+f,j:j+f].flatten().tolist()+im[i+f:i+2*f,j:j+f].flatten().tolist())

		#compute norm
		newnorm = norm(twovec-newvec)

		#compare
		if newnorm<bestnorm:
			bestnorm = newnorm
			best = im[i:i+f,j+f:j+2*f]

		step = step + 1

	if step==stepmax:
		print("max steps reached")
	return best
			

def choosefourth(f,three,im,tol=200,stepmax=50,scaling=1):
	Xlen = len(im[0])
	Ylen = len(im)

	#choose starting position on original image
	i = int((Ylen-2*f)*random())
	j = int((Xlen-2*f)*random())
	best = im[i+f:i+2*f,j+f:j+2*f]
	bestvec = vector(im[i:i+f,j:j+f].flatten().tolist()+im[i+f:i+2*f,j:j+f].flatten().tolist()+im[i:i+f,j+f:j+2*f].flatten().tolist())
	threevec = vector(three[0].flatten().tolist()+three[1].flatten().tolist()+three[2].flatten().tolist())
	bestnorm = norm(bestvec-threevec)

	#count steps so if we don't converge we still output the stuff
	step = 0
	while bestnorm > tol and step < stepmax:
		#jump to new position
		i = int((Ylen-2*f)*random())
		j = int((Xlen-2*f)*random())

		#get vector at that position
		newvec = vector(im[i:i+f,j:j+f].flatten().tolist()+im[i+f:i+2*f,j:j+f].flatten().tolist()+im[i:i+f,j+f:j+2*f].flatten().tolist())

		#compute norm
		newnorm = norm(threevec-newvec)

		#compare
		if newnorm<bestnorm:
			bestnorm = newnorm
			best = im[i+f:i+2*f,j+f:j+2*f]

		step = step+1

	if step==stepmax:
		print("max steps reached")
	return best

def imarkov(imagedir,f=4,size=10):
	#get image
	im = cv2.imread(imagedir)
	
	#create new image
	Xlen = len(im[0])
	Ylen = len(im)
	imo = np.zeros((Ylen,f*size,3), np.uint8)
	seedwidth = f*2
	r = 0.2
	xseed = int((Xlen-seedwidth)*r)
	#starts with a random strip of the original image
	imo[:,0:seedwidth] = im[:,xseed:xseed+seedwidth]

	
	#do that thang baby
	for col in range(size-seedwidth):
		x = seedwidth+col*f
		two = (imo[0:f,x-f:x],imo[f:2*f,x-f:x])
		imo[0:f,x:x+f] = choosethird(f,two,im)
		print("column")
		print(col)
		for y in range(Ylen-2*f):
			print(y)
			three = (imo[y:y+f,x-f:x],imo[y+f:y+2*f,x-f:x],imo[y:y+f,x:x+f])
			imo[y+f:y+2*f,x:x+f] = choosefourth(f,three,im)

	return(imo)

