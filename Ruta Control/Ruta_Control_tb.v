`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4
// Engineer: Dalberth
// Create Date: 05/30/2017 11:28:01 PM
// Module Name: Ruta_Control_tb
//////////////////////////////////////////////////////////////////////////////////



module Ruta_Control_tb(             // Correr 3000ns
    );
    // Entradas general
    reg reloj;
    reg resetM;
    
    // Entradas ruta datos
    reg [23:0] alarma;
    reg [7:0] Inicie;
    reg [7:0] Mod_S;
    reg [7:0] OUT_diaf;
    reg [7:0] OUT_mesf;
    reg [7:0] OUT_anof;
    reg [7:0] OUT_segh;
    reg [7:0] OUT_minh;
    reg [7:0] OUT_horah;
    
    // Entradas picoblaze
    reg en_01;
    reg [7:0] out_port;
    reg [7:0] port_id;
    
    // Salidas picoblaze          
    wire act_crono;
    
    // Salidas ruta datos
    wire enable_cont_16;
    wire [7:0] IN_diaf;
    wire [7:0] IN_mesf;
    wire [7:0] IN_anof;
    wire [7:0] IN_segh;
    wire [7:0] IN_minh;
    wire [7:0] IN_horah;
    wire [7:0] IN_segcr;
    wire [7:0] IN_mincr;
    wire [7:0] IN_horacr;
    wire [3:0] Selec_Demux_DDw;      // Tambien es para modulo Graficos
    wire READ;                       // Tambien es para modulo Graficos
    wire enable_cont_I;     
    wire enable_cont_MS;
    wire enable_cont_fecha;
    wire enable_cont_hora;
    
    // Salidas RTC
    wire CS;
    wire RD;
    wire WR;
    wire A_D;
    
    // IN-OUT
    wire [7:0] DIR_DATO;  
    
    
    
    //---INSTANCIACION---        
    Ruta_Control inst_Ruta_Control(    
                // Entradas general
                .reloj(reloj),
                .resetM(resetM),
                
                // Entradas ruta datos
                .alarma(alarma),
                .Inicie(Inicie),
                .Mod_S(Mod_S),
                .OUT_diaf(OUT_diaf),
                .OUT_mesf(OUT_mesf),
                .OUT_anof(OUT_anof),
                .OUT_segh(OUT_segh),
                .OUT_minh(OUT_minh),
                .OUT_horah(OUT_horah),
                
                // Entradas picoblaze
                .en_01(en_01),
                .out_port(out_port),
                .port_id(port_id),
                
                // Salidas picoblaze          
                .act_crono(act_crono),
                
                // Salidas ruta datos
                .enable_cont_16(enable_cont_16),
                .IN_diaf(IN_diaf),
                .IN_mesf(IN_mesf),
                .IN_anof(IN_anof),
                .IN_segh(IN_segh),
                .IN_minh(IN_minh),
                .IN_horah(IN_horah),
                .IN_segcr(IN_segcr),
                .IN_mincr(IN_mincr),
                .IN_horacr(IN_horacr),
                .Selec_Demux_DDw(Selec_Demux_DDw),      // Tambien es para modulo Graficos
                .READ(READ),                       // Tambien es para modulo Graficos
                .enable_cont_I(enable_cont_I),     
                .enable_cont_MS(enable_cont_MS),
                .enable_cont_fecha(enable_cont_fecha),
                .enable_cont_hora(enable_cont_hora),
                
                // Salidas RTC
                .CS(CS),
                .RD(RD),
                .WR(WR),
                .A_D(A_D),
                
                // IN-OUT
                .DIR_DATO(DIR_DATO)
                             );    
    
    
    
     //---VARIABLES---

       
          
     //---INICIALIZACIONES---        
     initial
     begin
     resetM <= 1'b1;
     reloj <= 1'b0;

     alarma <= 24'h000000;
     
     Inicie <= 8'h01;
     Mod_S<= 8'h02;
     OUT_diaf<= 8'h03;
     OUT_mesf<= 8'h04;
     OUT_anof<= 8'h05;
     OUT_segh<= 8'h06;
     OUT_minh<= 8'h07;
     OUT_horah<= 8'h08;
     
     en_01 <= 1'b0;
     port_id <= 8'h69;
     out_port <= 8'h69;
      
     #100
     resetM <= 1'b0;
     
     #20
     en_01 <= 1'b1;
     port_id <= 8'h01;
     out_port <= 8'h02;
     
     #10
     en_01 <= 1'b0;
     
     #50
     port_id <= 8'h10; 
     en_01 <= 1'b1;
     
     #10
     en_01 <= 1'b0;
     end
     
     
     
     //---CICLOS---
     always
     begin
     
     #5 reloj <= ~reloj;
     
     end



endmodule
