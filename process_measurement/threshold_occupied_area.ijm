dir = getDirectory("Image files");
list = getFileList(dir);
newdir = getDirectory("Save processed images to...");
result_dir = getDirectory("Save results to...");


run("Set Measurements...", "area area_fraction redirect=None decimal=3")

autothre = newArray("Default", "Huang", "Intermodes", "IsoData", "Li", "MaxEntropy", 
					"Mean",
					"MinError(I)",
					"Minimum", 
					"Moments", 
					"Otsu", 
					"Percentile", 
					"RenyiEntropy",
					"Shanbhag", 
					"Triangle", 
					"Yen" ); 


for (j = 0; j<autothre.length; j++){
		print(autothre[j]);
		 
		saveresult_dir = result_dir;
		print(saveresult_dir); 
		File.makeDirectory(saveresult_dir);
		saveimage_dir = newdir + autothre[j] + "\\";
		File.makeDirectory(saveimage_dir);
		
		for (i=0; i<list.length; i++){
		
		open(dir + list[i]);
		imgName=getTitle();
		
		run("Auto Threshold", "method=" + autothre[j] + " ignore_black white");
		run("Threshold...");
		saveAs("Tiff", saveimage_dir + list[i]);
		run("Measure");
		 
		
		selectWindow(imgName); 
		run("Close");
		}
		
		selectWindow("Results");
		saveAs("Results", saveresult_dir + autothre[j] + ".txt"); 
		run("Clear Results");
}


