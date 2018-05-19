import os
caffe_root = '../../caffe-portraitseg/'
import sys
sys.path.insert(0, caffe_root + 'python')

import numpy as np
from matplotlib import pyplot as plt
import caffe
caffe.set_mode_cpu()

MODEL_FILE = '../our_models/deploy_3channels.prototxt'
PRETRAINED = '../our_models/bgr.caffemodel'
net = caffe.Net(MODEL_FILE, PRETRAINED, caffe.TEST)

net.blobs['data'].reshape(1, 3, 800, 600)


import scipy.io as scio

testlistPath = '../../data/testlist.mat'
outputPath = './Output_PortraitFCN/'

testlist = scio.loadmat(testlistPath)['testlist'][0]

for i in range(len(testlist)):
	if os.path.exists('../../data/portraitFCN_data/%05d.mat' % testlist[i]) is True:
		image = scio.loadmat('../../data/portraitFCN_data/%05d.mat' % testlist[i])['img']
		image = image.transpose((2,0,1))
		net.blobs['data'].data[...] = image
		output = net.forward() 
		res = output['upscore']
		res = res.reshape(res.shape[1:])
		scio.savemat(outputPath + '%05d_output.mat'% testlist[i], {'res':res})
		print('%d OK' % testlist[i])
	



'''
image = scio.loadmat('../../data/portraitFCN_data/%05d.mat' % testlist[0][0])['img']
image = image.transpose((2,0,1))
net.blobs['data'].data[...] = image
output = net.forward() 
res = output['upscore']
res = res.reshape(res.shape[1:])
diffs = np.exp(res[1,:,:] - res[0,:,:])
finalres = diffs/(1+diffs)
plt.imshow(finalres)
plt.show()
scio.savemat(outputPath + '%05d_output.mat'% testlist[0][0], {'res':res})
'''
