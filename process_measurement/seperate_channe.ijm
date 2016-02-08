dir = getDirectory("Choose a Directory");
list = getFileList(dir);
splitDir = getDirectory("Choose a Directory");

for (i=0; i<list.length; i++) {
      open(dir + list[i]);
      imgName=getTitle(); 
      baseNameEnd=indexOf(imgName, ".tif"); 
      baseName=substring(imgName, 0, baseNameEnd); 
      
      run("Split Channels"); 
      selectWindow("C1-" + imgName); 
      saveAs("Tiff", splitDir+baseName + ".tif");

      run("Close All"); 
   }