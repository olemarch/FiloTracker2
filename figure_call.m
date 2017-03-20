fh = figure;
axes('units','pix')
plot(1:10)

set(fh,'windowbuttondownfcn',{@wincall,get(gca,'position')})
        