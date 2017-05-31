`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo4
// Engineer: Dalberth
// Create Date: 05/26/2017 09:56:28 PM
// Module Name: mux_DIR_DATO
//////////////////////////////////////////////////////////////////////////////////



module mux_DIR_DATO(
    // Entradas General
    input reloj,
    input resetM,
    input wire [7:0] Inicie,
    input wire [7:0] Mod_S,
    input wire [7:0] OUT_diaf,
    input wire [7:0] OUT_mesf,
    input wire [7:0] OUT_anof,
    input wire [7:0] OUT_segh,
    input wire [7:0] OUT_minh,
    input wire [7:0] OUT_horah,
    
    // Entradas picoblaze
    input wire en_01,
    input wire [7:0] out_port,
    input wire [7:0] port_id,

    
    // Entradas inter-modular (de la ruta de control)
    input wire [4:0] cont_32,       
    input wire enable_cont_32,      
    input wire [4:0] cont17,
    input wire LE,                  
    input wire sync,                
    
    // Salidas General
    output wire [7:0] IN_diaf,
    output wire [7:0] IN_mesf,
    output wire [7:0] IN_anof,
    output wire [7:0] IN_segh,
    output wire [7:0] IN_minh,
    output wire [7:0] IN_horah,
    output wire [7:0] IN_segcr,
    output wire [7:0] IN_mincr,
    output wire [7:0] IN_horacr,
    output wire [3:0] Selec_Demux_DDw,      
    output wire READ,
    
    // Salidas inter-modular (de la ruta de control)
    output wire [3:0] Selec_Mux_DDw,
    
    // IN-OUT
    inout wire [7:0] DIR_DATO
    );
    
    
    
    //---MANEJO OUT PORT DEL PICOBLAZE---
    // Definicion e inicializacion de variables
    reg [7:0] Control;              // Estado de la FSM general
    
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
    
    
    
    //---MULTIPLEXACION DEL BUS BI-DIRECCIONAL DIR_DATO (DEL RTC)---
    // Definicion e inicializacion de variables y parametros
    parameter [7:0] Transf = 8'hF0;     // Constantes que a veces salen del mux (F0 para transferencia y 0)
    parameter [7:0] Zero = 8'h00;    
    reg [7:0] OUT_segcr = 8'h41;  
    reg [7:0] OUT_mincr = 8'h42;      
    reg [7:0] OUT_horacr = 8'h43;
    
    // Logica direcciones y datos del crono
    always @(posedge reloj)
    begin
        if (cont_32 < 5'b10000)
            begin
            OUT_segcr <= 8'h41;  
            OUT_mincr <= 8'h42;      
            OUT_horacr <= 8'h43;
            end
       
        else
           begin 
           OUT_segcr <= 8'h00;  
           OUT_mincr <= 8'h00;      
           OUT_horacr <= 8'h00;   
           end
    end
    
    // Otras variables
    reg [7:0] DIR_DATO_out;                 // Variables que define una salida para el inout DIR_DATO
    reg [3:0] Selec_Mux_DD;                 // Selecciona que sale por DIR_DATO
    assign Selec_Mux_DDw = Selec_Mux_DD;
    
    reg [3:0] cont_lec = 4'b0010;           // Contadores que podrian tomar Selec_Mux
    reg [4:0] cont_escaux = 5'b00000;
    reg [3:0] cont_esc = 4'b0011;
    
    // Mux para la salida de DIR_DATO
    always @(posedge reloj)
    begin
    case (Selec_Mux_DD)
      4'b0000: DIR_DATO_out <= Inicie;
      4'b0001: DIR_DATO_out <= Mod_S;
      4'b0010: DIR_DATO_out <= Transf;
      4'b0011: DIR_DATO_out <= OUT_diaf;
      4'b0100: DIR_DATO_out <= OUT_mesf;
      4'b0101: DIR_DATO_out <= OUT_anof;
      4'b0110: DIR_DATO_out <= OUT_segh;
      4'b0111: DIR_DATO_out <= OUT_minh;
      4'b1000: DIR_DATO_out <= OUT_horah;
      4'b1001: DIR_DATO_out <= OUT_segcr;
      4'b1010: DIR_DATO_out <= OUT_mincr;
      4'b1011: DIR_DATO_out <= OUT_horacr;
      4'b1100: DIR_DATO_out <= Transf;
      4'b1101: DIR_DATO_out <= Zero;
      4'b1110: DIR_DATO_out <= Zero;
      4'b1111: DIR_DATO_out <= Zero;
      default:  DIR_DATO_out <= Zero;
    
    endcase
    end
    
    // Contador de lectura (para definir la logica de Selec_Mux)
    always @(posedge reloj)
    begin
        if (resetM || sync)
            cont_lec <= 4'b0010;
        else if (enable_cont_32)
                if (cont_lec == 4'b1011)
                    cont_lec <= 4'b0010;
                else
                    cont_lec <= cont_lec + 1'b1;    
            else
                 cont_lec <= cont_lec;   
    end  
    
    // Contador auxiliar para el "contador" de escritura (para definir la logica de Selec_Mux)
    always @(posedge reloj)
    begin
        if (resetM || sync)
            cont_escaux <= 5'b00000;
        else if (enable_cont_32)
                if (cont_escaux == 5'b10000)
                    cont_escaux <= 5'b00000;
                else
                    cont_escaux <= cont_escaux + 5'b00001;
             else
                cont_escaux <= cont_escaux;
    end

    // "Contador" de escritura (para definir la logica de Selec_Mux)
    always @(posedge reloj)
    begin
        case (cont_escaux)
            5'b00000: cont_esc <= 4'b0011;
            5'b00001: cont_esc <= 4'b0100;
            5'b00010: cont_esc <= 4'b0101;
            5'b00011: cont_esc <= 4'b0110;
            5'b00100: cont_esc <= 4'b0111;
            5'b00101: cont_esc <= 4'b1000;
            5'b00110: cont_esc <= 4'b1100;
            5'b00111: cont_esc <= 4'b0010;
            5'b01000: cont_esc <= 4'b0011;
            5'b01001: cont_esc <= 4'b0100;
            5'b01010: cont_esc <= 4'b0101;
            5'b01011: cont_esc <= 4'b0110;
            5'b01100: cont_esc <= 4'b0111;
            5'b01101: cont_esc <= 4'b1000;
            5'b01110: cont_esc <= 4'b1001;
            5'b01111: cont_esc <= 4'b1010;
            5'b10000: cont_esc <= 4'b1011;   
            default :   cont_esc <= 4'b0011;
            endcase
    end
    
    // Definicion de Selec_Mux_
    always @(*)
    begin
        case (Control)
            8'h00:  Selec_Mux_DD <= 4'b0000;
            8'h01:  Selec_Mux_DD <= cont_lec;
            8'h02:  Selec_Mux_DD <= cont_esc;
            8'h03:  Selec_Mux_DD <= 4'b0001;
        default:    Selec_Mux_DD <= 4'b0000;
        endcase
    end
    
    
    
    //---DEMULTIPLEXACION DEL BUS BI-DIRECCIONAL DIR_DATO (DEL RTC)---
    // Definicion e inicializacion de variables y parametros
    reg [7:0] IN_diafreg = 8'h00;
    reg [7:0] IN_mesfreg = 8'h00;
    reg [7:0] IN_anofreg = 8'h00;
    reg [7:0] IN_seghreg = 8'h00;
    reg [7:0] IN_minhreg = 8'h00;
    reg [7:0] IN_horahreg = 8'h00; 
    reg [7:0] IN_segcrreg = 8'h00;   
    reg [7:0] IN_mincrreg = 8'h00;     
    reg [7:0] IN_horacrreg = 8'h00;
    assign IN_diaf = IN_diafreg;
    assign IN_mesf = IN_mesfreg;    
    assign IN_anof = IN_anofreg;    
    assign IN_segh = IN_seghreg;     
    assign IN_minh = IN_minhreg;   
    assign IN_horah = IN_horahreg;   
    assign IN_segcr = IN_segcrreg;   
    assign IN_mincr = IN_mincrreg;     
    assign IN_horacr = IN_horacrreg;
    
    reg [7:0] DIR_DATO_in;                      // Aca se guarda un valor que podria entrarle a DIR_DATO
    reg [3:0] Selec_Demux_DD;                   // Selecciona a que se le asigna lo que entra por DIR_DATO
    assign Selec_Demux_DDw = Selec_Demux_DD;
    
    // Demux para la entrada de DIR_DATO
    always @(posedge reloj)
    begin
         case(Selec_Demux_DD)
           4'b0000: 
             begin
                 IN_diafreg <=DIR_DATO_in;
                 IN_mesfreg <=8'b00000000;   
                 IN_anofreg <=8'b00000000;    
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=8'b00000000;   
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <=8'b00000000;      
                 IN_horacrreg <= 8'b00000000;   
             end
           4'b0001: 
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=DIR_DATO_in;  
                 IN_anofreg <=8'b00000000;    
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=8'b00000000;   
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <=8'b00000000;      
                 IN_horacrreg <= 8'b00000000;   
             end
           4'b0010: 
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=DIR_DATO_in;    
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=8'b00000000;   
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <=8'b00000000;      
                 IN_horacrreg <= 8'b00000000; 
             end
           4'b0011: 
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=8'b00000000;   
                 IN_seghreg <=DIR_DATO_in;   
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=8'b00000000;   
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <=8'b00000000;      
                 IN_horacrreg <= 8'b00000000;
             end
           4'b0100:
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=8'b00000000;   
                 IN_seghreg <=8'b00000000;  
                 IN_minhreg <=DIR_DATO_in;    
                 IN_horahreg <= 8'b00000000;   
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <=8'b00000000;      
                 IN_horacrreg <= 8'b00000000;
             end 
           4'b0101: 
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=8'b00000000;   
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=DIR_DATO_in;
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <= 8'b00000000;      
                 IN_horacrreg <= 8'b00000000;
             end
           4'b0110:
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=8'b00000000;   
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=8'b00000000;   
                 IN_segcrreg <=DIR_DATO_in;  
                 IN_mincrreg <=8'b00000000;      
                 IN_horacrreg <= 8'b00000000;
             end 
           4'b0111:
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=8'b00000000;   
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <=8'b00000000;    
                 IN_horahreg <=8'b00000000;   
                 IN_segcrreg <=8'b00000000;   
                 IN_mincrreg <=DIR_DATO_in;    
                 IN_horacrreg <= 8'b00000000;
             end 
           4'b1000:
             begin
                 IN_diafreg <=8'b00000000; 
                 IN_mesfreg <=8'b00000000;  
                 IN_anofreg <=8'b00000000;   
                 IN_seghreg <=8'b00000000;    
                 IN_minhreg <= 8'b00000000;    
                 IN_horahreg <= 8'b00000000;   
                 IN_segcrreg <= 8'b00000000;   
                 IN_mincrreg <= 8'b00000000;      
                 IN_horacrreg <= DIR_DATO_in;  
             end 
           
           default:
               begin
                   IN_diafreg <=8'b00000000; 
                   IN_mesfreg <=8'b00000000;  
                   IN_anofreg <=8'b00000000;   
                   IN_seghreg <=8'b00000000;    
                   IN_minhreg <=8'b00000000;    
                   IN_horahreg <=8'b00000000;   
                   IN_segcrreg <=8'b00000000;   
                   IN_mincrreg <=8'b00000000;      
                   IN_horacrreg <= 8'b00000000; 
               end  
         endcase
    end
    
    // Definicion de Selec_Demux
    always @(*)
    begin
        case (Control)
            8'h00: Selec_Demux_DD <= 4'b1111;
            
            8'h01:
            case (Selec_Mux_DD)
                4'b0000: Selec_Demux_DD <= 4'b1111;     //  En estos casos, lo que entra po DIR_DATO no es de interes         
                4'b0001: Selec_Demux_DD <= 4'b1111;     // Se puede estar escribiendo
                4'b0010: Selec_Demux_DD <= 4'b1111; 
                4'b1100: Selec_Demux_DD <= 4'b1111; 
                4'b1101: Selec_Demux_DD <= 4'b1111; 
                4'b1110: Selec_Demux_DD <= 4'b1111; 
                4'b1111: Selec_Demux_DD <= 4'b1111; 
                default:    Selec_Demux_DD <= Selec_Mux_DD - 4'b0011;   //Logica en el caso de que si se ocupe leer
            endcase
            
            8'h02:
            begin
                if (LE) // Si se esta leyendo
                    case (Selec_Mux_DD)
                            4'b0000: Selec_Demux_DD <= 4'b1111; 
                            4'b0001: Selec_Demux_DD <= 4'b1111; 
                            4'b0010: Selec_Demux_DD <= 4'b1111; 
                            4'b1100: Selec_Demux_DD <= 4'b1111; 
                            4'b1101: Selec_Demux_DD <= 4'b1111; 
                            4'b1110: Selec_Demux_DD <= 4'b1111; 
                            4'b1111: Selec_Demux_DD <= 4'b1111; 
                            default:    Selec_Demux_DD <= Selec_Mux_DD - 4'b0011;
                        endcase
                else
                    Selec_Demux_DD <= 4'b1111;
            end
            
            8'h03:  Selec_Demux_DD <= 4'b1111;
            
            default: Selec_Demux_DD <= 4'b1111;
        endcase
    end
    
    
    
    //---MANEJO DEL inout DIR_DATO---
    // Definicion e inicializacion de variables y parametros
    reg dir = 1'b0;
    reg READr = 1'b0;
    assign READ = READr;
    
    // Segun dir (direccion del bus) se decide si el bus debe estar en alta impedancia, listo para recibir algo
    // o si debe estar sacando datos (DIR_DATO_out)
    assign DIR_DATO = dir ? 8'bzzzzzzzz : DIR_DATO_out;        // 1 : 0
    
    // READ esta en alto cuando llega un dato del RTC, si es asi entonces se le debe asignar DIR_DATO (el bus)
    // a la variable que guarda lo que llega del RTC y lo demultiplexa (DIR_DATO_in)
    // sino DIR_DATO_in debe estar en alta impedancia porque se puede estar enviando un dato mas bien
    always @(*)
    begin
        if (READ)
            DIR_DATO_in <= DIR_DATO;
        else
            DIR_DATO_in <= 8'bzzzzzzzz;
    end
    
    // Definicion de dir (direccion del bus DIR_DATO)
    always @(posedge reloj)
    begin
        case (Control)
            8'h00:   dir <= 1'b0;                   // dir esta en 1 cuando estamos en un intervalo de tiempo en el cual
                                                    // algo podria ingresar por DIR_DATO y cero cuando mas bien se 
            8'h01:                                  // podria estar mandando algo por le bus
                 begin
                    if (cont_32 > 5'b01011)
                        dir <= 1'b1;
                    else
                        dir <= 1'b0;
                 end
                 
            8'h02:
                begin
                if (cont17 < 5'b00111) 
                    dir <= 1'b0;
                else
                   if (cont_32 > 5'b01011)
                        dir <= 1'b1;
                   else
                        dir <= 1'b0;   
                end
                
            8'h03:  dir <= 1'b0;  
            
            default: dir <= dir;
        endcase
    end
    
    // Definicion de READ
    always @(*)                 // READ = 1 define el tiempo exacto en el que llega un dato del RTC
    begin                           
        if (dir)
            if (cont_32 > 5'b10111 && cont_32 < 5'b11101)
                READr <= 1'b1;
            else
                READr <= 1'b0;  
        else
            READr <= 1'b0;
    end

    
    
endmodule