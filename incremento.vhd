----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:10:54 10/22/2023 
-- Design Name: 
-- Module Name:    incremento - arq_incremento 
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

entity incremento is
    Port ( aI : in  std_logic_vector(3 downto 0);
           SI : out  std_logic_vector(3 downto 0);
           CoutI,OverflowI : out  STD_LOGIC);
end incremento;

architecture arq_incremento of incremento is

--Componentes
Component somador_4bits is
    Port ( a1,b1 : in  std_logic_vector(3 downto 0);
           cin4bits : in  STD_LOGIC;
           soma4bits : out std_logic_vector(3 downto 0);
           cout4bits,overflow4bits : out  STD_LOGIC);
end Component;

--Sinais temporários
signal bI : std_logic_vector(3 downto 0);
signal cinI: std_logic;

begin

	bI <= "0001"; 
	cinI <= '0';
	--Utiliza do módulo somador fixando uma entrada como 0001
	FAI_somador_4bits: somador_4bits  PORT MAP(aI,bI,cinI,sI,coutI,OverflowI);

end arq_incremento;

