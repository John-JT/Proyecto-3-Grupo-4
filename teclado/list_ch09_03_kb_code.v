//Listing 9.3
module kb_code
 
   (
    input wire reloj, reset,rx_done_tick,
    input wire [7:0] dout, 
    input wire bit_pari_tecla,
    output wire got_code_tick,
    output wire [7:0] key_code,
    output wire bit_paridad
   );

    
   // constant declaration
   localparam BRK = 8'hf0; // break code

   // symbolic state declaration
   localparam
      wait_brk = 1'b0,
      get_code = 1'b1;

   // signal declaration
   reg state_reg, state_next;
   reg [7:0] key_code_reg;
   reg got_code_tick_reg;
   reg bit_paridad_reg;
 
    assign key_code = key_code_reg;
    assign got_code_tick = got_code_tick_reg;
    assign bit_paridad = bit_paridad_reg;
    
    

   always @(posedge reloj, posedge reset)
      if (reset)
         state_reg <= wait_brk;
      else
         state_reg <= state_next;

   // next-state logic\\\\\\\\\\\\\\\\cambiar por *
   always @(*)
   begin
      got_code_tick_reg = 1'b0;
      state_next = state_reg;
      case (state_reg)
         wait_brk:  // wait for F0 of break code
            if (rx_done_tick==1'b1 && dout==BRK)
               state_next = get_code;
         get_code:  // get the following scan code
            if (rx_done_tick)
               begin
                  got_code_tick_reg =1'b1;
                  state_next = wait_brk;
                  key_code_reg = dout;
                  bit_paridad_reg = bit_pari_tecla;
                  
               end
      endcase
   end

endmodule
