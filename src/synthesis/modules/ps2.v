module ps2
	(
	input clk,
	input  rst_n, 
	input KBDAT, 
	input KBCLK,  
	output reg receive_done_flag,         // flag da je podatak primljen
	output [7:0] ps2_data 
	);
	
	localparam  idle = 1'b0;
	localparam	receive  = 1'b1;
		
	reg state_reg, state_next;          
    reg KBCLK_prev_reg,KBCLK_prev_next; 
	reg [3:0] n_reg, n_next;            // counter koji prati broj bita podatka (za siftovanje)
	reg [10:0] data_reg, data_next;          // registar u kojem cemo da siftujemo podatak
	wire neg_edge;                   
	
	assign neg_edge = KBCLK_prev_reg && ~KBCLK;   //PROVERI OVO DA LI JE DOBRO!!!!
	
	always @(posedge clk, negedge rst_n)
		if (!rst_n)
			begin
			state_reg <= idle;
			n_reg <= 0;
			data_reg <= 11'b00000000000;
			KBCLK_prev_reg<=1'b0;
			end
		else
			begin
			state_reg <= state_next;
			n_reg <= n_next;
			data_reg <= data_next;
			KBCLK_prev_reg<=KBCLK_prev_next;
			end
	
	
	always @(*) begin
		
		state_next = state_reg;
		n_next = n_reg;
		data_next = data_reg;
		receive_done_flag = 1'b0;
		
		case (state_reg)
			
			idle: begin
				if (neg_edge&&!KBDAT)                 // start bit je primljen
					begin
					n_next = 4'b1010;             // postavljamo counter na 10 za ostalih 10 bita(8 bita podatka, 1 parity bit i 1 stop bit)
					state_next = receive;              // prelazimo u receive stanje
					data_next[10] = 1'b0;  // ubacivanje u data registar siftovanjem udesno, proveri da li je tacno ovo
					end
			end
			receive: begin
				if (neg_edge)                         // na silaznu ivicu citamo podatak
					begin
					data_next = {KBDAT, data_reg[10:1]};  // ubacivanje u data registar siftovanjem udesno, proveri da li je tacno ovo
					n_next = n_reg - 1; 
					end
			
				if (n_reg==0)                               // primili smo svih 10 bitova
					begin         
					state_next = idle;
					if (!data_next[10] || !(data_next[1]^data_next[2]^data_next[3]^data_next[4]^data_next[5]^data_next[6]^data_next[7]^data_next[8]^data_next[9]))
						data_next[8:1]=8'h00;   
					receive_done_flag = 1'b1;                         
					end
				end
		endcase
		KBCLK_prev_next=KBCLK;
	end
		
	assign ps2_data =data_next[8:1]; 

endmodule