`timescale 1ns / 1ps

module PicoBlaze_Teclado(
    input wire interrupt_crono,
    input wire bit_alarma,
    input wire reloj,
    input wire reset,
    input wire ps2c,
    input wire ps2d,
    

    output wire [7:0] dato_tec,
    output wire write_strobe,
    output wire read_strobe,
    output wire [11:0] address,
    output wire interrupt,
    output wire interrupt_ack,
    output wire [7:0] port_id,
    output wire [2:0] EnableOut,
    output wire [7:0] out_port,
    output wire interrupt_teclado,
    output wire [7:0] in_port
    );
    
    //wire    [7:0]        in_port;
    //wire	[11:0]	address;
    wire    [17:0]    instruction;
    wire            bram_enable;
    //wire    [7:0]        port_id;
    //wire    [7:0]        out_port;
    //wire            write_strobe;
    //wire            read_strobe;
    //wire            interrupt;            //See note above
    //wire            interrupt_ack;
    wire            kcpsm6_sleep;         //See note above
    wire            kcpsm6_reset;         //See note above
    //wire            int_request;
    //wire [7:0] dato_tec;
    //wire interrupt_teclado;
    //wire interrupt_crono = 1'b0;
    //wire [2:0] EnableOut;
    //wire bit_alarma = 1'b0;
    
    
    
    
 Interfaz_IO inst_IO(
        .reloj(reloj),
        .interrupt_ack(interrupt_ack),
        .port_id(port_id), //MSB 
        .dato_tec(dato_tec),//Viene de lo de Diego del Teclado
        .interrupt_alarma(bit_alarma),
        .interrupt_teclado(interrupt_teclado),//El bit de listo que viene desde el módulo del teclado
        .interrupt_crono(interrupt_crono),
        .write_strobe(write_strobe),
        //.read_strobe(read_strobe),
        .EnableOut(EnableOut),
        .in_port(in_port), //Lo que entra al picoblaze
        .interrupt(interrupt)
        );
        
    teclado inst_TECLADO(
    
    .CLK100MHZ(reloj),
    .PS2_CLK(ps2c),
    .PS2_DATA(ps2d),
    .reset(reset),
    
    .dato_listo(dato_tec),
    .tick(interrupt_teclado)
    
        );
        
      kcpsm6 #(
          .interrupt_vector    (12'h3FF),
          .scratch_pad_memory_size(64),
          .hwbuild        (8'h00))
        processor (
          .address         (address),
          .instruction     (instruction),
          .bram_enable     (bram_enable),
          .port_id         (port_id),
          .write_strobe     (write_strobe),
          .k_write_strobe     (),
          .out_port         (out_port),
          .read_strobe     (read_strobe),
          .in_port         (in_port),
          .interrupt         (interrupt),
          .interrupt_ack     (interrupt_ack),
          .reset         (kcpsm6_reset),
          .sleep        (kcpsm6_sleep),
          .clk             (reloj)); 
          
            
         ROM_inst inst_ROM (                    //Name to match your PSM file
           .address         (address),
           .instruction     (instruction),
           .enable         (bram_enable),
           .clk             (reloj));
           
           assign kcpsm6_sleep = 1'b0;
           assign kcpsm6_reset = 1'b0;

endmodule
