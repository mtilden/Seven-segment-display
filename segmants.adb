-- Name:	Madison Tilden MWF 2PM
-- Date:	Oct 2, 2014
-- Course:  ITEC 320 Procedural Analysis and Design

-- Purpose: Your program will read, from standard input and until eof, 
--          pairs of 7-character strings. Each string represents the segments
--			of a seven segment display, and each character will be '1' or '0',
--			representing that the segment is on or off, respectively. Each pair
--			is supposed to represent sequential digits; however, there might be
--			errors in the bit strings and the pair of strings might not represent
--			a valid pair of sequential digits. The task of the assignment is to 
--			determine which pair(s) of sequential digits is closest to the pair
--			of input strings. We define closest to mean have the smallest 
--			Hamming Distance (HD).

-- SAMPLE INPUT
--  1100111 0000011  
--  0000011 0111110
--  0011111 1011101
--  1001011 0010011

--  creates this output:

--  1100111 0000011 : Original Pair
--  1110111 0000011 : Closest Pair =  0 1.  Distances: 1 0.  Total: 1

--  0000011 0111110 : Original Pair
--  0000011 0111110 : Closest Pair =  1 2.  Distances: 0 0.  Total: 0

--  0011111 1011101 : Original Pair
--  0011111 1001011 : Closest Pair =  3 4.  Distances: 0 3.  Total: 3
--  1001011 1011101 : Closest Pair =  4 5.  Distances: 3 0.  Total: 3
--  1011101 1111101 : Closest Pair =  5 6.  Distances: 2 1.  Total: 3

--  1001011 0010011 : Original Pair
--  1001011 1011101 : Closest Pair =  4 5.  Distances: 0 4.  Total: 4
--  1111101 0010011 : Closest Pair =  6 7.  Distances: 4 0.  Total: 4
--  1011011 1110111 : Closest Pair =  9 0.  Distances: 1 3.  Total: 4

with ada.text_io; use ada.text_io; 
with ada.integer_text_io; use ada.integer_text_io; 

procedure segments is
	type A_of_As is array (0 .. 9, 1 .. 7) of Character;
	type PairsArr is array(1 .. 7) of Character;
	pair1, pair2 : PairsArr;
	
	
	procedure put2DArr(pattern : in A_of_As; a : in Integer) is 
	
	begin
	
		for i in 1 ..7 loop
		
			put(pattern(a , i));
			
		end loop;
	end put2DArr;
	-------------------------------------------------------
	
	procedure putArr(p : in PairsArr) is 
	
	begin
	
		for i in 1 ..7 loop
		
			put(p(i));
			
		end loop;
	end putArr;
	-------------------------------------------------------
	
	procedure getpair (pair1, pair2: out PairsArr) is
		
		c: Character;
		
	begin
		GET_P1:
		for i in pair1'range loop
		     get(pair1(i)); -- get each number for 7bit number
		end loop GET_P1;
		-------------
		get(c);		-- get the space between pair numbers in txt file
		-------------
		GET_P2:
		for a in pair2'range loop
			get(pair2(a));	-- get each number for 7bit number
		end loop GET_P2;
		
		
	end getpair;
	
		---------------------------------------------------------
		
	function digit_compare(pattern: in A_of_As; pair: in PairsArr; i : in Integer) return Integer is
		
		errCount : Integer := 0;
		
	begin
		
		for x in 1 .. 7 loop
	
			if pattern(i, x) /= pair(x) then
			  errCount := errcount + 1;
			 end if;	
			
		end loop;
		
	  return errCount;
		
	end digit_compare;
	

	--------------------------------------------------------
	
	procedure process (pair1, pair2: in PairsArr) is
		
		min : Integer := 8; --min is what gets printed out by Total
		i, a, b : Integer := 0;
		
		pattern : constant A_of_As := (('1', '1', '1', '0', '1', '1', '1'),  -- ZERO
									   ('0', '0', '0', '0', '0', '1', '1'),  -- ONE
									   ('0', '1', '1', '1', '1', '1', '0'),  -- TWO
									   ('0', '0', '1', '1', '1', '1', '1'),  -- THREE
									   ('1', '0', '0', '1', '0', '1', '1'),  -- FOUR
									   ('1', '0', '1', '1', '1', '0', '1'),  -- FIVE
									   ('1', '1', '1', '1', '1', '0', '1'),  -- SIX
									   ('0', '0', '1', '0', '0', '1', '1'),  -- SEVEN
									   ('1', '1', '1', '1', '1', '1', '1'),  -- EIGHT
									   ('1', '0', '1', '1', '0', '1', '1')); -- NINE
									   
		type distance is array(0 .. 9) of Integer;
		p1_distance, p2_distance : distance;
	begin
		set_col(1);
		putArr(pair1);
		put(" ");
		putArr(pair2);
		put_line(" : Original Pair"); --finishes printing out first line to be printed
		
		--compare both pairs to each 7bit number 0 to 9 
		-- use digit compare function to get hamming distance
		for i in 0 .. 9 loop
			-- i is needed to know which number to compare
		    p1_distance(i) := digit_Compare(pattern, pair1, i); 
		    p2_distance(i) := digit_Compare(pattern, pair2, ((i+1)mod 10));
		
			-- if min is bigger than the distances together then change min 
			if min > (p1_distance(i) + p2_distance(i)) then
			   min := (p1_distance(i) + p2_distance(i));
		    end if;
	     end loop;
		 
		 -----------------------------------------
		 
		 for a in 0 .. 9 loop
			 -- when min equals the p1 and p2 distances then print out
			 -- the closest pair, both distances and the total/ min
			 if min = (p1_distance(a) + p2_distance(a)) then
				 b := ((a+1)mod 10);
				 set_col(1);
				 -- prints out first closest distance 7bit number
				 put2DArr(pattern, a);
				 put(" "); 						--prints a space
				 --prints out second closest distance 7bit number
				 put2DArr(pattern, b);
				 --prints the number 0 to 9 of the first and second closest pair
 				 put(" : Closest Pair = ");
				 put(a'img);
				 put(" "); 					--CLOSEST PAIR 1 
				 put(b'img); 				--CLOSEST PAIR 2
				 -- prints the distances of p1 and p2
				 put(". Distances:");
				 put(p1_distance(a)'img);			--p1 distance of a
				 put(" ");
				 put(p2_distance(a)'img);			--p2 distance of a
				 -- prints the min number needed to change
				 put(".  Total:");
				 put(min'img);
				 new_line; 
			 end if;
		 end loop;
		 new_line;
	end process;
	
	---------------------------------------------------------
	


begin
--while not end of file 
	while not end_of_file loop
		
		getpair(pair1, pair2); -- get pairs of 7bit numbers
		process(pair1, pair2); -- process the pairs to get closest pair and distance
		
	end loop;

end segments;
