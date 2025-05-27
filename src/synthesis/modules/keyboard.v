module keyboard 
    (
	input clk, 
    input rst_n,
    input KBDAT, 
	input KBCLK, 
    output [15:0] data_out      // podatak koji se ispisuje na sedmosegmentnom displeju
    );

    wire[7:0] data_in; 
    wire received_flag;

    ps2 ps2_inst(clk,rst_n, KBDAT, KBCLK, received_flag, data_in);
    
    localparam BREAK = 8'hf0;

    localparam make_code = 2'b00; 
    localparam break_code = 2'b01;
    localparam make_E0 = 2'b10;
               
    reg [1:0] state_reg, state_next; 
    reg [15:0] data_reg, data_next;                           

    always @(posedge clk, negedge rst_n)
        if (!rst_n)
			begin
			state_reg  <= make_code;
            data_reg <= 16'h0000;
			end
        else
			begin    
            state_reg  <= state_next;
            data_reg <= data_next;
			end
			
    always @(*) begin
        state_next = state_reg;
        data_next = data_reg;
       
     case(state_reg)

        make_code: begin 
        if(received_flag)begin
            if(data_in==BREAK)
                state_next=break_code;
            else if(data_in==8'hE0)
                state_next=make_E0;
            else begin 
                data_next[15:8] = 8'h00;
                data_next[7:0]=data_in;
                end
            end
        end
    
        break_code: begin
                if(received_flag)begin
                state_next=make_code;
                data_next[15:8]=BREAK;
                data_next[7:0] = data_in; // mozda i nije potrebno ova linija koda
                end
                end

        make_E0: begin
        if(received_flag)begin
            data_next[15:8]=8'hE0;
            if(data_in==BREAK)
                state_next=break_code;
            else begin 
                state_next=make_code;
                data_next[7:0]=data_in;
            end
        end
        end  
        
     endcase
    end 
	
    assign data_out = data_next;
	
endmodule