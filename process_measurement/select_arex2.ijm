dir = getDirectory("Choose a Directory");
list = getFileList(dir);
newdir = getDirectory("Choose a Directory");

for (i=0; i<list.length; i++) {
    open(dir + list[i]);
    imgName=getTitle(); 
    baseNameEnd=indexOf(imgName, ".tif"); 
    baseName=substring(imgName, 0, baseNameEnd);       
    run("Enhance Contrast", "saturated=0.35");
      
    makeRectangle(0, 0, 128, 128); 
    waitForUser("outline ROI");
    run("Duplicate...", " ");
	saveAs("Tiff", newdir+baseName + "_1.tif");

	makeRectangle(256, 0, 128, 128); 
	waitForUser("outline ROI");
    run("Duplicate...", " ");
	saveAs("Tiff", newdir+baseName + "_2.tif");
	  
    run("Close All"); 
   }