# matlab_image_labeler_to_YOLO
Use of an object detector for automatic image labeling. 

This process is done by folders and it's recommended to use on less than 500 images per run.
## Requirements

### Matlab 2019 or later
 - [Matlab 2020](https://es.mathworks.com/products/new_products/latest_features.html)

### Matlab Toolbox 
 - [Computer Vision](https://www.mathworks.com/products/computer-vision.html)

## Setup
```
  git clone [repositori_link]
```
- Place images to train detector in folder ```/train_data```
- Place validation images in folder ```/val_data```

## 1. Manual labeling 
- Open ```Image Labeler``` app on Matlab
- Add images from folder ```/train_data```
- Create label: It is possible to create more than one label at a time. 
- Label images 
  - It is important to label all the images in your training set *where your object is available*  
- [Optional] Save image labeling session as: ```[label_name]_labeler_session```
  - This session is user-specific. It won't work on different computers
 
- Save label definitions as: ```[label_name]_label_def```
- Export image Labels as: ```[label_name]_labels```

## 2. Training obj detector
The Object detector used in this repository is the ACF detector from matlab
- Open file ```DetectorTrainer.mxl```
- Edit the file and specify:
  - ```label_name``` 
  - Labels made in previous step
  - Name of detector:   ```[label_name]_detector```
- The script automatically generates and saves the detector
- [Optional] Test the detector
   - Specify folder where img to test is located
   - Specify name  of img

## 3. Use obj detectors to create labels

If you want to label multiple objects, it is recommended to run the script two detectors at a time

Be aware that the order in which you load the labels is the order the class identifiers will have when converting to a YOLO format
- Open file ```DetectorLabelCreator.mlx```
- If existent, specify the set of labeled images to label once again
- Specify the name of output labeled images 
  - default: ```detector_labels```
- Specify:
  - Loops (Amount of detectors to run)
    - default: ```2```
  - Name of detectors
  - Label names
  - Label definitions

By default, the program labels the images inside the ```/val_data ``` folder

Note: You can only create new labels in a set of already-labeled images if the set of images being labeled by the detector is the same

## 4. Manual correction of images

If all the previous parts have been executed correctly, you will be able to manually open and correct possible errors made by the detectors

- Open ```Image Labeler ``` app on matlab
- Choose ```Import Labels ```  from file
  - Open ```detector_labels.mat```
- Correct the labels that you consider wrong
- Choose ```Export Labels ```
- Save the revised labels

## 5. Format converter and .txt creator

This last step converts the matlab coordinates to the normalized YOLO coordinates and creates a .txt with the coordinates of the labels for each image.

  - Open file ```YoloLabelMaker.mlx```
  - Specify name of labels to load
    - default: ```detector_labels.mat```
  - Specify folder where these labeled images are located
    - default: ```\val_data```

As in step 3, this only works if the folder has exactly the same images that were labeled before

If executed correctly, you should find a .txt for each labeled image in your folder


## [Optional] Automatic labeling using  'Image Labeler'
- Copy ```GangsterACFDetector.m```
- Rename this copy with your new detector
- Open the copy
 - Ctrl + H, replace 'gangster' with the name of your new label
 - Change the description
- Open ```Image Labeler``` app
- Import images from ```/val_data```
- Import labels
- Import label definition 
- Import detector method ```/+vision/+labeler/[label_name]ACFDetector.m```
- Run method on validation images
