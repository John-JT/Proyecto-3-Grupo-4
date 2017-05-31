`timescale 1ns / 1ps


module Posicion_Imagenes(
    input AM_PM,
    input F_H,
    input [4:0] Qh,
    input [9:0] Qv,
    input reloj,
    input resetM,
    output [8:0] DIR_IM
    );

    reg [4:0] M_hreg;                 
    reg [4:0] M_vreg;                 
    reg [4:0] SELEC_COL;              
    reg [8:0] DIR;                    

                                           /*DIRECCION IMAGENES*/
parameter CALENDARIO = 4'h1; parameter CRONO = 4'h2; parameter HORA = 4'h3; parameter AVATAR = 4'h4;
parameter AM = 4'h5; parameter PM = 4'h6;

                                           /*IMAGENES POSICIONES*/
                                                /*VERTICAL*/
                                                /*CALENDARIO*/
 parameter CAL1_v = 5'd7; parameter CAL2_v = 5'd8; 
                                              /*HORA Y CRONO*/
 parameter HC1_v = 5'd3; parameter HC2_v = 5'd4;
 
 parameter AM1_v = 5'd5;  parameter AM2_v = 5'd6;
 parameter PM1_v = 5'd6;  parameter PM2_v = 5'd7;
                                                /*AVATAR*/
 parameter AVA1_v = 5'd12; parameter AVA2_v = 5'd13;                                                
                                                
                                                /*HORIZONTAL*/
                                                /*CALENDARIO*/
 parameter CAL1_h = 5'd11; parameter CAL2_h = 5'd12;
                                              /*HORA Y CRONO*/
 parameter HORA1_h = 5'd4; parameter HORA2_h = 5'd5;
 parameter CRONO1_h = 5'd18; parameter CRONO2_h = 5'd19;
 
 parameter AM1_h = 5'd8;  parameter AM2_h = 5'd9;
 parameter PM1_h = 5'd8;  parameter PM2_h = 5'd9;
                                                /*AVATAR*/
 parameter AVA1_h = 5'd11; parameter AVA2_h =5'd12;
                                
    always @(posedge reloj) begin
        M_vreg <= {Qv[9:5]};
        M_hreg <= Qh;
        SELEC_COL <= {Qv[4] , Qv[3], Qv[2], Qv[1], Qv[0]};       
    end
    always @(*) begin
    if (resetM)
    DIR <= 9'd0;
    else
    begin
    if (M_vreg >= HC1_v && M_vreg < HC2_v)
    begin
        if (M_hreg >= HORA1_h && M_hreg < HORA2_h)
            DIR <= {HORA, SELEC_COL};
        else if (M_hreg >= CRONO1_h && M_hreg < CRONO2_h)
            DIR <= {CRONO, SELEC_COL};        
        else
            DIR <= 9'h000;
    end
    
    //Falta definir como se si es de mañana o tarde
    else if (M_vreg >= AM1_v && M_vreg <= AM2_v && F_H == 1'b1 && AM_PM == 1'b0)
    begin
        if (M_hreg >= AM1_h && M_hreg <= AM2_h)
            DIR <= {AM, SELEC_COL};
        else
            DIR <= 9'h000;
    end

    else if (M_vreg >= PM1_v && M_vreg <= PM2_v && F_H == 1'b1 && AM_PM == 1'b1)
    begin
        if (M_hreg >= PM1_h && M_hreg <= PM2_h)
            DIR <= {PM, SELEC_COL};
        else
            DIR <= 9'h000;
    end

    else if ( M_vreg >= CAL1_v && M_vreg < CAL2_v)
    begin
        if (M_hreg >= CAL1_h && M_hreg < CAL2_h)
            DIR <= {CALENDARIO, SELEC_COL};
        else
            DIR <= 9'h000;
    end
    
    else if (M_vreg >= AVA1_v && M_vreg < AVA2_v)
    begin
        if (M_hreg >= AVA1_h && M_hreg < AVA2_h)
            DIR <= {AVATAR, SELEC_COL};
        else
            DIR <= 9'h000;
    end
    
    else
        DIR <= 9'h000;   
    end
    
    end
    assign DIR_IM = DIR;
    

endmodule
