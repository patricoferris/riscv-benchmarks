(* All the RISC-V instructions *)

type r_type = [`ADD | `SUB | `SLL | `SLT | `SLTU | `XOR | `SRL | `SRA | `OR | `AND]
type i_type = [`ADDI | `SLTI | `SLTIU | `XORI | `ORI | `ANDI]
type s_type = [`SW | `SH |`SD | `LB | `LW | `LD | `LBU | `LHU]
type b_type = [`BEQ | `BNE | `BLT | `BGE | `BLTU | `BGEU]
type u_type = [`LUI]
type j_type = [`JAL | `JALR]

type pure_instr = [r_type | i_type | s_type | b_type | u_type | j_type]

type pseudo = [`SEXT_W | `MISC of string | `COMP of pure_instr]
type insruction = [r_type | i_type | s_type | b_type | u_type | j_type | pseudo]

type reg = string 
type offset = int
type imm = int 

type r_type_instr = r_type * reg * reg * reg
type i_type_instr = i_type * reg * reg * imm
type s_type_instr = s_type * reg * offset * reg
type b_type_instr = b_type * reg

let rec instr_to_string = function
  | `ADD  -> "add"
  | `LB   -> "lb"
  | `ADDI -> "addi"
  | `BEQ  -> "beq"
  | `LW   -> "lw"
  | `BLTU -> "bltu"
  | `JALR -> "jalr"
  | `BGE  -> "bge"
  | `ORI  -> "ori"
  | `SLTU -> "sltu"
  | `XOR  -> "xor"
  | `LHU  -> "lhu"
  | `SLL  -> "sll"
  | `SUB  -> "sub"
  | `BNE  -> "bne"
  | `SD   -> "sd"
  | `BGEU -> "bgeu"
  | `SLTIU -> "sltiu"
  | `SH   -> "sh"
  | `ANDI -> "andi"
  | `XORI -> "xori"
  | `SRL  -> "srl"
  | `SRA  -> "sra"
  | `SLTI -> "slti"
  | `LD   -> "ld"
  | `LBU  -> "lbu"
  | `JAL  -> "jal"
  | `LUI  -> "lui"
  | `OR   -> "or"
  | `AND  -> "and"
  | `SEXT_W -> "sext.w"
  | `BLT  -> "blt"
  | `SW   -> "sw"
  | `SLT  -> "slt"
  | `COMP instr -> "c." ^ (instr_to_string instr)
  | `MISC s -> s 

let rec string_to_instr = function
  | "add"  -> `ADD  
  | "lb"   -> `LB     
  | "addi" -> `ADDI 
  | "beq"  -> `BEQ  
  | "lw"   -> `LW
  | "bltu" -> `BLTU
  | "jalr" -> `JALR
  | "bge"  -> `BGE  
  | "ori"  -> `ORI  
  | "sltu" -> `SLTU
  | "xor"  -> `XOR  
  | "lhu"  -> `LHU  
  | "sll"  -> `SLL  
  | "sub"  -> `SUB  
  | "bne"  -> `BNE  
  | "sd"   -> `SD     
  | "bgeu" -> `BGEU
  | "sltiu" ->`SLTIU
  | "sh"   -> `SH     
  | "andi" -> `ANDI
  | "xori" -> `XORI
  | "srl"  -> `SRL  
  | "sra"  -> `SRA  
  | "slti" -> `SLTI
  | "ld"   -> `LD     
  | "lbu"  -> `LBU  
  | "jal"  -> `JAL  
  | "lui"  -> `LUI  
  | "or"   -> `OR     
  | "and"  -> `AND  
  | "sext.w" -> `SEXT_W
  | "blt"  -> `BLT  
  | "sw"   -> `SW    
  | "slt"  -> `SLT
  | s      ->  
    let arr = Array.of_list (String.split_on_char '.' s) in 
      if Array.length arr = 2 then `COMP (string_to_instr arr.(1))
      else `MISC s

(* Parsing a line of the log *)

let line_parse line = 
  let arr = Array.of_list (String.split_on_char ' ' line) in 
  if Array.length arr >= 7 then 
    (string_to_instr arr.(6))
  else 
    `MISC "" 
    