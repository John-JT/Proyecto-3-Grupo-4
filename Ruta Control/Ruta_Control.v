`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4
// Engineer: Dalberth
// Create Date: 05/28/2017 11:58:02 PM
// Module Name: Ruta_Control
//////////////////////////////////////////////////////////////////////////////////


module Ruta_Control(
    // Entradas general
    input reloj,
    input resetM,
    
    // Entradas ruta datos
    input wire [23:0] alarma,
    input wire [7:0] Inicie,
    input wire [7:0] Mod_S,
    input wire [7:0] OUT_diaf,
    input wire [7:0] OUT_mesf,
    input wire [7:0] OUT_anof,
    input wire [7:0] OUT_segh,
    input wire [7:0] OUT_minh,
    input wire [7:0] OUT_horah,
    
    // Entradas picoblaze
    input wire en_01,
    input wire [7:0] out_port,
    input wire [7:0] port_id,
    
    // Salidas picoblaze          
    output wire act_crono,
    
    // Salidas ruta datos
    output wire enable_cont_16,
    output wire [7:0] IN_diaf,
    output wire [7:0] IN_mesf,
    output wire [7:0] IN_anof,
    output wire [7:0] IN_segh,
    output wire [7:0] IN_minh,
    output wire [7:0] IN_horah,
    output wire [7:0] IN_segcr,
    output wire [7:0] IN_mincr,
    output wire [7:0] IN_horacr,
    output wire [3:0] Selec_Demux_DDw,      // Tambien es para modulo Graficos
    output wire READ,                       // Tambien es para modulo Graficos
    output wire enable_cont_I,     
    output wire enable_cont_MS,
    output wire enable_cont_fecha,
    output wire enable_cont_hora,
    
    // Salidas RTC
    output wire CS,
    output wire RD,
    output wire WR,
    output wire A_D,
    
    // IN-OUT
    inout wire [7:0] DIR_DATO
    );
    
    
    
    // Conexiones entre modulos
    wire [4:0] cont_32;      
    wire enable_cont_32;     
    wire [4:0] cont17;
    wire LE;                 
    wire sync; 
    wire [3:0] Selec_Mux_DDw;
    
    
    
    // Generador de senales de control para el RTC y otros modulos
    Gen_Senales inst_Gen_Senales(
            // Entradas general
            .reloj(reloj),
            .resetM(resetM),
            .alarma(alarma),
            
            // Entradas picoblaze
            .en_01(en_01),
            .out_port(out_port),
            .port_id(port_id),
            
            // Salidas general
           .act_crono(act_crono),
           .enable_cont_16(enable_cont_16),
           .CS(CS),
           .RD(RD),
           .WR(WR),
           .A_D(A_D),
        
            // Salidas inter-modular
            .cont_32(cont_32),                    
            .enable_cont_32(enable_cont_32), 
            .cont17(cont17),      
            .LE(LE),
            .sync(sync)
             ); 
    
    
    
    // Multiplexacion y demultiplexacion del bus DIR_DATO
    mux_DIR_DATO inst_mux_DIR_DATO(
             // Entradas General
             .reloj(reloj),
             .resetM(resetM),
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
          
             
             // Entradas inter-modular (de la ruta de control)
             .cont_32(cont_32),      
             .enable_cont_32(enable_cont_32),     
             .cont17(cont17),
             .LE(LE),                  
             .sync(sync),                
             
             // Salidas General
             .IN_diaf(IN_diaf),
             .IN_mesf(IN_mesf),
             .IN_anof(IN_anof),
             .IN_segh(IN_segh),
             .IN_minh(IN_minh),
             .IN_horah(IN_horah),
             .IN_segcr(IN_segcr),
             .IN_mincr(IN_mincr),
             .IN_horacr(IN_horacr),
             .Selec_Demux_DDw(Selec_Demux_DDw),      
             .READ(READ),
             
             // Salidas inter-modular (de la ruta de control)
             .Selec_Mux_DDw(Selec_Mux_DDw),
             
             // IN-OUT
             .DIR_DATO(DIR_DATO)
            );
    
    
    
    // Enables de la Ruta de Datos
    E_Bloques_Datos inst_E_Bloques_Datos(
           // Salidas General
           .enable_cont_I(enable_cont_I),     
           .enable_cont_MS(enable_cont_MS),
           .enable_cont_fecha(enable_cont_fecha),
           .enable_cont_hora(enable_cont_hora),
           
           // Entradas inter-modular (de la ruta de control)
           .Selec_Mux_DDw(Selec_Mux_DDw)
            );
             
                
    
endmodule