library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY Gray_to_Binary IS
     port(
         gray_in : in STD_LOGIC_VECTOR(2 downto 0);
         bin_out : out STD_LOGIC_VECTOR(2 downto 0)
         );
END ENTITY  Gray_to_Binary;

ARCHITECTURE GrayToBinaryArchi of Gray_to_Binary is
BEGIN
P3: process(gray_in) IS
BEGIN
    bin_out(2) <= gray_in(2);
    bin_out(1) <= gray_in(2) xor gray_in(1);
    bin_out(0) <= gray_in(2) xor gray_in(1) xor gray_in(0);
END process P3;
END ARCHITECTURE GrayToBinaryArchi;
