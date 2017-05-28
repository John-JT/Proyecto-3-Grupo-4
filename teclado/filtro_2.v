`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2017 17:59:46
// Design Name: 
// Module Name: filtro_2
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


module filtro_2(

    input wire reloj,
    input wire reset,
    input wire  [7:0] key_code,
    input wire got_code_tick,
    input wire bit_paridad,
    output wire [7:0] dato_listo,
    output wire paridad,
    output wire xor_dato,
    output tick
   

    );
    
    reg [7:0] dato_listo_reg1;
    reg [7:0] dato_listo_reg2;
    reg [7:0] dato_listo_reg;
    reg tick1;
    reg [1:0] cont_borrar;
    reg limpiar_d1;
    reg pare;
    reg [7:0] dato_listo_reg3;


    
    
    
    assign dato_listo = dato_listo_reg3;
    assign xor_dato =  dato_listo_reg1;
    assign paridad = xor_dato ~^ bit_paridad;
    assign tick = tick1;
    
    
    ////////agarrar dato got code tick
    
    always @(posedge reloj)
    
    begin
    tick1 <= got_code_tick;
    end
    
    
    always @(posedge reloj)
    begin
    
    if (reset)
        dato_listo_reg = 8'h00;
    else
        dato_listo_reg = dato_listo_reg1;
    end
    
    
    
    
    /////// control limpiar_1
    
    always @(posedge reloj)
        begin
     
        
        if (tick1)
        limpiar_d1 <= 1;
        
        else if(tick1 == 0 && pare == 1)
        limpiar_d1 <= 0;
        
        else 
        limpiar_d1 <= limpiar_d1;
        
        end 
    
    /////// control pare
    
    
always @(posedge reloj)
       begin
     
       
       if (limpiar_d1 && cont_borrar == 2'b11)
        begin
        cont_borrar <= 0;
        pare <= 1;
        end
       
       else if (limpiar_d1 && cont_borrar != 2'b11)
       begin
       cont_borrar <= cont_borrar + 1;
       pare <= 0;
       
       end
       
       else 
        cont_borrar <= cont_borrar;
       
       end 
    
 //////// dato final    
       always @(posedge reloj)
       begin
       
       if(limpiar_d1)
       
       dato_listo_reg3 <= dato_listo_reg2;
       
       
       else 
       dato_listo_reg3 <= 7'h00;
   
       end 
    
    
    
    
    always @*
    
    begin
    
    dato_listo_reg1 = dato_listo_reg;
    
    if (got_code_tick)
     begin
     
      case (key_code)
      
          8'h05  : begin
                   dato_listo_reg1 = 8'h05;
                   end
          8'h06  : begin
                      dato_listo_reg1 = 8'h06;
                   end
          8'h04  : begin
                      dato_listo_reg1 = 8'h04;
                   end
          8'h0c  : begin
                      dato_listo_reg1 = 8'h0c;
                   end
          8'h03  : begin
                      dato_listo_reg1 = 8'h03;
                   end
          8'h1d  : begin
                      dato_listo_reg1 = 8'h1d;
                    end
          8'h1c  : begin
                      dato_listo_reg1 = 8'h1c;
                    end
          8'h1b  : begin
                      dato_listo_reg1 = 8'h1b;
                   end                   
          8'h23  : begin
                      dato_listo_reg1 = 8'h23;
                   end                
                   
                   
          default: begin
                    dato_listo_reg1 = 8'h00;
                   end
       endcase
     end
    
    else 
        dato_listo_reg1 = dato_listo_reg1;
    end
    
    
    
    
    always @(*)
    begin
    
        if (paridad) 
            dato_listo_reg2 = dato_listo_reg1;
        else 
            dato_listo_reg2 = 8'h00;   
    end

endmodule
