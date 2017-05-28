`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2017 20:10:32
// Design Name: 
// Module Name: dmux_control_2
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


module dmux_control_2(

    output [3:0] IN_bot_fecha, 
    output [3:0] IN_bot_hora,
    output [3:0] IN_bot_cr,
    output [1:0] Control,
    output A_A,
    output F_H,
    output act_crono,
    
    input resetM,
    input reloj,
    input [7:0] port_id,
    input [7:0] out_port,
    input en_10

    );
    
    reg [2:0] switch = 3'b00;
    reg [3:0] botones = 4'b0000;
    reg [3:0] in_bot_fecha = 4'h0;
    reg [3:0] in_bot_hora = 4'h0;
    reg [3:0] in_bot_cr = 4'h0;
    reg [1:0] Control_reg;
    reg A_A_reg;
    reg F_H_reg;
    reg act_crono_reg;
    
    wire [2:0] switch_w;
    
    
    assign switch_w = switch;
  
    assign IN_bot_fecha = in_bot_fecha;
    assign IN_bot_hora = in_bot_hora;
    assign IN_bot_cr = in_bot_cr;
    assign Control = Control_reg;
    assign A_A = A_A_reg;
    assign F_H = F_H_reg;
    


///agarrar dato de switchs    
    
    always @(posedge reloj)  
    begin
    
    if(resetM)
    switch <= 3'b000;
    
    else if (en_10 && port_id == 8'h01)
        begin
        
        case (out_port[1:0])
        
              2'b01  : begin
                          if(switch_w[2])
                          
                          begin                         
                          switch <= 3'b000;
                          end
                          
                          else 
                          switch[2] <= 1;
                          switch[1] <= 0;
                          switch[0] <= 0;                          
                          begin
                          
                          end
                                          
                       end
              2'b10  : begin
                        if(switch_w[1])
              
                        begin                         
                        switch <= 3'b000;
                        end
              
                        else 
                        begin
                        switch[2] <= 0;
                        switch[1] <= 1;
                        switch[0] <= 0;                          
                        end
                        
                       end
              
              2'b11: begin
                        if(switch_w[0])
    
                        begin                         
                        switch <= 3'b000;
                        end
    
                        else 
                        begin
                        switch[2] <= 0;
                        switch[1] <= 0;
                        switch[0] <= 1;                          
                        end
                        
                       end
                       
               default:
                        begin                         
                        switch <= 3'b000;
                        end               
               
               
               
        
        endcase 
        
        end
    
    else 
        begin
         switch <= switch;     
        
        end
    
    end
    
    
 ///////// agarrar dato de botones   

always @(posedge reloj)
begin

if (resetM)
    botones <= 4'h0;
    
else if(en_10 && port_id == 8'h22)
    begin
    
    case(out_port)
    
    8'h01:
    begin 
    botones <= 4'b1000;
    end
    
    8'h02:
    begin 
    botones <= 4'b0100;
    end    
    
    8'h03:
    begin 
    botones <= 4'b0010;
    end
    
    8'h04:
    begin 
    botones <= 4'b0001;
    end
    
    
    default:
    begin 
    botones <= 4'b0000;
    end            
    
    
    endcase
    
    end

else 
    botones <= botones;

end


 //////// dmux de botones hacia modulos  
    
    always @(*)
       begin
           case (switch)  
               3'b100 : begin
                           in_bot_fecha <= botones;
                           in_bot_hora <= 4'b0000;
                           in_bot_cr <= 4'b0000;
                           
                         end
               3'b010 : begin
                           in_bot_fecha <= 4'b0000;
                           in_bot_hora <= botones;
                           in_bot_cr <= 4'b0000;
                         end
               3'b001 : begin
                            in_bot_fecha <= 4'b0000;
                            in_bot_hora <= 4'b0000;
                            in_bot_cr <= botones;
                         end
               default:
                       begin
                          in_bot_fecha <= 4'b0000;
                          in_bot_hora <= 4'b0000;
                          in_bot_cr <= 4'b0000;
                         end
           endcase
       end     
    
    
////// agarrar dato de control    
    
always @(posedge reloj)
begin

if(resetM)
    Control_reg <= 0;
    
else if(en_10 && port_id == 8'h10)
    Control_reg = out_port[1:0];
    
else
    Control_reg <= Control_reg;

end  
    

////// agarrar dato de F_H 

always @(posedge reloj)
begin

if(resetM)
    F_H_reg <= 0;

else if(en_10 && port_id == 8'h21)
    F_H_reg <= out_port[0];
    
else 
    F_H_reg <= F_H_reg;

end    
    
    
    
    
    
////// agarrar dato de A_A

always @(posedge reloj)
begin

if(resetM)
    A_A_reg <= 0;

else if(en_10 && port_id == 8'h20)
    A_A_reg <= out_port[0];
    
else 
    A_A_reg <= A_A_reg;

end    
    
    
/////// agarrar dato act_crono    
        
always @(posedge reloj)
begin

if(resetM)
    act_crono_reg <= 0;

else if(en_10 && port_id == 8'h11)
    act_crono_reg <= out_port[0];
    
else 
    act_crono_reg <= act_crono_reg;

end      
    
    
    
    
endmodule
