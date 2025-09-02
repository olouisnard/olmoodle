function outfilename = modsuf(infilename, newextension)

[inpath, name, ext] = fileparts(infilename);

outfilename = [inpath, name, newextension] ;
