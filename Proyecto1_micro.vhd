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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Proyecto1_micro is
    generic (
        n: integer := 4 -- Definicion de valor de N
    );
    Port (
        Input_Vector : in STD_LOGIC_VECTOR(n-1 downto 0);
        Selector : in STD_LOGIC_VECTOR(3 downto 0); -- Este no es n-1 por que del selector si sabemos cuantos bits ocupamos
        Respuesta : out STD_LOGIC_VECTOR(n-1 downto 0);
        Asignacion : in STD_LOGIC;
        Reset : in STD_LOGIC;
        clk : in STD_LOGIC;
		  V : out STD_LOGIC;
		  S : out STD_LOGIC;
		  C : out STD_LOGIC;
		  Z : out STD_LOGIC
    );
end Proyecto1_micro;

architecture Behavioral of Proyecto1_micro is
    -- Esto nos servira para controlar el desborde de cualquier operación
    signal A : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0'); -- Inicializado con el mismo tamaño del Input
    signal B : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0'); -- Inicializado con el mismo tamaño del Input
    -- ReadyB: Esto lo usamos como una bandera para verificar si ya se asignó el número B
    -- Ya se pueden realizar las operaciones, si no devolverá alguna señal para indicar que todavía no ha pasado.
    -- Se inicializa en 0 indicando falso
    signal ReadyA : STD_LOGIC := '0';-- variable para bloqueo de llenado
	 signal ReadyB : STD_LOGIC := '0';-- variable para bloqueo de llenado
	 signal Vtemp : STD_LOGIC := '0';
	 -----------------------------------------------------------------------------

begin -- Empiezo del Behavioral

    -- Declaración del proceso de asignación de los temporales
    process(clk, Reset, Asignacion)
		begin
			 if Reset = '1' then
				  -- Cuando el botón de reinicio se reinician A y B
				  A <= (others => '0');
				  B <= (others => '0');
				  ReadyA <= '0'; -- A se asigna, ReadyA se pone a falso			 
				  ReadyB <= '0'; -- ReadyB se pone en falso
			 elsif rising_edge(clk) then
				  if Asignacion = '1' and ReadyB = '1' then
						if ReadyA = '0' then
							A <= Input_Vector;
							ReadyA <= '1'; -- A se asigna, ReadyA se pone a verdadero
						else
							B <= Input_Vector;
							ReadyB <= '1'; -- ReadyB se pone a verdadero
						end if;
					end if;
			 end if;
	end process;

    -- Lógica para realizar operaciones según el Selector
    process(A, B, Selector, Vtemp)
		variable Temp : STD_LOGIC_VECTOR(n-1 downto 0); 
		--Se declara un temporal para darle el valor de complemento a 1 de B
		variable B_Temp : STD_LOGIC_VECTOR(n-1 downto 0);
		--variable temporal donde se guardara el complemento a 2 de B
		variable SumaTemp : STD_LOGIC_VECTOR(n downto 0);  -- Se añade un bit extra para manejar el desbordamiento
    begin
        case Selector is
            when "0000" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A; -- Para ver qué hay en A
					V <=Vtemp;
            when "0001" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A + "0001"; -- A con un incremento de 1	
					 V <=Vtemp;
				when "0010" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
					 SumaTemp := (others => '0');
					 SumaTemp(A'high downto A'low) := A;
					 SumaTemp := SumaTemp + B;
					if SumaTemp(SumaTemp'high) = '1' then
						-- Manejar desbordamiento aquí (puedes tomar la acción que desees)
						-- En este ejemplo, simplemente se devuelve el resultado en 0
						Vtemp<='1';
						Respuesta<=(others => '0');
					else
						Respuesta<= SumaTemp(n-1 downto 0);
					end if;
					V <=Vtemp;
            when "0011" =>
                Respuesta <= A + B + "0001";  -- Suma con incremento de uno		
            when "0100" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
					for i in 0 to n-1 loop --recuerden que lo hacemos para n numeros
						Temp(i) := not B(i);
						--Aqui solo se invierten los numeros para sacar el compl a 1 de B
					end loop;								
					 B_Temp := Temp + "0001";
					--Aqui se suma 0001 para obtener el complemento a 2 de B
					--Se guarda en una variable temporal para no afectar B	
					 SumaTemp := (others => '0');
					 SumaTemp(A'high downto A'low) := A;
					 SumaTemp := SumaTemp + B_Temp;
					if SumaTemp(SumaTemp'high) = '1' then
						-- Manejar desbordamiento aquí (puedes tomar la acción que desees)
						-- En este ejemplo, simplemente se devuelve el resultado en 0
						Vtemp<='1';
						Respuesta<=(others => '0');
					else
						Respuesta<= SumaTemp(n-1 downto 0);
					end if;
					V <=Vtemp;
            when "0111" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= B; -- Para ver qué hay en B  
					V <=Vtemp;
            when "0101" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A + B + "0001"; 
					V <=Vtemp;
            when "1000" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A and B;  -- AND lógico
					V <=Vtemp;
            when "1001" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A or B;  -- OR lógico
					V <=Vtemp;
            when "1010" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A xor B;  -- XOR lógico
					 V <=Vtemp;
            when "0110" =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= A - "0001";  -- Resta
					V <=Vtemp;
            when others =>
					Vtemp<='0'; -- hago esto para que la bander se reinicie da vez que se hace otra operacion.
                Respuesta <= (others => '0');  -- Operación por defecto (cero)
					V <=Vtemp;
        end case;
    end process;

    -- Otras partes de tu código (aquí debes agregar tu lógica específica)

end Behavioral; -- TERMINA BEHAVIOR TODO EL CÓDIGO

