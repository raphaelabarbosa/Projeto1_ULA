----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:39:31 10/21/2023 
-- Design Name: 
-- Module Name:    operacoes - arq_operacoes 
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
-------------------------------------------------------------------------------------------------------
--         (A0..A3)  (B0..B3)         Sel2  Sel1  Sel0 | Operação
--          _______  _______          ----------------------------
--          \      \/      /            0     0     0  |  A + B
--  [s0..s2] \            /             0     0     1  |  A - B (Complemento de 2)
--            \__________/              0     1     0  |  Incremento +1
--              (00..03)                0     1     1  |  Troca de Sinal
--                                      1     0     0  |  Contador de bits ativos
--                                      1     0     1  |  Inverter bits
--                                      1     1     0  |  Par(0) ou ímpar (1)
--                                      1     1     1  |  Comparador (0001- Igual/0010- A>B/0011 - B>A)

-- Operações de 1 número utilizam a entrada A
--Saída S e quatro flags (Zero, negativo, carry out, overflow)

--O trabalho deve ter 3 chaves externas (switchers)*

--Decidir as outras quatro operações da ALU*

--Funcionamento:
--Os operandos de entrada são gerados por um módulo auxiliar que conterá um contator que
--percorrerá todos os binários representados por 4 bits. As entradas são mostradas simultaneamente
--nos LEDs. Em seguida, a ALU recebe os operandos e produz o resultado também mostrado no display
--de 7 segmentos. Além disso, a ALU gera 4 flags que são mostradas nos LEDs.
--As entradas da operacoes são geradas por um módulo auxiliar, um contador, parte integrante do projeto.
--As duas entradas são mostradas, juntamente com o resultado, nos displays de 7 segmentos
--disponíveis. Os LEDs são utilizados para mostrar os quatro "flags". Os operandos vão mudando, em
--ordem crescente, a cada 2 segundos.
--------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity operacoes is
    Port ( A,B : in  STD_LOGIC_VECTOR(3 downto 0); -- 1 bit de Sinal e 3 bits de magnitude
           Seletor : in  STD_LOGIC_VECTOR(2 downto 0);
			  clkop: in STD_LOGIC;
           Saida: out  STD_LOGIC_Vector(3 downto 0); -- 1 bit de Sinal e 3 bits de magnitude
           Negativo,Zero,Cout,Overflow : out  STD_LOGIC);
			  
end operacoes;

architecture arq_operacoes of operacoes is

-- Declaração de componentes
component somador_4bits is
	 GENERIC (N:INTEGER := 4);
    Port ( a1,b1 : in  std_logic_vector(3 downto 0);
           cin4bits : in  STD_LOGIC;
           soma4bits : out std_logic_vector(3 downto 0);
           cout4bits,overflow4bits : out  STD_LOGIC);
end component;

component incremento is
    Port ( aI : in  std_logic_vector(3 downto 0);
           SI : out  std_logic_vector(3 downto 0);
           CoutI,OverflowI : out  STD_LOGIC);
end component;

