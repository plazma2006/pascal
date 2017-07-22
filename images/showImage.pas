program LoadBMP;
 var f:file; bitmap:pointer; size:longint; 
 begin
   {$I-} Assign(f,'image.bmp'); Reset(f,1); {$I+}
   if (IOResult <> 0) then Exit; 
   size:=FileSize(f);
   GetMem(bitmap,size);
   BlockRead(f,bitmap^,size);
   Close(f);
   PutImage(0,0,bitmap^,NormalPut);
   FreeMem(bitmap);
 end.