`timescale 1ns / 1ps
module Pico_RTC_VGA(
//Entradas
    input wire reloj,
    input wire resetM,
    input wire ps2c,
    input wire ps2d,
    inout wire [7:0] DIR_DATO,
    
//Salidas   
    output  CS,
    output  RD,
    output  WR,
    output  A_D,
    output  H_Syncreg,
    output  V_Syncreg,
    output  [3:0] R,
    output  [3:0] G,
    output  [3:0] B,
    output [2:0] EnableOut,
    output [7:0] dato_tec,
    output bit_alarma,
    output reg ampPWM,
    output interrupt_teclado
    //output [7:0] in_port
    );


wire bit_paridad,paridad,xor_dato,write_strobe,read_strobe,interrupt, interrupt_ack, /*interrupt_teclado,*/ interrupt_crono,
enable_cont_16,enable_cont_fecha,enable_cont_hora, enable_cont_I, enable_cont_MS;   

wire en_00, en_01, en_10, READ, F_H;    

wire [7:0] port_id, out_port,in_port,/*dato_tec,*/Inicie, Mod_s
,IN_diaf,IN_mesf,IN_anof,IN_segh,IN_minh,IN_horah,IN_segcr,IN_mincr,IN_horacr
,OUT_segh, OUT_minh, OUT_horah,OUT_diaf, OUT_mesf, OUT_anof ;  
 
  //wire [2:0] EnableOut;
wire [11:0] address;
wire [2:0] switch_w;  
wire [1:0] Contador_pos_f, Contador_pos_cr, Contador_pos_h;
wire [23:0] ALARMA;
wire [3:0] Selec_Demux_DD;

 PicoBlaze_Teclado inst_Pico_Teclado(
//Entradas
            .interrupt_crono(interrupt_crono),
            .bit_alarma(bit_alarma),
            .reloj(reloj),
            .reset(resetM),
            .ps2c(ps2c),
            .ps2d(ps2d),
//Salidas     
            
            .dato_tec(dato_tec),
            .write_strobe(write_strobe),
            .read_strobe(read_strobe),
            .address(address),
            .interrupt(interrupt),
            .interrupt_ack(interrupt_ack),
            .port_id(port_id),
            .EnableOut(EnableOut),
            .out_port(out_port),
            .interrupt_teclado(interrupt_teclado),
            .in_port(in_port)// Solo para corroborar
         
        );
 Graficos inst_InterfazGrafica(
//Entradas
            .F_H(F_H),
            .switch_w(switch_w),
            .port_id(port_id),
            .en_00(EnableOut[0]),
            .Contador_pos_f(Contador_pos_f),
            .Contador_pos_h(Contador_pos_h),
            .Contador_pos_cr(Contador_pos_cr),
            .bit_alarma(out_port[0]),//            .bit_alarma(bit_alarma),
            .ALARMA(ALARMA),
            .DIR_DATO(DIR_DATO),
            .POSICION(Selec_Demux_DD),
            .READ(READ),
            .reloj(reloj),
            .resetM(resetM),
//Salidas            
            .H_Syncreg(H_Syncreg),
            .V_Syncreg(V_Syncreg),
            .R(R),
            .G(G),
            .B(B)
            );
 top_datos inst_BloqueDatos(
 
//Entradas            
            .reloj(reloj),
            .resetM(resetM),
            .READ(READ),
            .Selec_Demux_DD(Selec_Demux_DD),
            .enable_cont_16(enable_cont_16),
            .enable_cont_fecha(enable_cont_fecha),
            .enable_cont_hora(enable_cont_hora),
            .enable_cont_I(enable_cont_I),
            .enable_cont_MS(enable_cont_MS),
            .port_id(port_id),
            .out_port(out_port),
            .en_10(EnableOut[2]),
            
            .IN_diaf(IN_diaf),
            .IN_mesf(IN_mesf),
            .IN_anof(IN_anof),
            .IN_segh(IN_segh),
            .IN_minh(IN_minh),
            .IN_horah(IN_horah),
            .IN_segcr(IN_segcr),
            .IN_mincr(IN_mincr),
            .IN_horacr(IN_horacr),
        
//Salidas          
            .alarma(ALARMA),
            .bit_alarma(bit_alarma),
            .Contador_pos_cr(Contador_pos_cr),
            .Contador_pos_f(Contador_pos_f),
            .Contador_pos_h(Contador_pos_h),
            .Inicie(Inicie),
            .Mod_s(Mod_s),
            
            
            .OUT_segh(OUT_segh),
            .OUT_minh(OUT_minh),
            .OUT_horah(OUT_horah),
           
            .OUT_diaf(OUT_diaf),
            .OUT_mesf(OUT_mesf),
            .OUT_anof(OUT_anof),
            .switch_w(switch_w),
            .F_H(F_H)
        
            );
            
 Ruta_Control inst_Ruta_Control(
            // Entradas general
            .reloj(reloj),
            .resetM(resetM),
            
                // Entradas ruta datos
            .alarma(ALARMA),
            .Inicie(Inicie),
            .Mod_S(Mod_s),
            .OUT_diaf(OUT_diaf),
            .OUT_mesf(OUT_mesf),
            .OUT_anof(OUT_anof),
            .OUT_segh(OUT_segh),
            .OUT_minh(OUT_minh),
            .OUT_horah(OUT_horah),
            
                // Entradas picoblaze
            .en_01(EnableOut[1]),
            .out_port(out_port),
            .port_id(port_id),
            
                // Salidas picoblaze          
            .act_crono(interrupt_crono),
            
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
            .Selec_Demux_DDw(Selec_Demux_DD),      // Tambien es para modulo Graficos
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
            

               parameter COUNTER_WIDTH = 19;
            
               reg [COUNTER_WIDTH-1:0] CONT = {COUNTER_WIDTH{1'b0}};
               always @(posedge reloj)
               begin
                  if (resetM)
                    CONT <= {COUNTER_WIDTH{1'b0}};
                  else
                     CONT <= CONT + 1'b1;
                     
                  if (CONT == 19'd250000)
                        ampPWM <= 1'b0;
                  else if (CONT == 19'd500000)
                      begin
                        ampPWM <= 1'b1;
                        CONT <= {COUNTER_WIDTH{1'b0}};
                      end
               end
                                     
 
            
            
endmodule
