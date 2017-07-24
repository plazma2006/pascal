uses CRT;
var
   r : String;
   z,f : byte;

Procedure doCycle;
begin
 for z := 1 to f do
      begin
         textcolor(z);
         Writeln(z, ' - ', r);
      end;
end;

begin


   writeln('zdrastvui');

   write('shto budem delat: ');
   readln(r);

   write('skolko nado pisat strochek: ');
   readln(f);
   doCycle;

   readln;

end.
