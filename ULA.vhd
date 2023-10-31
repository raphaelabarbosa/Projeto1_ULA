----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:04 10/30/2023 
-- Design Name: 
-- Module Name:    ULA - arq_ULA 
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
use ieee.std_logic_arith.all;

entity ULA is
generic(t_max : integer := 40000000);
    Port ( clk : in  STD_LOGIC; --Clock
			  slt : in STD_LOGIC_VECTOR(2 downto 0);--Seletor
           --SaidaA,SaidaB : out STD_LOGIC_VECTOR(3 downto 0);
			  saidaOp : out STD_LOGIC_VECTOR(3 downto 0);
			  saidanegativo,saidazero,saidacout,saidaover : out STD_LOGIC);
end ULA;

architecture Behavioral of ULA is

--Componentes
component operacoes is
    Port ( A,B : in  STD_LOGIC_VECTOR(3 downto 0); 
           Seletor : in  STD_LOGIC_VECTOR(2 downto 0);
			  clkop : in std_logic;
           Saida: out  STD_LOGIC_Vector(3 downto 0); 
           Negativo,Zero,Cout,Overflow : out  STD_LOGIC);			  
end component;

--Sinais temporários
signal contagemAf : STD_LOGIC_VECTOR(3 downto 0);
signal contagemBf : STD_LOGIC_VECTOR(3 downto 0);
signal saidaOptemp : STD_LOGIC_VECTOR(3 downto 0);
signal saidanegativotemp : STD_LOGIC;
signal saidazerotemp : STD_LOGIC;
signal saidacouttemp : STD_LOGIC;
signal saidaovertemp : STD_LOGIC;

begin
	
	--Contador(Números com 1 bit de sinal e 3 bits de magnitude)
	process (clk)
	variable t : integer range t_max downto 0 := 0;
	--Variável auxiliar 8 bits
	variable contagemA : integer range 0 to 8;
	variable contagemB : integer range 0 to 8;
	begin
		--Na borda de subida de clock
		if rising_edge(clk) then
		
			if(t <= t_max) then
				t := t + 1;
			else
				contagemB := contagemB + 1;
				if contagemB = 8 then
					contagemA := contagemA + 1;
					contagemB := 0;
				end if;
				if contagemA = 8 then
					contagemA := 0;
					contagemB := 0;
				end if;
				t := 0;
			end if;
	
		end if;
		-- conversão de integer para std_logic_vector com 8 bits
		contagemAf <= conv_std_logic_vector(contagemA, 4);
		contagemBf <= conv_std_logic_vector(contagemB, 4);

	end process;
	
	--Chamada operação e atribuição das saídas
	FA_operacoes: operacoes port map(contagemAf,contagemBf,slt,clk,saidaOptemp,saidanegativotemp,saidazerotemp,saidacouttemp,saidaovertemp);
	--SaidaA <= contagemAf;
	--SaidaB <= contagemBf;
	saidaOp <= saidaOptemp;
	saidanegativo <= saidanegativotemp;
	saidazero <= saidazerotemp;
	saidacout <= saidacouttemp;
	saidaover <= saidaovertemp;
end Behavioral;



