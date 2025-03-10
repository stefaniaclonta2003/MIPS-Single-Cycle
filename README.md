# MIPS Single Cycle

# Descriere

Acest proiect implementează un procesor MIPS cu ciclu unic, incluzând principalele unități funcționale necesare pentru execuția instrucțiunilor. Proiectul a fost testat pe plăcuțele Nexys și Basys.

# Arhitectură

Proiectul include următoarele unități funcționale:

# Unitatea de extragere a instrucțiunilor (IFetch)

# Unitatea de control (UC)

# Unitatea de decodificare a instrucțiunilor (ID)

# Unitatea de execuție a instrucțiunilor (EX)

# Unitatea de memorie (MEM)

# Generatorul monopuls sincron (MPG)

# Afișorul pe 7 segmente (SSD)

# Instrucțiuni Implementate

Instrucțiuni de tip Register

Shift Right Arithmetic (SRA)

Descriere: Deplasează aritmetic spre dreapta un registru și stochează rezultatul într-altul.

Sintaxă: sra $d, $t, h

Format RTL: $d <= $t >> h

Cod Mașină: 000000 00000 ttttt ddddd hhhhh 000011

Bitwise eXclusive-OR (XOR)

Descriere: Realizează operația de sau-exclusiv între două registre și memorează rezultatul.

Sintaxă: xor $d, $s, $t

Format RTL: $d <= $s ^ $t

Cod Mașină: 000000 sssss ttttt ddddd 00000 100110

Instrucțiuni de tip Immediate

BGEZ – Branch on Greater than or Equal to Zero

Descriere: Execută un salt condiționat dacă registrul specificat este ≥ 0.

Sintaxă: bgez $s, offset

Format RTL: if $s ≥ 0 then PC <= (PC + 4) + (SE(offset) << 2) else PC <= PC + 4;

Cod Mașină: 000001 sssss 00000 oooooooooooooooo

ORI – bitwise OR Immediate

Descriere: Realizează operația logică SAU între un registru și o valoare imediată.

Sintaxă: ori $t, $s, imm

Format RTL: $t <= $s | ZE(imm)

Cod Mașină: 001101 sssss ttttt iiiiiiiiiiiiiiii