component comparador is
    Port ( acomp,bcomp : in  STD_LOGIC_VECTOR (3 downto 0);
           saidacomp : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component espelho is
    Port ( ae : in  STD_LOGIC_VECTOR(3 downto 0);
           saidae : out  STD_LOGIC_VECTOR(3 downto 0));
end component;

component contadorbit1 is
 Port ( entradac1 : in STD_LOGIC_VECTOR(3 downto 0);
        saidac1 : out STD_LOGIC_VECTOR(3 downto 0);
		  flagzero: out  std_logic);
end component;

--Sinais temporários
--Soma
signal Saidasoma : STD_LOGIC_Vector(3 downto 0);
signal Zerosoma : STD_LOGIC;
signal Coutsoma : STD_LOGIC;
signal Overflowsoma : STD_LOGIC;
--Subtração
signal Saidasub : STD_LOGIC_Vector(3 downto 0);
signal Negativosub : STD_LOGIC;
signal Zerosub : STD_LOGIC;
signal Coutsub : STD_LOGIC;
signal Overflowsub : STD_LOGIC;
--Incremento
signal Saidainc : STD_LOGIC_Vector(3 downto 0);
signal Zeroinc : STD_LOGIC;
signal Coutinc : STD_LOGIC;
signal Overflowinc : STD_LOGIC;
--Troca de sinal
signal Saidatroca: STD_LOGIC_Vector(3 downto 0);
signal Zerotroca : STD_LOGIC;
signal Couttroca : STD_LOGIC;
signal Overflowtroca : STD_LOGIC; 
--Contador de bits ativos
signal SaidaCont : STD_LOGIC_Vector(3 downto 0);
signal ZeroCont : STD_LOGIC;
--Inverter bits
signal Saidainv : STD_LOGIC_Vector(3 downto 0);
signal Negativoinv : STD_LOGIC;
signal Zeroinv : STD_LOGIC;
--Par ou ímpar
signal Saidapxi : STD_LOGIC_Vector(3 downto 0);
signal Zeropxi : STD_LOGIC;
-- Comparador
signal Saidacomp : STD_LOGIC_Vector(3 downto 0);
--Coringa
signal NegativoCor : STD_LOGIC;
signal ZeroCor : STD_LOGIC;
signal CoutCor : STD_LOGIC;
signal OverflowCor : STD_LOGIC;
--Auxiliares
signal cin : STD_LOGIC;
signal bcomp2: STD_LOGIC_Vector(3 downto 0);
signal coutcomp2: STD_LOGIC;
signal overflowcomp2: STD_LOGIC;

BEGIN
cin <= '0';
NegativoCor <= '0';
ZeroCor <= '0';
CoutCor <= '0';
OverflowCor <= '0';

--Process
--Soma
FA1_somador_4bits: somador_4bits  PORT MAP(A,B,cin,Saidasoma,Coutsoma,Overflowsoma);
Zerosoma <= (not(Overflowsoma)) and not(Saidasoma(3)) and not(Saidasoma(2)) and not(Saidasoma(1)) and not(Saidasoma(0));

--Subtração
FA1_incremento: incremento PORT MAP(not(B),bcomp2,Coutcomp2,Overflowcomp2);
FA2_somador_4bits: somador_4bits  PORT MAP(A,bcomp2,cin,Saidasub,Coutsub,Overflowsub);
Negativosub <= Saidasub(3);
Zerosub <= (A(3) xnor B(3)) and (A(2) xnor B(2)) and (A(1) xnor B(1)) and (A(0) xnor B(0));

--Incremento
FA2_incremento: incremento PORT MAP(A,saidainc,Coutinc,Overflowinc);
Zeroinc <= (not(Overflowinc)) and not(Saidainc(3)) and not(Saidainc(2)) and not(Saidainc(1)) and not(Saidainc(0));

--Troca de sinal
FA3_incremento: incremento PORT MAP(not(A),Saidatroca,Couttroca,Overflowtroca);
Zerotroca <= (not(Overflowtroca)) and not(Saidatroca(3)) and not(Saidatroca(2)) and not(Saidatroca(1)) and not(Saidatroca(0));

--Contador de bits ativos
FA1_contadorbit1: contadorbit1 PORT MAP(A,SaidaCont,ZeroCont);

--Espelho de bits
FA_espelho: espelho PORT MAP(A,Saidainv);
Negativoinv <= Saidainv(3);
Zeroinv <= (Saidainv(3) nand Saidainv(2)) nand (Saidainv(1) nand Saidainv(0));
 
--Par ou ímpar
saidapxi(3 downto 1) <= "000";
Saidapxi(0) <= A(0);
Zeropxi <= (A(3) nand A(2)) nand (A(1) nand A(0));

-- Comparador
FA_comparador: comparador PORT MAP(A,B,Saidacomp);

process (Seletor,clkop)
	BEGIN
		case Seletor is
			--soma
			when "000" =>
			Saida <= Saidasoma;
			Negativo <= NegativoCor;
			Zero <= Zerosoma;
			Cout <= Coutsoma;
			Overflow <= Overflowsoma;
			-- subtração
			when "001" =>
			Saida <= Saidasub;
			Negativo <= NegativoSub;
			Zero <= Zerosub;
			Cout <= Coutsub;
			Overflow <= Overflowsub;
			-- incremento
			when "010" =>
			Saida <= Saidainc;
			Negativo <= NegativoCor;
			Zero <= Zeroinc;
			Cout <= Coutinc;
			Overflow <= Overflowinc;
			--troca de sinal
			when "011" => 
			Saida <= Saidatroca;
			Negativo <= Saidatroca(3);
			Zero <= Zerotroca;
			Cout <= Couttroca;
			Overflow <= Overflowtroca;
			--contador bits ativ.
			when "100" =>
			Saida <= SaidaCont;
			Negativo <= NegativoCor;
			Zero <= ZeroCont;
			Cout <= CoutCor;
			Overflow <= OverflowCor;
		       --inverter de bits
			when "101" =>
			Saida <=Saidainv;
			Negativo <= Negativoinv;
			Zero <= Zeroinv;
			Cout <= CoutCor;
			Overflow <= CoutCor;
			-- par/ímpar
			when "110" =>
			Saida <= Saidapxi;
			Negativo <= NegativoCor;
			Zero <= Zeropxi;
			Cout <= CoutCor;
			Overflow <= OverflowCor;
			-- comparador
			when "111" =>
			Saida <= Saidacomp;
			Negativo <= NegativoCor;
			Zero <= ZeroCor;
			Cout <= CoutCor;
			Overflow <= OverflowCor;
			--alta impedância
			when others =>
			Saida <= "ZZZZ";
			Negativo <= 'Z';
			Zero <= 'Z';
			Cout <= 'Z';
			Overflow <= 'Z';
	END case;
END process;
end arq_operacoes;





