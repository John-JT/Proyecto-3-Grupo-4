`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2017 23:30:10
// Design Name: 
// Module Name: teclado_todo_tb
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


module teclado_todo_tb(

    );
    
    
    
    reg reloj;
    reg reset;
    reg ps2c;
    reg ps2d;
    wire [7:0] dato_listo;
    wire bit_paridad;
    wire paridad;
    wire xor_dato;
    wire tick;
    
    
    
teclado_todo ins_teclado_todo (


    .reloj(reloj),
    .reset(reset),
    .ps2c(ps2c),
    .ps2d(ps2d),
    .dato_listo(dato_listo),
    .bit_paridad(bit_paridad),
    .paridad(paridad),
    .xor_dato(xor_dato),
    .tick(tick)

);
    

initial 

begin

    reloj <= 0;
    reset <= 0;
    ps2d <= 1;
    ps2c <= 1;
    
        #300  ps2d <= 0;
        
        #33333  ps2c <= 0;
        #33333  ps2c <= 1;
        ps2d <= 0;
        
        
        #33333  ps2c <= 0;
        #33333  ps2c <= 1;
        ps2d <= 0;
        
        
        #33333  ps2c <= 0;
        #33333  ps2c <= 1;  
        ps2d <= 0;
          
          
        #33333  ps2c <= 0;
        #33333  ps2c <= 1;
        ps2d <= 0;
          
          
        #33333  ps2c <= 0;
        #33333  ps2c <= 1; 
        ps2d <= 1;
          
          
        #33333  ps2c <= 0;
        #33333  ps2c <= 1; 
        ps2d <= 1;  
         
         
        #33333  ps2c <= 0;
        #33333  ps2c <= 1;
        ps2d <= 1;
         
          
        #33333  ps2c <= 0;
        #33333  ps2c <= 1; 
        ps2d <= 1;
        
              
        #33333  ps2c <= 0;
        #33333  ps2c <= 1;
        ps2d <= 0;
         
              
        
        #33333  ps2c <= 0;
        #33333  ps2c <= 1; 
        ps2d <= 1;
        
        #33333  ps2c <= 0;
        #33333  ps2c <= 1; 
        
///////// segundo dato 

        
            #300  ps2d <= 0;
            
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;
            ps2d <= 1;
            
            
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;
            ps2d <= 1;
            
            
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;  
            ps2d <= 0;
              
              
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;
            ps2d <= 0;
              
              
            #33333  ps2c <= 0;
            #33333  ps2c <= 1; 
            ps2d <= 0;
              
              
            #33333  ps2c <= 0;
            #33333  ps2c <= 1; 
            ps2d <= 1;  
             
             
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;
            ps2d <= 0;
             
              
            #33333  ps2c <= 0;
            #33333  ps2c <= 1; 
            ps2d <= 0;
            
                  
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;
            ps2d <= 1;
             
                  
            
            #33333  ps2c <= 0;
            #33333  ps2c <= 1; 
            ps2d <= 0;
            
            #33333  ps2c <= 0;
            #33333  ps2c <= 1;        
        
 
 

 
   
 
 

end 
    
    
     always
              begin
                  #5 reloj <= ~reloj;
              end 
    
    
    
endmodule
