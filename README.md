# Mac - Timelapse 
Timelapse command line tool for MacOSx

[About](#about)  
[Copyright & Licensing](#copyright--licensing)  
[Contact](#contact) 

## About

Trying to be ready for the next Ludum Dare, I've been searching for a tool to do the timelapse on MAC.
After some search, I found out that there's no one simple solution for that, like we have for windows.
We only have one command line for that, which does not support multiple screens, and webcam.

Because of that, I did some home work, and found a way to do that.
I created one script which do that more or less automatically, using some open-source tools.

Basically, I do screen captures using the native screencapture
And webcam photos using imagesnap.

After that, I merge all the files using imagemagick
And to finish, I use the ffmpeg to create the video.

You need to install imagemagick and ffmpeg, to be able to use this.

In the zip folder, you will find the timelapse.sh
At header of the file, you can change the parameters in the way you want.

After that, you can run the script, and press 'E' to exit.
The script will combine all the images, and generate the video inside the folder you executed.

## Copyright & Licensing

The base project code is copyrighted by Roberto "Seth" Caetano and
is covered by multiple licenses.

All program code is licensed under GPL v3.0 unless otherwise
specified.  Please see the "LICENSE" file for more information.

Imagesnap command line-tool is copyrighted to Robert Harder (rob@iHarder.net)

## Contact
You can contact me by email:
    contato@robertocaetano.com
