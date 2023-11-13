----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:32:59 11/12/2023 
-- Design Name: 
-- Module Name:    Proyecto1_micro - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Proyecto1_micro is
generic(
n: integer :=4 --Definicion de valor de N
);
    Port ( A,B: in  STD_LOGIC_VECTOR (n-1 downto 0);
			  S : in  STD_LOGIC_VECTOR (n-2 downto 0);
           Ci : in  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (n-1 downto 0);
           Co : out  STD_LOGIC);
end Proyecto1_micro;

architecture Behavioral of Proyecto1_micro is
signal C : STD_LOGIC_VECTOR (n downto 0); -- Los acarreos intermedios de la suma
begin
process(A,B,C,Ci)  --ESTO ES PARA SUMA DE A + B 
begin
C(0)<=Ci; -- Asignacion de Acarreo de Entrada
for i in 0 to n-1 loop
S(i)<=(A(i) XOR B(i))XOR C(i);
C(i+1)<=((A(i) AND B(i)) OR (A(i) AND C(i))) OR (B(i) AND C(i));
end loop;
Co<= C(n);
end process; --TERMINA LO DE SUMA DE A + B

end Behavioral;

