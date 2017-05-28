`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2017 22:59:11
// Design Name: 
// Module Name: tb_control_dmux
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


module tb_control_dmux(

    );
    
    
     wire [3:0] IN_bot_fecha; 
     wire [3:0] IN_bot_hora;
     wire [3:0] IN_bot_cr;
     wire [1:0] Control;
     wire A_A;
     wire F_H;  
     
     reg resetM;
     reg reloj;
     reg [7:0] port_id;
     reg [7:0] out_port;
     reg en_10;
    
    
    
 dmux_control_2 ins_dmux_control_2 (
 
 
  .IN_bot_fecha(IN_bot_fecha), 
  .IN_bot_hora(IN_bot_hora), 
  .IN_bot_cr(IN_bot_cr), 
  .Control(Control),
  .A_A(A_A),         
  .F_H(F_H),       
  
  .resetM(resetM), 
  .reloj(reloj), 
  .port_id(port_id), 
  .out_port(out_port), 
  .en_10(en_10)
 
 );
    
    
    
   initial 
   
   begin
   
   resetM <= 0;
   reloj <= 0;
   port_id <= 0;
   en_10 <= 0;
   out_port <= 0;
   
   
   
  #200 port_id <= 8'h01; 
   out_port <= 8'h01;
   
  #100 en_10 <= 1;
  #30 en_10 <= 0;
  
   #200 port_id <= 8'h20; 
    out_port <= 8'h23;
    
   #100 en_10 <= 1;
   #30 en_10 <= 0;
  
  
   end 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     always
             begin
                 #5 reloj <= ~reloj;
             end  
    
    
    
    
    
    
    
    
    
    
endmodule
