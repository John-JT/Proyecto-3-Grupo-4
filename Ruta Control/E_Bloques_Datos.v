`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4
// Engineer: Dalberth
// Create Date: 05/28/2017 07:58:20 PM 
// Module Name: E_Bloques_Datos
//////////////////////////////////////////////////////////////////////////////////



module E_Bloques_Datos(
    // Salidas General
    output wire enable_cont_I,          // Enables para la ruta de datos, del modulo de inicializacion, fecha, hora, etc.  
    output wire enable_cont_MS,
    output wire enable_cont_fecha,
    output wire enable_cont_hora,
    
    // Entradas inter-modular (de la ruta de control)
    input wire [3:0] Selec_Mux_DDw 
    );
    
    
    
    //---INICIALIZACION/DEFINICION DE VARIABLES---
    reg enable_cont_Ir;     
    reg enable_cont_MSr;
    reg enable_cont_fechar;
    reg enable_cont_horar;  
    assign enable_cont_I = enable_cont_Ir; 
    assign enable_cont_MS = enable_cont_MSr;
    assign enable_cont_fecha = enable_cont_fechar;
    assign enable_cont_hora = enable_cont_horar;
    
    
    
    //---LOGICA DE LOS ENABLES DE LOS BLOQUES DE DATOS---
    always @(*)
    begin
        case (Selec_Mux_DDw)                    // Dependiendo del valor de la seleccion del mux, o sea dependiendo
            4'b0000:                            // de lo que se quiera sacar (segundos de la hora por ejemplo) se
            begin                               // analiza que bloque se debe estar activado (modulo de hora por ejemplo)
                enable_cont_Ir = 1'b1; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b0;
                enable_cont_horar = 1'b0;
            end
            4'b0001:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b1;
                enable_cont_fechar = 1'b0;
                enable_cont_horar = 1'b0;
            end
            4'b0010:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b0;
                enable_cont_horar = 1'b0;
            end
            4'b0011:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b1;
                enable_cont_horar = 1'b0;
            end
            4'b0100:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b1;
                enable_cont_horar = 1'b0;
            end
            4'b0101:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b1;
                enable_cont_horar = 1'b0;
            end
            4'b0110:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b0;
                enable_cont_horar = 1'b1;
            end
            4'b0111:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b0;
                enable_cont_horar = 1'b1;
            end
            4'b1000:
            begin
                enable_cont_Ir = 1'b0; 
                enable_cont_MSr = 1'b0;
                enable_cont_fechar = 1'b0;
                enable_cont_horar = 1'b1;
            end
            default:
            begin
               enable_cont_Ir = 1'b0; 
               enable_cont_MSr = 1'b0;
               enable_cont_fechar = 1'b0;
               enable_cont_horar = 1'b0;
            end
        endcase
    end
    endmodule