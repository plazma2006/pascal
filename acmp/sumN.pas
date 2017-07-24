var
	n, i : Integer;
	s : LongInt;
begin
	s := 0;
	readln(n);
	if n < 0 then
		begin
			
		end
	else
		begin
			for i := 1 to n do s := s + i;
		end;
	write(s);
end.