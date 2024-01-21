module DATA_SYNC #(
    parameter NUM_STAGES =2 ,
              BUS_WIDTH=8 )
(
input  wire [BUS_WIDTH-1:0]  unsync_bus                                ,
input  wire                  RST                                       ,
input  wire                  CLK                                       ,
input  wire                  bus_enable                                ,
output reg  [BUS_WIDTH-1:0]  sync_bus                                  ,
output reg                   enable_pulse 
);
reg [NUM_STAGES-1:0] meta_stable       ;
wire                 meta_stable_out   ;
reg                  pulse_gen_flop_out;
wire                 PulseGen          ;
wire [BUS_WIDTH-1:0] MUX_out           ;   
//multi flip flop for metastability
assign meta_stable_out =meta_stable[NUM_STAGES-1];
always @(posedge CLK or negedge RST ) 
begin
  if (!RST) 
   begin
      meta_stable<='b0;
   end 
  else
   begin
    if(NUM_STAGES=='b1)
        meta_stable<=bus_enable;      
    else	
        meta_stable<={meta_stable[NUM_STAGES-2:0],bus_enable}; 
    end 
end
// pulse gen flip flop 
always @(posedge CLK or negedge RST  )
 begin
    if (!RST)
     begin
        pulse_gen_flop_out<=1'b0;
     end
    else
     begin
        pulse_gen_flop_out<=meta_stable_out;
     end
end

assign PulseGen =(!pulse_gen_flop_out) & meta_stable_out    ;

//enable pulse flip flop
always @(posedge CLK or negedge RST  ) begin
    if (!RST) begin
        enable_pulse<=1'b0;
    end 
    else
     begin
        enable_pulse<=PulseGen;
     end
    
end

assign MUX_out = PulseGen  ? unsync_bus : sync_bus ;

// sync bus flip flop 
always @(posedge CLK or negedge RST  ) begin
    if (!RST)
     begin
        sync_bus<='b0;    
     end
    else
     begin
        sync_bus<=MUX_out;
     end 
end
endmodule
