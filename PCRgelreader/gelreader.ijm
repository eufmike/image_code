/*
 This macro is designed for identifying the genotyping result after PCR. 
 Copyright: Michael Chien-cheng Shih
 
 */
	
	
//define dialog box
	Dialog.create("Continue");
	choice = newArray("Yes", "No"); 
	Dialog.addChoice("Do you have more samples?", choice);

//Start!!!!
	run("Clear Results");

//Function: change the format for gel analysis
	run("RGB Color");
	run("8-bit");

//Auto contrast
	run("Enhance Contrast", "saturated=0.35");
//rotate the image <- set default????
	run("Rotate... ", "angle=0 grid=3 interpolation=Bilinear stack");
	
//select the gel and crop it
	makeRectangle(261, 8, 875, 1010);
	waitForUser("outline the gel")
	run("Auto Crop");
//resize the image
	run("Size...", "width=1024 height=1024 average interpolation=Bilinear");

//process gel image: background subtraction
	rad = getNumber("Enter radius", 15);
	im = getImageID();
	run("Duplicate...", "title=background"); 
	bgim = getImageID();
	run("Maximum...", "radius="+rad); 
	run("Minimum...", "radius="+rad); 
	run("Gaussian Blur...", "sigma="+rad); 
	getRawStatistics(nPixels, mean, min); 
	run("Subtract...", "value="+min); 
	imageCalculator("Subtract", im, bgim); 
	selectImage(bgim);
	close(); 
	run("Duplicate...", "title=outcome");
	ocim = getImageID();
	run("Invert");
	run("Enhance Contrast", "saturated=0.35");//auto contrast

/*
 * Gel Reader
 */

//round counter
	sampleround = 1;

do {
	selectImage(im);
	run("Duplicate...", "title=ROI"); 
	groi = getImageID();
	
//select the ROI on gel
	selectImage(groi);
	well = getNumber("Enter Number of Sample", 20);
	makeRectangle(30, 247, 48.2*well, 19);
	waitForUser("outline ROI");
	getSelectionBounds(x,y,w,h);
	
//process ROI: auto contrast
	run("Crop");
	bdim = getImageID();
	run("Enhance Contrast", "saturated=0.35");
	run("Invert");
	setAutoThreshold("Default");
	//setThreshold(0, 218);
	setOption("BlackBackground", false);
	run("Convert to Mask");

	run("Select All");
	run("Size...", "width=1000 height=300 average interpolation=Bilinear");
	makeRectangle(0, 100, 1000, 100);
	

//gel reading: gel analysis
	run("Gel Analyzer Options...", "vertical=1 horizontal=1");	
	run("Select First Lane");
	run("Plot Lanes");//set default?????

	
	bandplot = getImageID();
	selectImage(bdim);
	close();
	selectImage(bandplot);
	run("Size...", "width=1000 height=1000 average interpolation=Bilinear");

//Auto threshold: <- try to make a dialog
	setAutoThreshold("Default");
	setThreshold(0, 254);
	run("Convert to Mask");
	
//setTool("wand");
	doWand(300, 16);
    getRawStatistics(nPixels);
	bgarea = nPixels;
	run("Select None");

	rarea = newArray(well);
	rtext = newArray(well);
	
	
	for(i=0; i < well; i=i+1){
		doWand(((1000/well)/2+i*(1000/well)), 800);
		getRawStatistics(nPixels);
		reading = nPixels;

		if(reading == bgarea) {
			rarea[i] = 0;	
		}
		else{
			rarea[i] = 1; 		
		}
		if(reading == bgarea) {
			rtext[i] = "";	
		}
		else{
			rtext[i] = "+"; 		
		}
		run("Select None");
	} 
	selectImage(bandplot);
	close();
		
//plot text on image
	selectImage(ocim);

	for(i=0; i < well; i=i+1){
		setFont("Arial", 25);
		drawString(rtext[i], x+13+(w/well)*i, y+70);
		}

//show dialog box
	Dialog.show();
	choicer = Dialog.getChoice();

//print the result in results window
	Array.show("Result"+sampleround, rarea);
	sampleround = sampleround + 1;

	
}
while (choicer == "Yes");
	selectImage(im);
	close();