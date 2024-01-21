module DATA_SYNC_tb #(
       parameter NUM_STAGES =2 ,
                 BUS_WIDTH=8 
) (
    
);
     reg                       rst_tb                ;
     reg                       clk_tb                ;
     reg   [BUS_WIDTH-1:0]     unsync_bus_tb         ;
     reg                       bus_enable_tb         ;                     
     wire  [BUS_WIDTH-1:0]     sync_bus_tb           ;                      
     wire                      enable_pulse_tb       ;      

//Initial 
initial
 begin
$dumpfile("DATA_SYNC.vcd") ;       
$dumpvars;
initialize();
reset();
set_value();
repeat (6) @(posedge clk_tb);
if (sync_bus_tb=='b1000) begin
         $display ("TEST CASE  IS PASSED") ;
end else begin
         $display ("TEST CASE  IS FAILED") ;
end  



#100

$stop ;

end

////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
 begin
 clk_tb=1'b0           ;
 unsync_bus_tb='b0     ;
 bus_enable_tb=1'b0    ; 
              
 end
endtask
///////////////////////// RESET /////////////////////////

task reset ;
 begin
  rst_tb = 1'b1  ;  
  #1
  rst_tb = 1'b0  ;  
  #1
  rst_tb = 1'b1  ;  
 end
endtask

///////////////////////// set value /////////////////////////

task set_value ;
 begin
 unsync_bus_tb='b1000;
 bus_enable_tb='b1;
 end
endtask



////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #20 clk_tb = ~clk_tb ;
////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////

DATA_SYNC #(.NUM_STAGES(NUM_STAGES),.BUS_WIDTH(BUS_WIDTH)) DUT
(

.RST          (rst_tb)           ,
.CLK          (clk_tb)           ,
.unsync_bus   (unsync_bus_tb)    ,
.bus_enable   (bus_enable_tb)    ,
.sync_bus     (sync_bus_tb)      ,
.enable_pulse (enable_pulse_tb)

);
           

endmodule

