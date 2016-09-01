#!/bin/bash

########################
# Config data

# Number of screens to record
screens=2

# Time between screenshots in seconds
sleeptime=1

# Record webcam ? [ y or n ]
webcam=“y”

# Webcam position
# NorthWest, NorthEast, SouthWest, SouthEast
webcampos=southeast

# Webcam size for overlay
webcamsize=512

# Webcam Padding
# Distance in pixels from border for the webcam overlay
webcampading=10

# Config data
########################


########################
# Check folders and such
if [ ! -d ./screens ]
then
   echo Creating screens folder…
   mkdir screens

fi

for (( screen=1; screen<=screens; screen++)) 
do 
   newdir=./screens/screen_$screen
   if [ ! -d $newdir ]
   then
      echo Creating folder $newdir
      mkdir ./screens/screen_$screen

   else
      if [[ -n $(find $newdir -type f -name "*.jpg") ]]
      then
        rm ${newdir}/*.jpg

      fi

   fi

done

if [ screens > 1 ]
then
   if [ ! -d ./screens/merged ]
   then
      echo Creating merged folder...
      mkdir ./screens/merged

   else
      if [[ -n $(find ./screens/merged -type f -name "*.jpg") ]]
      then
         rm ./screens/merged/*.jpg

      fi

   fi

fi

if [ $webcam == “y” ]
then
   if [ ! -d ./webcam ]
   then
      echo Creating webcam folder…
      mkdir webcam
   else
      if [[ -n $(find ./webcam -type f -name "*.jpg") ]]
      then
         rm ./webcam/*.jpg

      fi

   fi

   if [ ! -d ./screens/mergedwcam ]
   then
      echo Creating mergedwcam folder...
      mkdir ./screens/mergedwcam

   else
      if [[ -n $(find ./screens/mergedwcam -type f -name "*.jpg") ]]
      then
         rm ./screens/mergedwcam/*.jpg

      fi

   fi

fi

# Check folders and such
########################

screencapcmd="screencapture -x"
filecounter=0

echo Screen Capture started...
echo Press E to finish.

keypresse=""
while :
do
   read -t 1 -n 1 keypressed
   if [[ $keypressed == e ]]
   then
      break

   fi

   screencmd2="${screencapcmd}"
   for (( screen=1; screen<=screens; screen++ ))
   do
      screencmd2+=" ./screens/screen_${screen}/screen-$(printf %05d $filecounter).jpg"

   done;

   $screencmd2;
   if [ $webcam == “y” ]
   then
      ./imagesnap/imagesnap -q "./webcam/camera-$(printf %05d $filecounter).jpg";

   fi

   filecounter=$[$filecounter + 1]
   sleep $sleeptime;

done;

# Merge Print Screens
if [ screens > 1 ]
then
   echo .
   echo Merging Screen Captures...
   filecounter=0
   for screenfile in ./screens/screen_1/*.jpg
   do
      convertcmd2="convert +append";
      for (( screen=1; screen<=screens; screen++ ))
      do
         convertcmd2+=" ./screens/screen_${screen}/${screenfile##*/}"
      done;
      convertcmd2+=" ./screens/merged/screens-$(printf %05d $filecounter).jpg"
      $convertcmd2;

      filecounter=$[$filecounter + 1]

   done;

fi

# Add webcam overlay
if [ $webcam == “y” ]
then
   echo Overlaying webcam...
   overlaycmd=
   if [ screens > 1 ]
   then
      for screenfile in ./screens/merged/*.jpg
      do
         file=${screenfile##*/};
         composite -compose atop -geometry ${webcamsize}x${webcamsize}+${webcampading}+${webcampading} -gravity ${webcampos} \
         ./webcam/camera-${file#*-} ./screens/merged/screens-${file#*-} ./screens/mergedwcam/final-${file#*-}

      done;

   else
      for screenfile in ./screens/screen_1/*.jpg
      do
         file=${screenfile##*/};
         composite -compose atop -geometry ${webcamsize}x${webcamsize}+${webcampading}+${webcampading} -gravity ${webcampos} \
         ./webcam/camera-${file#*-} ./screens/screen_1/screens-${file#*-} ./screens/mergedwcam/final-${file#*-}

      done;

   fi

fi

echo Creating video...
ffmpeg -r 16 -i ./screens/mergedwcam/final-%5d.jpg ./timelapse.mp4