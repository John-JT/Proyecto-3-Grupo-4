`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4
// Engineer: Dalberth
// Create Date: 05/25/2017 06:59:06 PM
// Module Name: Gen_Senales_tb
//////////////////////////////////////////////////////////////////////////////////



module Gen_Senales_tb(          // Correr 13500ns
    );
    // Entradas general
    reg reloj;
    reg resetM;
    reg [23:0] alarma;
    
    // Entradas picoblaze
    reg en_01;
    reg [7:0] out_port;
    reg [7:0] port_id;
    
    // Salidas general
    wire act_crono;
    wire enable_cont_16;
    wire CS;
    wire RD;
    wire WR;
    wire A_D;
    
    // Salidas inter-modular (de la ruta de control)
    wire [4:0] cont_32;      
    wire enable_cont_32;     
    wire LE;                  
    wire sync;                

    
        
    //---INSTANCIACION---    
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
                            .LE(LE),
                            .sync(sync)
                             );    
    
    
    
     //---VARIABLES---

       
          
     //---INICIALIZACIONES---        
     initial
     begin
     resetM <= 1'b1;
     reloj <= 1'b0;
     en_01 <= 1'b0;
     alarma <= 24'h000000;
      
     #100
     resetM <= 1'b0;
     
     #50
     en_01 <= 1'b1;
     port_id <= 8'h11;
     out_port <= 8'hF1;
     
     #10
     en_01 <= 1'b0;

     
     #50
     en_01 <= 1'b1;
     port_id <= 8'h10;
     out_port <= 8'h00;
     
     #10
     en_01 <= 1'b0;
     
     #3840
     en_01 <= 1'b1;    
     out_port <= 8'h01;
     
     #10
     en_01 <= 1'b0;    
     
     #1000
     en_01 <= 1'b1;
     out_port <= 8'h03;
     
     #10
     en_01 <= 1'b0;
     
     #60
     alarma <= 24'h000101;
     en_01 <= 1'b1;
     port_id <= 8'h01;
     out_port <= 8'h03;
     
     #10
     en_01 <= 1'b0;
     
     #60
     en_01 <= 1'b1;
     out_port <= 8'h02;
     
     #10
     en_01 <= 1'b0;
     
     #60
     en_01 <= 1'b1;
     out_port <= 8'h02;
     
     #10
     en_01 <= 1'b0;     
     
     #60
     alarma <= 24'h000000;
     
     #160
     en_01 <= 1'b1;    
     port_id <= 8'h10;
     out_port <= 8'h02;
     
     #10
     en_01 <= 1'b0;
     end
     
     
     
     //---CICLOS---
     always
     begin
     
     #5 reloj <= ~reloj;
     
     end



endmodule