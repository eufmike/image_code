dir = getDirectory("Choose a Directory");
list = getFileList(dir);

for (i=0; i<list.length; i++) {
    open(dir + list[i]);
    run("Measure"); 
    run("Close All");    
}