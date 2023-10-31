----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:10 10/24/2023 
-- Design Name: 
-- Module Name:    espelho - arq_espelho 
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

entity espelho is
    Port ( ae : in  STD_LOGIC_VECTOR(3 downto 0);
           saidae : out  STD_LOGIC_VECTOR(3 downto 0));
end espelho;

architecture arq_espelho of espelho is

begin
--Inverte a posição dos bits
saidae(0) <= ae(3);
saidae(1) <= ae(2);
saidae(2) <= ae(1);
saidae(3) <= ae(0);
end arq_espelho;

