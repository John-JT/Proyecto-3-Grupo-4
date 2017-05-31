`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4
// Engineer: Dalberth
// Create Date: 05/28/2017 01:03:35 PM 
// Module Name: mux_DIR_DATO_tb 
//////////////////////////////////////////////////////////////////////////////////



module mux_DIR_DATO_tb(             // correr 12500ns
    );
    // Entradas General
    reg reloj;
    reg resetM;
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

    
    // Entradas inter-modular (de la ruta de control)
    reg [4:0] cont_32;       
    reg enable_cont_32;      
    reg [4:0] cont17;
    reg LE;                  
    reg sync;                
    
    // Salidas General
    wire [7:0] IN_diaf;
    wire [7:0] IN_mesf;
    wire [7:0] IN_anof;
    wire [7:0] IN_segh;
    wire [7:0] IN_minh;
    wire [7:0] IN_horah;
    wire [7:0] IN_segcr;
    wire [7:0] IN_mincr;
    wire [7:0] IN_horacr;
    wire [3:0] Selec_Demux_DDw;      
    wire READ;
    
    // Salidas inter-modular (de la ruta de control)
    wire [3:0] Selec_Mux_DDw;
    
    // IN-OUT
    wire [7:0] DIR_DATO;
   
   
   
   //---INSTANCIACION--- 
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
   
   
                                       
   //---VARIABLES--- 
   reg [7:0] DIR_DATO_IN;
   assign DIR_DATO = DIR_DATO_IN;
   
   
   
   //---INICIALIZACIONES---
   initial
   begin
   reloj <= 1'b0;
   resetM <= 1'b1;
   
   Inicie <= 8'd01;
   Mod_S <= 8'd02;
   OUT_diaf <= 8'd03;
   OUT_mesf <= 8'd04;
   OUT_anof <= 8'd05;
   OUT_segh <= 8'd06;
   OUT_minh <= 8'd07;
   OUT_horah <= 8'd08;
   
   en_01 <= 1'b0;
   out_port <= 8'h69; 
   port_id <= 8'h69;

   LE <= 1'b0;
   sync <= 1'b0;
   
   DIR_DATO_IN <= 8'bzzzzzzzz;
   
   
   #100
   resetM <= 1'b0;
   
   #50
   en_01 <= 1'b1;
   out_port <= 8'h00; 
   port_id <= 8'h10;
   sync <= 1'b1;
   
   #10
   en_01 <= 1'b0;
   
   #10
   sync <= 1'b0;
   
   #500
   en_01 <= 1'b1;
   out_port <= 8'h03;
   LE <= 1'b0;
   sync <= 1'b1;
   
   #10
   en_01 <= 1'b0;
   
   #10
   sync <= 1'b0;
   
   #420 
   en_01 <= 1'b1;
   out_port <= 8'h01;
   LE <= 1'b1;
   sync <= 1'b1;
   
   #10
   en_01 <= 1'b0;
   
   #10
   sync <= 1'b0;
   
   #560
   DIR_DATO_IN <= 8'h21;
   
   #50
   DIR_DATO_IN <= 8'bzzzzzzzz;
   
   #4200
   en_01 <= 1'b1;
   out_port <= 8'h02;
   LE <= 1'b0;
   sync <= 1'b1;
     
   #10
   en_01 <= 1'b0;  
      
   #10
   sync <= 1'b0;
   
   #2240
   LE <= 1'b1;
   
   #3200
   LE <= 1'b0;  
   end
  
   
   
   //---CICLOS--- 
   always
       begin
       #5  reloj<= ~reloj; 
       end    
        
   always @(posedge reloj)
       begin
           if (sync || resetM)
               cont_32 <= 5'b00000;
           else
               cont_32 <= cont_32 + 5'b00001;
           if (cont_32 == 5'b11111)
               enable_cont_32 <= 1'b1;
           else
               enable_cont_32 <= 1'b0;
       end  
 
     always @(posedge reloj)     
       begin                       
       if (resetM || sync)
            cont17 <= 5'b00000;
       else 
       if (out_port == 8'h02)                 // cuenta los 17 datos que se envian y leen en escritura
           begin    
           if (enable_cont_32 == 1'b1)
               if ( cont17 == 5'b10000)
                    cont17 <= 5'b00000;
               else
                    cont17 <=  cont17 + 5'b00001;
           else
                cont17 <=  cont17;   
           end         
       else
            cont17 <= 5'b00000;
       end
      
       
       
                               
endmodule