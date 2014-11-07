Data URL image extractor
===========================

This software extracts the images encoded as data URL and save them in separate image files.

It significantly reduces your SQL dump files or HTML pages by replacing the heavy data URL images by simple absolute URLs that point to the freshly extracted images.

The input file must be a text file (eg: HTML, SQL).

The images extracted can be **jpg**, **gif** or **png**.


##What are data URLs ?
>Data URLs are a Uniform Resource Identifier scheme that allow you to include data items inline in a web page as if they were being referenced as external resources.

>Here is a example of html with an image encoded as data URL:
>```
<img width="11" height="14" src="data:image/gif;base64,R0lGOD
lhCwAOAMQfAP////7+/vj4+Hh4eHd3d/v7+/Dw8HV1dfLy8ubm5vX19e3t7fr
6+nl5edra2nZ2dnx8fMHBwYODg/b29np6eujo6JGRkeHh4eTk5LCwsN3d3dfX
13Jycp2dnevr6////yH5BAEAAB8ALAAAAAALAA4AAAVq4NFw1DNAX/o9imAsB
tKpxKRd1+YEWUoIiUoiEWEAApIDMLGoRCyWiKThenkwDgeGMiggDLEXQkDoTh
CKNLpQDgjeAsY7MHgECgx8YR8oHwNHfwADBACGh4EDA4iGAYAEBAcQIg0Dk
gcEIQA7" alt="File Icon”>
```
> From www.dataurl.net

##How to use it ?
* Select the source file
* Select the export folder
* Enter the url path where the images will be uploaded (eg: http://www.example.com/images/)
* Click launch!

The software will create a version of the source file where the data URLs are replaced by a simple URL. It will also create an images folder that contains the extracted images.

##Compatibility
Mac OS X 10.10

##Example
###Input
Source file:
```
<img width="11" height="14" src="data:image/gif;base64,R0lGOD
lhCwAOAMQfAP////7+/vj4+Hh4eHd3d/v7+/Dw8HV1dfLy8ubm5vX19e3t7fr
6+nl5edra2nZ2dnx8fMHBwYODg/b29np6eujo6JGRkeHh4eTk5LCwsN3d3dfX
13Jycp2dnevr6////yH5BAEAAB8ALAAAAAALAA4AAAVq4NFw1DNAX/o9imAsB
tKpxKRd1+YEWUoIiUoiEWEAApIDMLGoRCyWiKThenkwDgeGMiggDLEXQkDoTh
CKNLpQDgjeAsY7MHgECgx8YR8oHwNHfwADBACGh4EDA4iGAYAEBAcQIg0Dk
gcEIQA7" alt="File Icon”>
```
Url path where the images will be uploaded: `http://www.example.com/images/`
###Output
Exported file:
```
<img width="11" height="14" src="http://www.example.com/images/ca9c24a1e75b36ba81abf90d13fb5212.gif" alt="File Icon”>
```
Extracted image: `ca9c24a1e75b36ba81abf90d13fb5212.gif`

##License
The MIT License (MIT)

Copyright (c) 2014 Nicolas Mahé
