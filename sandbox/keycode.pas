uses
   crt;

var
   ch : char;

begin
   repeat

      if keypressed then
         begin
            ch := ReadKey;
            writeln('Charkey ', ch, ' code = ', ord(ch));
         end;

   until ord(ch)=27;
end.