----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:14:48 10/22/2023 
-- Design Name: 
-- Module Name:    somador_1bit - arq_somador_1bit 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity somador_1bit is
    Port ( bit1,bit2,cin1bit : in  STD_LOGIC;
           soma1bit,cout1bit : out  STD_LOGIC);
end somador_1bit;

architecture arq_somador_1bit of somador_1bit is

begin
soma1bit <= bit1 xor bit2 xor cin1bit;
cout1bit <= (bit1 and (bit2 xor cin1bit)) or (bit2 and cin1bit);

end arq_somador_1bit;
-------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity somador_4bits is
	 GENERIC (N:INTEGER := 4);
    Port ( a1,b1 : in  std_logic_vector(3 downto 0); --Entradas
           cin4bits : in  STD_LOGIC; --Carry in
           soma4bits : out std_logic_vector(3 downto 0);
           cout4bits,overflow4bits : out  STD_LOGIC);
end somador_4bits;

architecture arq_somador_4bits of somador_4bits is

-- Componente soma bit a bit
Component somador_1bit is
  Port ( bit1,bit2,cin1bit : in  STD_LOGIC;
           soma1bit,cout1bit : out  STD_LOGIC);
END Component;

--Sinais temporários
Signal carry:  std_logic_vector(N downto 0);

begin
  
	carry(0) <= cin4bits;
	generate_adder: for i in 0 to 3 GENERATE --Realizada a soma bit a bit pelos índices, salvando seus respectivos carrys em um vetor auxiliar
		fa_somador_1bit: somador_1bit PORT MAP(a1(i),b1(i),carry(i),soma4bits(i),carry(i+1));
	end GENERATE;
	cout4bits <= carry(N);
	overflow4bits <= (a1(3) xor b1(3)) xor carry(3);

END arq_somador_4bits;

