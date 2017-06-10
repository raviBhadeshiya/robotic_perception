# Robotic Perception

This repository is the showcase of the projects done in the course *ENPM673* at University of Maryland. This course is specifically designed to give insights to *Robotic perception* and includes topics from the very basics like various image transformations to stat-of-the-art algorithms like monocular visual odometry. Below are the brief descriptions of the various projects done. You can visit the particular folder to get more detailed description about the project.

### Augmented Reality

This is one of the projects which uses the very basic concepts like image transformations and homography to generate very powerful results like augmented reality. In this project, the task was to generate a cube on an Apriltag in the frame. This task can be broken down into different parts to simplify it and then integrate them to generate the expected results. A sample output can be seen below. The project was broken down into following parts:
  
  * Detect an Apriltag in the frame.
  * Unwarp it and identify the correct order of corner points.
  * Read the encoded data.
  * Compute the points of the rectangle.
  * Warp those points to the tag in the frame based using the inverse homography.
  
<p align="center">
<img src="https://github.com/raviBhadeshiya/robotic_perception/blob/master/_output/augmented_cube.gif">
</p>
  
### Buoy Detection
  
This is another one of the projects which uses basic concepts of color segmentation combining it with *Gaussian Mixture models* to detect the underwater buoys. After much contemplating and experimenting with different colorspaces, in this project RGB colorspace is used for buoy detection. The training data was generated manually which was then provided to *GMM* which identifies the optimum combination of the color channels in the frame. A sample output is as shown below:


<p align="center">
<img src="https://github.com/raviBhadeshiya/robotic_perception/blob/master/_output/bouy_detection.gif">
</p>
