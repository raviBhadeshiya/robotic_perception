# Robotic Perception

This repository is a showcase of the projects done in the course *ENPM673* at University of Maryland. This course is specifically designed to give insights to *Robotic perception* and includes topics from the very basics like various image transformations to state-of-the-art algorithms like monocular visual odometry. In this section, brief descriptions are provided about every project done under this course. The projects done in this course are listed below, please click on the link to reach a particular section:
  
  * [Augmented Reality](https://github.com/raviBhadeshiya/robotic_perception#augmented-reality)
  * [Buoy Detection](https://github.com/raviBhadeshiya/robotic_perception#buoy-detection)
  * [Lane Detection](https://github.com/raviBhadeshiya/robotic_perception#lane-detection)
  * [Traffic Sign Recognition](https://github.com/raviBhadeshiya/robotic_perception#traffic-sign-recognition)
  * [Car Detection](https://github.com/raviBhadeshiya/robotic_perception#car-tracking)
  * [Visual Odometry](https://github.com/raviBhadeshiya/robotic_perception#visual-odometry)

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

### Lane detection 

In this rpoject, the task was to detect lanes which is one of the basic task needed in any autonomous cars. One of the objective of this course was to make students capable of working on self-driving cars. This project was the first step towards that goal. Some pre-processing of the image and *Hough* transforms the task was completed. Usage of Hough transforms is prefered over any other methods since it requires lesser computational power. Taking the further and building up on this, the next step is to predict the curvature of the road. For this, the line fitted on the lanes are extrapolated and use the center of the frame to predict the curvature. Following figure shows the output of the algortihm. 

<p align="center">
<img src="https://github.com/raviBhadeshiya/robotic_perception/blob/master/_output/lane_detection.gif">
</p>

### Traffic sign recognition

Another important task in any autonomous car is to detect and recognize traffic signs on the road. There are two steps in this project:
  1. To detect the traffic signs from the incoming video stream
  2. Recognize the detected traffic signs.

For detection of traffic signs, simple color segmentation technique is used in HSV color space. To filter out false positives another restriction was implemented on the aspect ratio of the bounding box. Implementing this step improved the result tremendously. To recognize the detected traffic signs, a multi-class Support Vector Machines classifier is used. SVM has proved to be very fruitful over other classifying techniques. 

<p align="center">
<img src="https://github.com/raviBhadeshiya/robotic_perception/blob/master/_output/trafic_sign_detection.gif">
</p>

### Car Tracking

Moving one more step ahead towards achieving the goal of completing covering up algorithms used in autonomous cars, the task in this project is to detect the car in traffic and keep a track of them in the video stream. To detect the car in the frame, *Cascade* classifiers are used. It offeres reliable results after tuning of certain paramters of the detector with very less amount of computations. Once a car is found in the frame, *Speeded Up Robust Features* are identifed in the detected car. These features are then used to track the car across the frames using *Kanade-Lucas-Tomasi* point tracking algorithm. A sample extract of the output video is shown below. 

<p align="center">
<img src="https://github.com/raviBhadeshiya/robotic_perception/blob/master/_output/car_tracking.gif">
</p>

### Visual Odometry

This is the final project in the course and very crucial task for driverless cars. It is one of the cutting edges algorithms used currently in many robotics projects. Visual odometry obtains the information of the location of the vehicle from the video stream obtained from the RGBD camera. Taking it one step ahead, in this project visual odometry is computed from *monocular* camera without any depth information obtained directly from the camera. The position of the camera is tracked across the frames by computing *Essential matrices*, obtaining *rotation* and *translation* matrices from it, and selecting correct Essential matrix by doing *triangulation*. The *trajectory* of the vehicle calculated for the given video is shown below.

<p align="center">
<img src="https://github.com/raviBhadeshiya/robotic_perception/blob/master/Visual_odometry/output/trajectory1.jpg">
</p>
