im = getImageID();
dir = getDirectory("Choose a Directory");

for (i=1; i<22; i++) {
      run("Make Substack...", "slices=1-21 frames="+i);
      subim = getImageID();

      	if(i < 10) {
      		imnumber = "0" + i; 
      	} else {
      		imnumber = i; 
      	}
      saveAs("Tiff", dir+imnumber); 
      
      selectImage(subim);
      close();  
   }