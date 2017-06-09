`timescale 1ns / 1ps
module Interfaz_IO(
    input reloj,
    input interrupt_ack,
    input [7:0] port_id, //MSB 
    input [7:0] dato_tec,
    input interrupt_alarma,
    input interrupt_teclado,
    input interrupt_crono,
    input write_strobe,
    //input read_strobe,
    output [2:0] EnableOut,
    output [7:0] in_port,
    output interrupt
    );
    
    reg [2:0] enableout;
    reg [7:0] In_port;
    reg Interrupt;
    wire int_request;
    reg enable_crono = 1'b0;
    reg [3:0] cont = 9;
    
    assign int_request = interrupt_alarma | interrupt_teclado | interrupt_crono;

    always @(posedge reloj)
    begin
        if (interrupt_crono)
        begin
            cont <= 0;
            enable_crono <= 1'b0;
        end
        else if (cont < 9)
        begin
            cont <= cont + 1;
            enable_crono <= 1'b1;
        end
        else
        begin
            enable_crono <= 1'b0;
            cont <= 9;
        end
        
    end

    
//Lógica para la interfaz de salida    
    always@(*)
    begin
        if (write_strobe)
            case ({port_id[5:4],port_id[1:0]}) //MSB Módulo Diego, [1] Dalberth, LSB John
                4'b0000: enableout = 3'b001;
                4'b0001: enableout = 3'b101;
                4'b0100: enableout = 3'b110;
                4'b0101: enableout = 3'b110;
                4'b1000: enableout = 3'b100;
                4'b1001: enableout = 3'b100;
                4'b1010: enableout = 3'b100;
                default: enableout = 3'b000;
            endcase
       else 
            enableout = 3'b000;
    end
    
        assign EnableOut = enableout;
//Lógica para la interfaz de entrada        
    always@(*)
    begin
//        if (read_strobe)
            if (interrupt_alarma && port_id == 8'h30)          
                In_port <= 8'd100;
            else if ( interrupt_alarma && port_id == 8'h31)
                In_port <= dato_tec;
            else if(enable_crono)
                In_port <= 8'd101;
//            else if (port_id == 8'h30 || port_id == 8'h31)
//                In_port = dato_tec;
            else
//                In_port = 8'h00;
                In_port <= dato_tec;
    end  
    
        assign in_port = In_port;
        
always @ (posedge reloj)
          begin
              if (interrupt_ack == 1'b1) begin
                 Interrupt <= 1'b0;
              end
              else if (int_request == 1'b1) begin
                  Interrupt <= 1'b1;
              end
              else begin
                  Interrupt <= Interrupt;
              end
          end
          
          assign interrupt = Interrupt;
          
endmodule
