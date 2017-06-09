`timescale 1ns / 1ps

module Graficos(
    input F_H,
    input [2:0] switch_w,
    input [7:0] port_id,
    input en_00,
    input [1:0] Contador_pos_f,
    input [1:0] Contador_pos_h,
    input [1:0] Contador_pos_cr,
    input bit_alarma,
    input [23:0] ALARMA,
    inout [7:0] DIR_DATO,
    input [3:0] POSICION,
    input READ,
    input reloj,
    input resetM,
    
    output  H_Syncreg,
    output  V_Syncreg,
    output  [3:0] R,
    output  [3:0] G,
    output  [3:0] B
    );
    wire [8:0] cam_co;
    wire [9:0] Qh;
    wire [9:0] Qv;
    wire BIT_FUENTE;
    wire BIT_FUENTE1;
    wire BIT_FUENTE2;
    wire BIT_FUENTE3;
    wire BIT_FUENTE4;
    wire BIT_FUENTE5;
    wire H_ON, V_ON;
    wire Cam_Co;
    reg enable_alarma;
    wire ENABLE_ALARMA;
    wire AM_PM;
    reg Bit_alarma = 1'b0;
    
    
   always@(posedge reloj)
    begin
         if (port_id == 8'h00 && en_00)
             Bit_alarma <= bit_alarma;   
         else
             Bit_alarma <= Bit_alarma;
    end
    
    counter inst_counter(
   .Qh(Qh),
   .Qv(Qv),
   .H_Syncreg(H_Syncreg),
   .V_Syncreg(V_Syncreg),
   .V_ON(V_ON),
   .H_ON(H_ON),
   .resetM(resetM),
   .reloj(reloj)
    );
        
    font_rom8x8 inst_font_rom8x8(
    .bit_alarma(Bit_alarma),
    .Qh(Qh),
    .Qv(Qv),
    .resetM(resetM),
    .reloj(reloj),
    .BIT_FUENTE(BIT_FUENTE1)
     );
     
    font_rom8x16 inst_font_rom8x16(
     .bit_alarma(Bit_alarma),
     .Qh(Qh),
     .Qv(Qv),
     .resetM(resetM),
     .reloj(reloj),
     .BIT_FUENTE2(BIT_FUENTE2)
      );
      
    Numeros inst_Numeros(
          .switch_w(switch_w),
          .bit_alarma(Bit_alarma),
          .Contador_pos_f(Contador_pos_f), 
          .Contador_pos_h(Contador_pos_h), 
          .Contador_pos_cr(Contador_pos_cr),
          .ALARMA(ALARMA),
          .resetM(resetM),
          .DIR_DATO(DIR_DATO),
          .POSICION(POSICION),
          .READ(READ),
          .Qv(Qv),
          .Qh(Qh),
          .reloj(reloj),
          .BIT_FUENTE3(BIT_FUENTE3),
          .cam_co(cam_co),
          .AM_PM(AM_PM)
          );
      
    assign BIT_FUENTE = BIT_FUENTE1 | BIT_FUENTE2 | BIT_FUENTE3 | BIT_FUENTE4 | BIT_FUENTE5;
    
     RGB inst_RGB(
        .switch_w(switch_w),
        .bit_alarma(Bit_alarma),
        .reloj(reloj),
        .cam_co(cam_co),
        .H_ON(H_ON),
        .V_ON(V_ON),
        .Qh(Qh),
        .Qv(Qv),
        .resetM(resetM),
        .BIT_FUENTE(BIT_FUENTE),
        .R(R),
        .G(G),
        .B(B)
        );
        
 Impresion_Imagenes inst_Impresion_Imagenes(
        .AM_PM(AM_PM),
        .F_H(F_H),
        .bit_alarma(Bit_alarma),
        .Qh(Qh),
        .Qv(Qv),
        .reloj(reloj),
        .resetM(resetM),
        .BIT_FUENTE4(BIT_FUENTE4)
            );
            
 ALARMA_IMAGEN inst_ALARMA_IMAGEN(
        .bit_alarma(Bit_alarma),
        .Qh(Qh),
        .Qv(Qv),
        .reloj(reloj),
        .resetM(resetM),
        .BIT_FUENTE5(BIT_FUENTE5)
                );
    
endmodule
