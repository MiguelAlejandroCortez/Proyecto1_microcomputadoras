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
    Port ( Input_Vector: in  STD_LOGIC_VECTOR (n-1 downto 0);
			  S : in  STD_LOGIC_VECTOR (n-1 downto 0);
           R : out  STD_LOGIC_VECTOR (n-1 downto 0);
           Co : out  STD_LOGIC;
			  Asg : in  STD_LOGIC;
			  Rst : in  STD_LOGIC
			  );
			  
end Proyecto1_micro;

architecture Behavioral of Proyecto1_micro is      --Declaracin de 
signal C : STD_LOGIC_VECTOR (n downto 0); -- Los acarreos intermedios de la suma
signal A : STD_LOGIC_VECTOR (n-1 downto 0); -- Temporal de de Primer ingreso
signal B : STD_LOGIC_VECTOR (n-1 downto 0); -- Temporal de de Segundo ingreso
signal Bandera : STD_LOGIC; -- Bandera para identificar si se ocuparan A y B o solo se usara A


begin    --Empiezo del Behavioral
process(A,B,C,Ci,Bandera)  --ESTO ES PARA SUMA DE A + B 
begin
	Bandera <= '1'; --Asignamos a Bandera '1' porque se usaran A y B
	C(0)<=Ci; -- Asignacion de Acarreo de Entrada
	for i in 0 to n-1 loop
		S(i)<=(A(i) XOR B(i))XOR C(i);
		C(i+1)<=((A(i) AND B(i)) OR (A(i) AND C(i))) OR (B(i) AND C(i));
	end loop;
	Co<= C(n);
end process; --TERMINA LO DE SUMA DE A + B

process(A,B,Bandera)  --ESTO ES PARA A and B 
begin
	Bandera <= '1'; --Asignamos a Bandera '1' porque se usaran A y B
    if Bandera = '1' then
        for i in 0 to n-1 loop
            S(i) <= A(i) AND B(i);
        end loop;
    end if;
end process; --TERMINA LO DE A and B

process(A,B,Bandera)  --ESTO ES PARA A or B 
begin
	Bandera <= '1'; --Asignamos a Bandera '1' porque se usaran A y B
    if Bandera = '1' then
        for i in 0 to n-1 loop
            S(i) <= A(i) OR B(i);
        end loop;
    end if;
end process; --TERMINA LO DE A or B

process(A,B,Bandera)  --ESTO ES PARA A xor B 
begin
	Bandera <= '1'; --Asignamos a Bandera '1' porque se usaran A y B
    if Bandera = '1' then
        for i in 0 to n-1 loop
            S(i) <= A(i) XOR B(i);
        end loop;
    end if;
end process; --TERMINA LO DE A xor B

end Behavioral; --TERMINA BEHAVIOR TODO EL CODIGO PUES

