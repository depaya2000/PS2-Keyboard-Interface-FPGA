`include "uvm_macros.svh"
import uvm_pkg::*;

// Sequence Item
class keyboard_item extends uvm_sequence_item;

randc bit kbclk;
rand bit kbdat;
bit [15:0] data;

`uvm_object_utils_begin(keyboard_item)
`uvm_field_int(kbclk, UVM_DEFAULT| UVM_BIN)
`uvm_field_int(kbdat, UVM_DEFAULT | UVM_BIN)
`uvm_field_int(data, UVM_NOPRINT)
`uvm_object_utils_end

function new(string name = "keyboard_item");
super.new(name);
endfunction

virtual function string my_print();
return $sformatf("kbclk = %1b kbdat = %1b data = %15b", kbclk, kbdat,data);
endfunction
endclass

// Sequence
class generator extends uvm_sequence;
`uvm_object_utils(generator)

function new(string name = "generator");
super.new(name);
endfunction

int num =80000;

virtual task body();
for (int i = 0; i < num; i++) begin
keyboard_item item = keyboard_item::type_id::create("item");
start_item(item);
item.randomize();
`uvm_info("Generator", $sformatf("Item %0d/%0d created", i + 1, num), UVM_LOW)
finish_item(item);
end
endtask
endclass

// Driver
class driver extends uvm_driver #(keyboard_item);
`uvm_component_utils(driver)

function new(string name = "driver", uvm_component parent = null);
super.new(name, parent);
endfunction

virtual keyboard_if vif;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db#(virtual keyboard_if)::get(this, "", "keyboard_vif", vif)) `uvm_fatal("Driver", "No interface.")
endfunction

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
keyboard_item item;
seq_item_port.get_next_item(item);
`uvm_info("Driver", $sformatf("%s", item.my_print()), UVM_LOW)
vif.kbclk <= item.kbclk; vif.kbdat <= item.kbdat;
@(posedge vif.clk);
seq_item_port.item_done();
end
endtask
endclass

// Monitor
class monitor extends uvm_monitor;
`uvm_component_utils(monitor)

function new(string name = "monitor", uvm_component parent = null);
super.new(name, parent);
endfunction

virtual keyboard_if vif; uvm_analysis_port #(keyboard_item) mon_analysis_port;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db#(virtual keyboard_if)::get(this, "", "keyboard_vif", vif)) `uvm_fatal("Monitor", "No interface.")
mon_analysis_port = new("mon_analysis_port", this);
endfunction

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
@(posedge vif.clk);
forever begin
keyboard_item item = keyboard_item::type_id::create("item");
@(posedge vif.clk); item.kbdat = vif.kbdat; item.kbclk = vif.kbclk; item.data = vif.data;
`uvm_info("Monitor", $sformatf("%s", item.my_print()), UVM_LOW)
mon_analysis_port.write(item);
end
endtask
endclass

// Agent
class agent extends uvm_agent;
`uvm_component_utils(agent)

function new(string name = "agent", uvm_component parent = null);
super.new(name, parent);
endfunction

driver d0;
monitor m0;
uvm_sequencer #(keyboard_item) s0;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d0 = driver::type_id::create("d0", this);
m0 = monitor::type_id::create("m0", this);
s0 = uvm_sequencer#(keyboard_item)::type_id::create("s0", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d0.seq_item_port.connect(s0.seq_item_export);
endfunction
endclass

// Scoreboard
class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

function new(string name = "scoreboard", uvm_component parent = null);
super.new(name, parent);
endfunction

uvm_analysis_imp #(keyboard_item, scoreboard) mon_analysis_imp;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon_analysis_imp = new("mon_analysis_imp", this);
endfunction

bit [15:0] check_data = 16'h0000;
bit[11:0]ps2=11'b00000000000;
bit kbclk_prev=1'b0;
bit state=1'b0;
bit[1:0] statek=2'b00;
bit[3:0] n=4'h0;

virtual function write(keyboard_item item);
    localparam make_code = 2'b00; 
    localparam break_code = 2'b01;
    localparam make_E0 = 2'b10;
case (state)	
            0: begin if (kbclk_prev&&~item.kbclk&&!item.kbdat)                 
					begin	
						if (check_data == item.data)
                   `uvm_info("Scoreboard", $sformatf("PASS! expected = %16b, got = %16b",check_data,item.data), UVM_LOW)
                    else
                   `uvm_error("Scoreboard", $sformatf("FAIL! expected = %16b, got = %16b", check_data, item.data))	
					n = 4'b1010;            
		            state = 1;            
			        ps2[10] =1'b0; 
                    end
			end
			1: begin
				if (kbclk_prev&&~item.kbclk)                         
					begin
					ps2 = {item.kbdat,ps2[10:1]};
					n = n - 1; 
					end
			
				if (n==0)                        
					begin  
						state=0;
					if (!ps2[10] || !(ps2[1]^ps2[2]^ps2[3]^ps2[4]^ps2[5]^ps2[6]^ps2[7]^ps2[8]^ps2[9]))
						ps2[8:1]=8'h00;   
    case (statek)
        make_code: begin 
            if(ps2[8:1]==8'hf0)
                statek=break_code;
            else if(ps2[8:1]==8'hE0)statek=make_E0;
            else begin 
                check_data[15:8] = 8'h00;
                check_data[7:0]=ps2[8:1];
                end
        end
        break_code: begin
                check_data[15:8]=8'hf0;
                statek=make_code;
                check_data[7:0]=ps2[8:1];
                end
         make_E0: begin
            check_data[15:8]=8'hE0;
            if(ps2[8:1]==8'hf0)
                statek=break_code;
            else begin 
                statek=make_code;
                check_data[7:0]=ps2[8:1];
            end
        end  
endcase
				end
            end
		endcase
        kbclk_prev=item.kbclk;
endfunction
endclass

class env extends uvm_env;
`uvm_component_utils(env)

function new(string name = "env", uvm_component parent = null);
super.new(name, parent);
endfunction

agent a0;
scoreboard sb0;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
a0 = agent::type_id::create("a0", this);
sb0 = scoreboard::type_id::create("sb0", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
a0.m0.mon_analysis_port.connect(sb0.mon_analysis_imp);
endfunction
endclass

// Test
class test extends uvm_test;
`uvm_component_utils(test)

function new(string name = "test", uvm_component parent = null);
super.new(name, parent);
endfunction

virtual keyboard_if vif;
env e0;
generator g0;

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db#(virtual keyboard_if)::get(this, "", "keyboard_vif", vif))
`uvm_fatal("Test", "No interface.")
e0 = env::type_id::create("e0", this);
g0 = generator::type_id::create("g0");
endfunction

virtual function void end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
vif.rst_n <= 0;
#10 vif.rst_n <= 1;
g0.start(e0.a0.s0);
phase.drop_objection(this);
endtask
endclass

// Interface
interface keyboard_if(input bit clk);
logic rst_n;
logic kbdat;
logic kbclk;
logic [15:0] data;
endinterface

// Testbench
module testbench_uvm;
reg clk;

keyboard_if dut_if (
.clk(clk)
);
keyboard dut (
.clk(clk),
.rst_n(dut_if.rst_n),
.KBDAT(dut_if.kbdat),
.KBCLK(dut_if.kbclk),
.data_out(dut_if.data)
);
initial begin
clk = 0;
forever begin
#5 clk = ~clk;
end
end
initial begin
uvm_config_db#(virtual keyboard_if)::set(null, "*", "keyboard_vif", dut_if);
run_test("test");
end
endmodule