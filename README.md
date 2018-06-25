# Level Set based Shape Prior and Deep Learning for Image Segmentation
Open codes for paper "Level Set based Shape Prior and Deep Learning for Image Segmentation"

![Paper](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/Paper.png?raw=true)
## Abstract
Deep convolutional neural network (DCNN) can effectively extract the hidden patterns in images and learn realistic image priors from the training set. And fully convolutional networks (FCNs) have achieved state-of-the-art performance in the task of the image segmentation. However, these methods have the disadvantages of the noise, boundary roughness and no prior shape. Therefore, this paper proposes a level set with the deep prior method for the image segmentation based on the priors learned by FCNs from the training set. The output of the FCNs is treated as a probability map and the global affine transformation (GAT) is used to obtain the optimal affine transformation of the intrinsic prior shape at a specific image. And then, the level set method is used to integrate the information of the original image, the probability map and the corrected prior shape to achieve the image segmentation. Compared with the traditional level set method for images of simple scenes, the proposed method combines the traditional level set method with FCNs and corrected prior shape to solve the disadvantage of FCNs, making the level set method applicable to the image segmentation of complex scenes. Finally, a series of experiments with Portrait data set are used to verify the effectiveness of the proposed method. The experimental results show that the proposed method can obtain more accurate segmentation results than the traditional FCNs.


## The Level Set with The Deep Prior Method
In order to improve the performance of FCNs and complete objective segmentation of the complex sense by using the level set method, the level set with the deep prior method is proposed as shown in Fig. \ref{fig: Flow diagram}.

![The Flow Diagram](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/Flow%20Diagram.png?raw=true)

The output of FCNs is taken as a probability map that each pixel belongs to a different category. The segmentation shape represented by the probability map is noisy, but it still retains a large part of the correct segmentation. Therefore, an optimal affine transformation of the standard shape mask (the shape prior) of the image can be obtained based on the "probability" shape with the GAT method. Finally, the image, the probability map and the affine mask are used as the input of the level set method to implement the image segmentation.

After training on the training set, FCNs can extract features of the target and learn patterns of the target, and these capabilities are represented in the probability map. Therefore, the probability map preserves the information of the segmentation target based on the pixels in the receptive field. For example, in the Portrait data set, the probability map can represent the probability that each pixel belongs to a person. Although there is a certain probability which is incorrect, it still keeps most of the correct predictions, even the correct patterns information. Based on these properties of the probability map, it is possible to use the method of combining the probability map with the shape priors and the level set method for the semantic segmentation. And then how to get the optimal affine transformation of the standard shape prior using the GAT.

![GAT](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/GAT.png?raw=true)

## Results
![Results](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/6.png?raw=true)

## Experiments
![Experiments](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/Experiment.png?raw=true)
### Experiment 1
![Experiment 1](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/Experiment1.png?raw=true)

### Experiment 2
![Experiment 2 1](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/Experiment2_1.png?raw=true)

![Experiment 2 2](https://github.com/zsh965866221/LevelSet-ShapePrior-DeepLearning/blob/master/figs/Experiment2_2.png?raw=true)

## Reference

- [PortraitFCN](http://xiaoyongshen.me/webpage_portrait/index.html)
- [Global Affine Transformation](https://ieeexplore.ieee.org/abstract/document/735806/)
- [Level Set](http://www.engr.uconn.edu/~cmli/)
