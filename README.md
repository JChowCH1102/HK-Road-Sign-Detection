# HK Road Sign Detection
<b>Hong Kong Road Sign Detection for iOS / iPadOS / MacOS Application</b>

This application is an iOS / iPadOS / MacOS application that detects the road sign of Hong Kong from an image (only 12 Type of Available Detected Road Sign now)

![plot](./readMeImage/image1.jpg)

Mac, iPad, iPhone screen capture (from left to right) 

This application used Object Detector task of Create ML. The model is exported to Core ML mlmodel file. The model is deployed to an iOS application.

<b>Functions: </b>

1.	Image select from library or take picture for machine learning task. 
2.	Detect the road signs using Core ML. 
3.	Draw a bouncing box on the raw video and present the result on the screen. 
4.	Detect 12 different road sign in the image to Notify the driver by highlighting important alert (i.e., Give Way, Speed limit).
5.	Use Mac Catalyst to show iPad app on Mac

<b>12 Type of Available Detected Road Sign</b>
 
| Road Sign Name | Road Sign Image |
| ------------- | ------------- |
| No entry	  | ![plot](./readMeImage/image2.jpg)  |
| Keep left	   | ![plot](./readMeImage/image3.jpg)  |
| Give Way	  | ![plot](./readMeImage/image4.jpg)  |
| Pedestrians on road ahead	 	   | ![plot](./readMeImage/image5.jpg)  |
| No learner drivers	  | ![plot](./readMeImage/image6.jpg)  |
| Motorway begins	   | ![plot](./readMeImage/image7.jpg)  |
| No U-turn	  | ![plot](./readMeImage/image8.jpg)  |
| No mini-buses	   | ![plot](./readMeImage/image9.jpg)  |
| 100 - Maximum speed	  | ![plot](./readMeImage/image10.jpg)  |
| Speed Camera	   | ![plot](./readMeImage/image11.jpg)  |
| No Stopping		  | ![plot](./readMeImage/image12.jpg)  |
| One Way Traffic	   | ![plot](./readMeImage/image13.jpg)  |
