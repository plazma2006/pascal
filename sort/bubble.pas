var
	n, i, j, g  : byte;
	a : array[1..100] of byte;

begin
	// считать количество элементов массива
	readln(n);
	// заполнить массив случайными числами в количестве ранее указанным числом
	for i := 1 to n do a[i] := random(100);
	// вывести массив на экран
	for i := 1 to n do write(a[i], ' ');
	writeln();
	// отсортировать массив
	for i := 1 to n-1 do
		for j := 1+i to n do
			begin 
				if a[j] < a[i] then 
					begin
						g := a[j];
						a[j] := a[i];
						a[i] := g;
					end;
			end;
	// вывести массив на экран
	for i := 1 to n do write(a[i], ' ');
	// подождать нажатия клавиши ентер
	readln;
end.
