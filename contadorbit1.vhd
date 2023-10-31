----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:57:32 10/26/2023 
-- Design Name: 
-- Module Name:    contadorbit1 - arq_contadorbit1 
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

entity contadorbit1 is
 Port ( entradac1 : in STD_LOGIC_VECTOR(3 downto 0);
        saidac1 : out STD_LOGIC_VECTOR(3 downto 0);
		  flagzero: out  std_logic);
end contadorbit1;

architecture arq_contadorbit1 of contadorbit1 is

--Sinais temporários
signal b0 : std_logic;
signal b1 : std_logic;
signal b2 : std_logic;
signal b3 : std_logic;

begin
--Verifica bit a bit através de expressões lógicas encontrando o caso no qual o número se enquadra
b0 <= ( not(entradac1(2)) and not(entradac1(1)) ) and not(entradac1(0));
b1 <= ( (not(entradac1(0)) and not(entradac1(1)) ) and entradac1(2)) or (not(entradac1(2)) and (entradac1(0) xor entradac1(1) ));
b2 <= ( (not(entradac1(2)) and (entradac1(1)) ) and entradac1(0)) or (entradac1(2) and (entradac1(0) xor entradac1(1) ));
b3 <= (entradac1(2) and entradac1(1)) and entradac1(0);

--Lógica de saída
saidac1(0) <= b1 or b3;
saidac1(1) <= b2 or b3;
saidac1(3 downto 2) <= "00";
flagzero <= b0;

end arq_contadorbit1;


