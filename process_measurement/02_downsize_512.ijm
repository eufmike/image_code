dir = getDirectory("Choose a Directory");
list = getFileList(dir);
newdir = getDirectory("Choose a Directory");

for (i=0; i<list.length; i++) {
      open(dir + list[i]);
      imgName=getTitle(); 
      baseNameEnd=indexOf(imgName, ".tif"); 
      baseName=substring(imgName, 0, baseNameEnd); 

run("Scale...", 
"x=0.5 y=0.5 width=512 height=512 interpolation=Bilinear average create");		

      saveAs("Tiff", newdir+baseName + ".tif");
      run("Close All"); 
   }