# ENPM673: Project 2

This project is part of the coursework in the course **Perception for autonomous robots** at University of Maryland, College Park. 

## Part 1: Lane detection using MATLAB
The approach used in this project is very straightforward using _Hough lines_. The most important part is pre-processing of the frame such that Hough lines can find the lanes easily and accurately. To remove the noise, _Gaussian_ filter is used which has proven effective. The next step is to find the edges which is the key to finding lanes in frame. The last step is to remove noise if any after finding edges for this morphological _opening_ operation is used.  



###### Please stay tuned for more stuff!
