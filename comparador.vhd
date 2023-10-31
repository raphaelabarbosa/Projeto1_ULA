----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:04 10/23/2023 
-- Design Name: 
-- Module Name:    comparador - arq_comparador 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Retorna 0001 para A = B, 0010 para A > B e 0011 para A < B.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador is
    Port ( acomp,bcomp : in  STD_LOGIC_VECTOR (3 downto 0);
           saidacomp : out  STD_LOGIC_VECTOR (3 downto 0));
end comparador;

architecture arq_comparador of comparador is

--Sinais temporários
signal Z3 : STD_LOGIC;
signal Z2 : STD_LOGIC;
signal Z1 : STD_LOGIC;
signal Z0 : STD_LOGIC;
signal igual : STD_LOGIC;
signal maior : STD_LOGIC;
signal menor : STD_LOGIC;

begin
--Caso A = B. Comparação bit a bit
Z3 <= acomp(3) xnor bcomp(3);
Z2 <= acomp(2) xnor bcomp(2);
Z1 <= acomp(1) xnor bcomp(1);
Z0 <= acomp(0) xnor bcomp(0);

igual <=  ((Z3 and Z2) and Z1) and Z0;

--Caso A > B
maior <= (acomp(3) and (not(bcomp(3))))or(Z3 and((acomp(2) and (not(bcomp(2))))or(Z2 and( (acomp(1) and (not(bcomp(1)))) or (Z1  and (acomp(0) and (not(bcomp(0))) ))))));

--Caso A < B
menor <= (bcomp(3) and (not(acomp(3))))or(Z3 and((bcomp(2) and (not(acomp(2))))or(Z2 and( (bcomp(1) and (not(acomp(1)))) or (Z1  and (bcomp(0) and (not(acomp(0))) ))))));

--Lógica de Saída
saidacomp(0) <= igual or menor;
saidacomp(1) <= maior or menor;
saidacomp (3 downto 2) <= "00";

end arq_comparador;

