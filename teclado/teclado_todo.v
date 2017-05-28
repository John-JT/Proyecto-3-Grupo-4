`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2017 23:15:51
// Design Name: 
// Module Name: teclado_todo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module teclado_todo(
    
    input wire reloj,
    input wire reset,
    input wire ps2c,
    input wire ps2d,
    output wire [7:0] dato_listo,
    output wire bit_paridad,
    output wire paridad,
    output wire xor_dato,
    output tick

    );
    
    
    
    wire [7:0] dout;
    wire rx_done_tick;
    wire [7:0] key_code;
    wire got_code_tick;
    wire bit_pari_tecla;

    
 
 PS2_Ctrl ins_PS2_Ctrl (
 
     .reloj(reloj), 
     .reset(reset),
     .ps2d(ps2d), 
     .ps2c(ps2c), 
     .rx_done_tick(rx_done_tick),
     .dout(dout),
     .bit_pari_tecla(bit_pari_tecla)
 );   
    
    
 kb_code ins_kb_code (
 
 
     .reloj(reloj), 
     .reset(reset), 
     .rx_done_tick(rx_done_tick), 
     .dout(dout), 
     .bit_pari_tecla(bit_pari_tecla),
     .got_code_tick(got_code_tick), 
     .key_code(key_code),
     .bit_paridad(bit_paridad)
 
 );  
    
    
 filtro_2 ins_filtro_2 (
 
    .reloj(reloj),
    .reset(reset),
    .key_code(key_code),
    .got_code_tick(got_code_tick),
    .bit_paridad(bit_paridad),
    .dato_listo(dato_listo),
    .paridad(paridad),
    .xor_dato(xor_dato),
    .tick(tick)

 ); 
    
    
    
    
    
    
    
    
    
    
endmodule
