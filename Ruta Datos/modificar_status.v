`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2017 12:35:50
// Design Name: 
// Module Name: modificar_status
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


module modificar_status(
    
    output [7:0] Mod_s,

    
    input reloj,
    input resetM,
    input [1:0] Control,
    input A_A,
    input F_H,
    input act_crono,
    input enable_cont_16,
    input enable_cont_MS

    );
    
    reg contador_1 = 0;
    reg [2:0] in_mod_status = 0;
    reg [7:0] mod_s;

    // registros de desplazamiento
    //
    
    assign Mod_s = mod_s;

        
    
    always @(posedge reloj)
      begin
      
      if (resetM)
        in_mod_status <=0;
        
      else 
        in_mod_status <= {A_A,F_H,act_crono};
      end 
    

    
   always @ (posedge reloj)
    
    begin
    if (resetM)
        contador_1 <= 0;
    
    else if (Control != 3)
        contador_1 <= 0;
    
    else if (contador_1 == 1 && enable_cont_16 && enable_cont_MS)
       contador_1 <= 0;
    
    else if (enable_cont_16 && enable_cont_MS)
        contador_1 <= contador_1 + 1;
    
    else
        contador_1 <= contador_1;
        
    end   
        
    ////// MODIFICAR REGISTROS STATUS    
    
    always @ (posedge reloj)
    
        begin
        
        if (resetM)
        begin
            mod_s <= 8'b00000000; 
  
        end
        
        else if (contador_1 == 1)
            begin
            
            case (in_mod_status)
                  3'b000 : begin
                            mod_s <= 8'b00000000;
                          
                           end
                  3'b001 : begin
                             mod_s <= 8'b00001000;
                             
                           end
                  3'b010 : begin
                             mod_s <= 8'b00010000;
                       
                           end
                  3'b011 : begin
                             mod_s <= 8'b00011000;
                        
                           end
                  3'b100 : begin
                             mod_s <= 8'b00000000;
                             
                           end
                  3'b101 : begin
                             mod_s <= 8'b00000000;
                          
                           end
                  3'b110 : begin
                             mod_s <= 8'b00010000;
               
                           end
                  3'b111 : begin
                             mod_s <= 8'b00010000;
                          
                           end
                  default: begin
                             mod_s <= 8'b00000000;
                      
                           end
               endcase
            
            
            end
        
         else 
         begin
              mod_s <= 8'b00000000;  
          
         end
        
    end 
    
   
    
endmodule