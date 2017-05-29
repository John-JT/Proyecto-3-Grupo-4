`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4 
// Engineer: Dalberth
// Create Date: 05/22/2017 10:20:23 PM
// Module Name: Gen_Senales
//////////////////////////////////////////////////////////////////////////////////



module Gen_Senales(
    // Entradas general         
    input reloj,
    input resetM,
    input wire [23:0] alarma,
    
    // Entradas picoblaze
    input wire en_01,
    input wire [7:0] out_port,
    input wire [7:0] port_id,
    
    // Salidas general          
    output wire act_crono,
    output wire enable_cont_16,
    output wire CS,
    output wire RD,
    output wire WR,
    output wire A_D,
    
    // Salidas inter-modular (de la ruta de control)
    output wire [4:0] cont_32,      
    output wire enable_cont_32,     
    output wire [4:0] cont17,
    output wire LE,                 
    output wire sync                
    );
   
    
    
    //---MANEJO OUT PORT DEL PICOBLAZE---
    // Definicion e inicializacion de variables
    reg [7:0] Control;              // Estado de la FSM general
    reg [7:0] posp = 8'h00;         // Permite saber si se esta escribiendo y sobre que se esta escribiendo (hora, fecha, etc)
    
    // Recepcion de control en el out_port segun port_id
    always @(posedge reloj)
    begin
        if (resetM)
            Control <= 8'h00;
            
        else
        if (en_01)
            case (port_id)    
                8'h10: Control <= out_port;     // Cuando segun port_id viene Control por out_port, se actualiza Control
            default: Control <= Control;    
            endcase
            
        else
           Control <= Control; 
    end
    
    // Recepcion de posp en el out_port segun port_id
        always @(posedge reloj)
    begin
        if (resetM)
            posp <= 8'h00;
            
        else
        if (en_01)
            case (port_id)    
                8'h01: posp <= out_port;     // Cuando segun port_id viene posp por out_port, se actualiza posp
            default: posp <= posp;    
            endcase
            
        else
           posp <= posp; 
    end

    
    
    //---PULSO DE SINCRONIZACION---
    /* Copyright (c) 2015, William Breathitt Gray
     *
     * Redistribution and use in source and binary forms, with or without
     * modification, are permitted provided that the following conditions
     * are met:
     *
     * 1. Redistributions of source code must retain the above copyright
     *    notice, this list of conditions and the following disclaimer.
     * 
     * 2. Redistributions in binary form must reproduce the above copyright
     *    notice, this list of conditions and the following disclaimer in
     *    the documentation and/or other materials provided with the
     *    distribution.
     *
     * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
     * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
     * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
     * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
     * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
     * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
     * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
     * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
     * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
     * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
     * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
     * POSSIBILITY OF SUCH DAMAGE.
     */
     // Variables
     reg pulse = 1'b0;             
     assign sync = pulse;          
     parameter PULSE_WIDTH = 1;
     reg [4:0] count = 5'b00000;
     reg pulse1 = 1'b0;
     reg pulse2 = 1'b0;
     reg pulse3 = 1'b0;
     reg pulse4 = 1'b0;
     wire count_rst = resetM | (count == PULSE_WIDTH);
     
     // Generacion de pulso cada vez que cambia el estado 'Control' de la FSM general
     always @ (posedge Control[0] , posedge count_rst) begin    // Analiza cada vez que todos los bits de Control
             if (count_rst) begin                               // cambian ya sea de 0 -> 1 o de 1 -> 0
                     pulse1 <= 1'b0;
             end else begin
                     pulse1 <= 1'b1;
             end
     end
     always @ (posedge Control[1], posedge count_rst) begin
             if (count_rst) begin
                     pulse2 <= 1'b0;
             end else begin
                     pulse2 <= 1'b1;
             end
     end
     always @ (negedge Control[0], posedge count_rst) begin
             if (count_rst) begin
                     pulse3 <= 1'b0;
             end else begin
                     pulse3 <= 1'b1;
             end
     end
     always @ (negedge Control[1], posedge count_rst) begin
             if (count_rst) begin
                     pulse4 <= 1'b0;
             end else begin
                     pulse4 <= 1'b1;
             end
     end
     always@(posedge reloj)
     pulse <= pulse1 | pulse2 | pulse3 | pulse4;

     always @ (posedge reloj, posedge count_rst) begin
             if(count_rst) begin
                     count <= 0;
             end else begin
                     if(pulse) begin
                             count <= count + 1'b1;
                     end
             end
     end
    
    
    
    //---SENAL DE CONTROL L/~E---
    // definicion e inicializacion de variables
    reg LEr;                                            
    assign LE = LEr;                    // LE = 0: genere senales de control del RTC (CS, RD, etc) de escritura. 
    reg [4:0] cont_32r = 5'b00000;      // LE = 1: genere de lectura.
    assign cont_32 = cont_32r;
    reg enable_cont_32r = 1'b0;
    assign enable_cont_32 = enable_cont_32r;
    reg [4:0] cont_17 = 5'b00000;               // Cuenta los datos que se van enviando al RTC para saber cuando usar LE =0 o =1
    assign cont17 = cont_17;                    // Esto se debe a que en el estado Escritura (2) se escribe Y se lee del RTC
                                                
    // Contador de datos    
    always @(posedge reloj)     
    begin                       
    if (resetM || sync)
        cont_17 <= 5'b00000;
    else 
    if (Control == 8'h02)                 // cuenta los 17 datos que se envian y leen en escritura
        begin    
        if (enable_cont_32r == 1'b1)
            if (cont_17 == 5'b10000)
                cont_17 <= 5'b00000;
            else
                cont_17 <= cont_17 + 5'b00001;
        else
            cont_17 <= cont_17;   
        end         
    else
        cont_17 <= 5'b00000;
    end
    
    // Mux para el valor de LE
    always @(posedge reloj)
    begin
        case (Control)
        8'h00: LEr = 1'b0;       
        8'h01: LEr = 1'b1;
        8'h02:
        begin                           // Solo en escritura hay mayor problema
            if (cont_17 < 5'b00111)     // Para algunos valores del contador, estamos leyendo del RTC
                LEr = 1'b0;             // Para otros estamos escribiendo
            else    
                LEr = 1'b1;                
        end
        
        8'h03: LEr = 1'b0;
        default: LEr <= LEr;
        endcase
    end

    
    
    //---SENALES DE CONTROL DEL RTC / HANDSHAKE---
    // definicion e inicializacion de variables:
    reg CSreg = 1'b1;
    assign CS = CSreg;
    reg RDreg = 1'b1;
    reg WRregLectura = 1'b1;
    reg A_Dreg = 1'b1;
    assign A_D = A_Dreg; 
    //Contadores
    reg [3:0] cont_16 = 4'b0000;
    reg enable_cont_16r = 1'b0;
    assign enable_cont_16 = enable_cont_16r;
    
    // Contador cada 10ns, cuenta 16 ciclos
    always @(posedge reloj)
    begin
       if (resetM || sync)
          cont_16 <= 4'b0000;
       else  
          begin  
          cont_16 <= cont_16 + 1'b1;
          if (cont_16 == 4'b1111)
                enable_cont_16r <= 1;
          else  
                enable_cont_16r <= 0;
          end           
    end   
    
    // Contador cada 10ns, cuenta 32 ciclos
    always @(posedge reloj)
        begin
           if (resetM || sync)
              cont_32r <= 5'b00000;
           else 
             begin               
              cont_32r <= cont_32r + 5'b00001;
              if (cont_32r == 5'b11111)
                    enable_cont_32r <= 1;
              else  
                    enable_cont_32r <= 0;
             end                  
        end      
             
    // Generador de Chip Select (~CS) 
        always @(posedge reloj)
           begin
           if (resetM || sync)
                CSreg <= 1'b1;           
           else 
            begin
               if (cont_32r < 2)
                    CSreg <= 1'b1;
               else if (cont_32r < 9) 
                        CSreg <= 1'b0;
                    else if (cont_32r < 20)
                            CSreg <= 1'b1;
                         else if(cont_32r < 27)
                                CSreg <= 1'b0;       
                              else
                                CSreg <= 1'b1;
            end                   
           end 
           
        // Generador de Read (~RD) 
        always @(posedge reloj) 
        begin
        if (resetM || sync)
            RDreg <= 1'b1;
        else 
         begin
            if (cont_32r < 20)
                     RDreg <= 1'b1;
                 else if (cont_32r < 27)
                         RDreg <= 1'b0;
                      else
                         RDreg <= 1'b1;  
         end              
        end
        
        // Generador de Write (~WR) para lectura
        always @(posedge reloj) 
        begin
            if (resetM || sync)
                WRregLectura <= 1'b1;
            else 
             begin
                if (cont_32r < 2)
                    WRregLectura <= 1'b1;
                else if (cont_32r < 9)
                        WRregLectura <= 1'b0;
                     else
                        WRregLectura <= 1'b1;  
             end
        end
        
        // Mux para el assign de las senales ~RD y ~WR tipo wire (salidas del modulo), segun si se esta leyendo o escribiendo en el RTC
        assign RD = LEr ? RDreg : 1'b1;
        assign WR = LEr ? WRregLectura : CSreg;
        
        // Generador Address/Data Decode (~A/D)   
        always @(posedge reloj)
        begin
            if (resetM || sync)
                A_Dreg <= 1'b1;
            else 
             begin
                if (cont_32r < 1)
                    A_Dreg <= 1'b1;
                else if (cont_32r < 11)
                        A_Dreg <= 1'b0;
                     else 
                        A_Dreg <= 1'b1;   
             end                       
        end  
    
    
    
   //---GENERACION DE LA SENAL ACTIVAR CRONOMETRO---
   // Variables y parametros 
   reg OR_alarma;        
   reg [1:0] in_crono;                      //entrada de la FSM 
   parameter crono_activado = 1'b1;         // estado 1
   parameter crono_desactivado = 1'b0;      // estado 0
   reg estado_crono = crono_desactivado;    //estado actual de la FSM
   
   // Definicion OR_alarma
   always @(posedge reloj)
   begin
        if (resetM)
            OR_alarma <= 1'b0;
        
        else
           OR_alarma <= alarma[0] | alarma[1] | alarma[2] | alarma[3]  | alarma[4] | alarma[5] | alarma[6] | alarma[7] | alarma[8] | alarma[9] | alarma[10] | alarma[11] | alarma[12] | alarma[13] | alarma[14] | alarma[15] | alarma[16] | alarma[17] | alarma[18]| alarma[19]| alarma[20]| alarma[21]| alarma[22]| alarma[23];        
   end
   
   // Definicion de la entrada de la FSM
   always @(posedge reloj)
   begin
        if (resetM)
            in_crono <= 2'b00; 
        
        else
            if (posp < 8'h04)
                in_crono <= {OR_alarma, (posp[1])&(posp[0])};
            else    
                in_crono <= {OR_alarma, 1'b0};

   end
   
   // FSM que genera un senal indicadora de cuando debe estar activado a desactivado el cronometro
   always @(posedge reloj)
      if (resetM)
         estado_crono <= crono_desactivado;
         
      else
         case (estado_crono)
            crono_desactivado: 
            begin
                case (in_crono)
                2'b00:  estado_crono <= crono_desactivado;
                2'b01:  estado_crono <= crono_desactivado;
                2'b10:  estado_crono <= crono_activado;
                2'b11:  estado_crono <= crono_desactivado;
                default:    estado_crono <= crono_desactivado;
                endcase
            end
            
            crono_activado: 
            begin
                case (in_crono)
                2'b00:  estado_crono <= crono_desactivado;
                2'b01:  estado_crono <= crono_desactivado;
                2'b10:  estado_crono <= crono_activado;
                2'b11:  estado_crono <= crono_activado;
                default:    estado_crono <= crono_desactivado;
                endcase
            end

            default : estado_crono <= crono_desactivado;
         endcase
   
   // Salida de la FSM 
   assign act_crono = (~estado_crono)&(in_crono[1])&(~in_crono[0]);
   // Add other output equations as necessary
							
							   
    
endmodule