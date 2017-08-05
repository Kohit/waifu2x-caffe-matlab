function protoname = createProto(filename,h,w)
f = fopen([filename '.txt'],'rt');
fo = fopen([filename '.prototxt'],'wt');
while ~feof(f)
    line = fgetl(f);
    oline = strrep(line,'input_dim: width',['input_dim: ' num2str(w)]);
    oline = strrep(oline,'input_dim: height',['input_dim: ' num2str(h)]);
    fprintf(fo,'%s\n',oline);
end
fclose(f);
fclose(fo);
protoname = [filename '.prototxt'];

