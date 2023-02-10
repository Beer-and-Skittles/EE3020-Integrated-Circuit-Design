module factor (
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [11:0] i_n,
	output [3:0]  o_p2,
	output [2:0]  o_p3,
	output [2:0]  o_p5,
	output        o_out_valid,
	output [50:0] number
);

	wire [50:0] numbers[5:0];
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] ;

	wire valid_3, valid_5;
	AN2 and0(.Z(o_out_valid), .A(valid_3), .B(valid_5), .number(numbers[0]));

	FACT2 fact_2(.i_n(i_n), .o_out(o_p2), .number(numbers[1]));
	FACT3 fact_3(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_n(i_n), .o_out(o_p3), .o_out_valid(valid_3), .number(numbers[2]));
	FACT5 fact_5(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_n(i_n), .o_out(o_p5), .o_out_valid(valid_5), .number(numbers[3]));

endmodule



module FACT2(
	input  [11:0] i_n,
	output [3:0]  o_out,
	output [50:0] number
);

	// set up
	wire [50:0] numbers [25:0];
	wire [10:0] factor_of_2_pow;
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10]+ numbers[11]+ numbers[12]+ numbers[13]+ numbers[14]+
	numbers[15]+ numbers[16]+ numbers[17]+ numbers[18]+ numbers[19]+
	numbers[20]+ numbers[21]+ numbers[22]+ numbers[23]+ numbers[24]+
	numbers[25];

	// is factor of 2^x > factor_of_2_pow[x-1] == 0
	assign factor_of_2_pow[0] = i_n[0];
	OR2 or0(.Z(factor_of_2_pow[1]),  .A(factor_of_2_pow[0]), .B(i_n[1]),  .number(numbers[0]));
	OR2 or1(.Z(factor_of_2_pow[2]),  .A(factor_of_2_pow[1]), .B(i_n[2]),  .number(numbers[1]));
	OR2 or2(.Z(factor_of_2_pow[3]),  .A(factor_of_2_pow[2]), .B(i_n[3]),  .number(numbers[2]));
	OR2 or3(.Z(factor_of_2_pow[4]),  .A(factor_of_2_pow[3]), .B(i_n[4]),  .number(numbers[3]));
	OR2 or4(.Z(factor_of_2_pow[5]),  .A(factor_of_2_pow[4]), .B(i_n[5]),  .number(numbers[4]));
	OR2 or5(.Z(factor_of_2_pow[6]),  .A(factor_of_2_pow[5]), .B(i_n[6]),  .number(numbers[5]));
	OR2 or6(.Z(factor_of_2_pow[7]),  .A(factor_of_2_pow[6]), .B(i_n[7]),  .number(numbers[6]));
	OR2 or7(.Z(factor_of_2_pow[8]),  .A(factor_of_2_pow[7]), .B(i_n[8]),  .number(numbers[7]));
	OR2 or8(.Z(factor_of_2_pow[9]),  .A(factor_of_2_pow[8]), .B(i_n[9]),  .number(numbers[8]));
	OR2 or9(.Z(factor_of_2_pow[10]), .A(factor_of_2_pow[9]), .B(i_n[10]), .number(numbers[9]));

	// determine 4 digits
	wire [15:0] buffers;
	assign o_out[3] = buffers[0];
	assign o_out[2] = buffers[1];
	assign o_out[1] = buffers[6];
	assign o_out[0] = buffers[15];

	IV  not0(.Z(buffers[0]), .A(factor_of_2_pow[7]), .number(numbers[10]));

	NR2 nor0(.Z(buffers[1]), .A(factor_of_2_pow[3]), .B(buffers[0]), .number(numbers[11]));

	IV  not1(.Z(buffers[2]), .A(factor_of_2_pow[5]), .number(numbers[12]));
	IV  not2(.Z(buffers[3]), .A(factor_of_2_pow[9]), .number(numbers[13]));
	NR2 nor1(.Z(buffers[4]), .A(factor_of_2_pow[3]), .B(buffers[2]), .number(numbers[14]));
	NR2 nor2(.Z(buffers[5]), .A(factor_of_2_pow[7]), .B(buffers[3]), .number(numbers[15]));
	NR3 nor3(.Z(buffers[6]), .A(factor_of_2_pow[1]), .B(buffers[4]), .C(buffers[5]), .number(numbers[16]));

	EO  xor0(.Z(buffers[7]), .A(factor_of_2_pow[0]), .B(factor_of_2_pow[1]), .number(numbers[17]));
	EO  xor1(.Z(buffers[8]), .A(factor_of_2_pow[2]), .B(factor_of_2_pow[3]), .number(numbers[18]));
	EO  xor2(.Z(buffers[9]), .A(factor_of_2_pow[4]), .B(factor_of_2_pow[5]), .number(numbers[19]));
	EO  xor3(.Z(buffers[10]),.A(factor_of_2_pow[6]), .B(factor_of_2_pow[7]), .number(numbers[20]));
	EO  xor4(.Z(buffers[11]),.A(factor_of_2_pow[8]), .B(factor_of_2_pow[9]), .number(numbers[21]));
	IV  not3(.Z(buffers[12]),.A(factor_of_2_pow[10]),.number(numbers[22]));

	NR3 nor4(.Z(buffers[13]), .A(buffers[7]),  .B(buffers[8]),  .C(buffers[9]),  .number(numbers[23]));
	NR3 nor5(.Z(buffers[14]), .A(buffers[10]), .B(buffers[11]), .C(buffers[12]), .number(numbers[24]));
	ND2 nnd0(.Z(buffers[15]), .A(buffers[13]), .B(buffers[14]), .number(numbers[25]));

endmodule

module FACT3(
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [11:0] i_n,
	output [2: 0] o_out,
	output o_out_valid,
	output [50:0] number
);
	// set up
	wire [50:0] numbers[84:0];
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10] + numbers[11] + numbers[12] + numbers[13] + numbers[14] +
	numbers[15] + numbers[16] + numbers[17] + numbers[18] + numbers[19] +
	numbers[20] + numbers[21] + numbers[22] + numbers[23] + numbers[24] +
	numbers[25] + numbers[26] + numbers[27] + numbers[28] + numbers[29] +
	numbers[30] + numbers[31] + numbers[32] + numbers[33] + numbers[34] +
	numbers[35] + numbers[36] + numbers[37] + numbers[38] + numbers[39] +
	numbers[40] + numbers[41] + numbers[42] + numbers[43] + numbers[44] +
	numbers[45] + numbers[46] + numbers[47] + numbers[48] + numbers[49] +
	numbers[50] + numbers[51] + numbers[52] + numbers[53] + numbers[54] +
	numbers[55] + numbers[56] + numbers[57] + numbers[58] + numbers[59] +
	numbers[60] + numbers[61] + numbers[62] + numbers[63] + numbers[64] +
	numbers[65] + numbers[66] + numbers[67] + numbers[68] + numbers[69] +
	numbers[70] + numbers[71] + numbers[72] + numbers[73] + numbers[74] +
	numbers[75] + numbers[76] + numbers[77] + numbers[78] + numbers[79] +
	numbers[80] ;

	wire [11:0] neg_3    = 12'b1111_1111_1101;
	wire [11:0] neg_9    = 12'b1111_1111_0111;
	wire [11:0] neg_27   = 12'b1111_1110_0101;
	wire [11:0] neg_81   = 12'b1111_1010_1111;
	wire [11:0] neg_243  = 12'b1111_0000_1101;
	wire [11:0] neg_729  = 12'b1101_0010_0111;

	wire [11:0] pos_3    = 12'b0000_0000_0011;
	wire [11:0] pos_9    = 12'b0000_0000_1001;
	wire [11:0] pos_27   = 12'b0000_0001_1011;
	wire [11:0] pos_81   = 12'b0000_0101_0001;
	wire [11:0] pos_243  = 12'b0000_1111_0011;
	wire [11:0] pos_729  = 12'b0010_1101_1001;
	wire [11:0] pos_2287 = 12'b1000_1110_1111;

	wire high = 1'b1;
	wire low  = 1'b0;

	// determine if should do division
	// returns true if i_n is geq than divisor, that is, when division should be performed
	wire [5:0] geq;
	wire [5:0] geq_done;
	GEQ geq0(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_3), .o_geq(geq[0]), .o_out_valid(geq_done[0]), .number(numbers[0])); 
	GEQ geq1(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_9), .o_geq(geq[1]), .o_out_valid(geq_done[1]), .number(numbers[1])); 
	GEQ geq2(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_27), .o_geq(geq[2]), .o_out_valid(geq_done[2]), .number(numbers[2])); 
	GEQ geq3(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_81), .o_geq(geq[3]), .o_out_valid(geq_done[3]), .number(numbers[3])); 
	GEQ geq4(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_243), .o_geq(geq[4]), .o_out_valid(geq_done[4]), .number(numbers[4])); 
	GEQ geq5(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_729), .o_geq(geq[5]), .o_out_valid(geq_done[5]), .number(numbers[5])); 

	// geq is gated 


	wire [5:0] geq_gated_n;
	IV not0(.Z(geq_gated_n[0]), .A(geq[0]), .number(numbers[6]));
	IV not1(.Z(geq_gated_n[1]), .A(geq[1]), .number(numbers[7]));
	IV not2(.Z(geq_gated_n[2]), .A(geq[2]), .number(numbers[8]));
	IV not3(.Z(geq_gated_n[3]), .A(geq[3]), .number(numbers[9]));
	IV not4(.Z(geq_gated_n[4]), .A(geq[4]), .number(numbers[10]));
	IV not5(.Z(geq_gated_n[5]), .A(geq[5]), .number(numbers[11]));

	// for calculating division
	wire [4 :0] div_rst_n;				// INPUT should be 1 except when previous divbl is done && is changed through calculation, change to zero for a moment
	wire [11:0] div [4:0];				// INPUT should be n1, but when previous divbl is done, change to previous divbl
	wire [5 :0] div_out_valid;			// OUTPUT 	
	wire [11:0] div_remainder [5:0];	// OUTPUT	 
	wire [5 :0] div_factor;
			
	wire [5 :0] done_buf; 					// is done_buf when 1) divbl done_buf OR 2) divisor is too large
	OR2 or0(.Z(done_buf[0]), .A(geq_gated_n[0]), .B(div_out_valid[0]), .number(numbers[12]));
	OR2 or1(.Z(done_buf[1]), .A(geq_gated_n[1]), .B(div_out_valid[1]), .number(numbers[13]));
	OR2 or2(.Z(done_buf[2]), .A(geq_gated_n[2]), .B(div_out_valid[2]), .number(numbers[14]));
	OR2 or3(.Z(done_buf[3]), .A(geq_gated_n[3]), .B(div_out_valid[3]), .number(numbers[15]));
	OR2 or4(.Z(done_buf[4]), .A(geq_gated_n[4]), .B(div_out_valid[4]), .number(numbers[16]));
	OR2 or5(.Z(done_buf[5]), .A(geq_gated_n[5]), .B(div_out_valid[5]), .number(numbers[17]));
	
	wire [5:0] done_buf2;
	AN2 dex0(.Z(done_buf2[0]), .A(geq_done[0]), .B(done_buf[0]), .number(numbers[18]));
	AN2 dex1(.Z(done_buf2[1]), .A(geq_done[1]), .B(done_buf[1]), .number(numbers[19]));
	AN2 dex2(.Z(done_buf2[2]), .A(geq_done[2]), .B(done_buf[2]), .number(numbers[20]));
	AN2 dex3(.Z(done_buf2[3]), .A(geq_done[3]), .B(done_buf[3]), .number(numbers[21]));
	AN2 dex4(.Z(done_buf2[4]), .A(geq_done[4]), .B(done_buf[4]), .number(numbers[22]));
	AN2 dex5(.Z(done_buf2[5]), .A(geq_done[5]), .B(done_buf[5]), .number(numbers[23]));
	
	wire [5:0] done_buf3;
	FD1 asd0(.Q(done_buf3[0]), .D(done_buf2[0]), .CLK(clk), .RESET(rst_n), .number(numbers[24]));
	FD1 asd1(.Q(done_buf3[1]), .D(done_buf2[1]), .CLK(clk), .RESET(rst_n), .number(numbers[25]));
	FD1 asd2(.Q(done_buf3[2]), .D(done_buf2[2]), .CLK(clk), .RESET(rst_n), .number(numbers[26]));
	FD1 asd3(.Q(done_buf3[3]), .D(done_buf2[3]), .CLK(clk), .RESET(rst_n), .number(numbers[27]));
	FD1 asd4(.Q(done_buf3[4]), .D(done_buf2[4]), .CLK(clk), .RESET(rst_n), .number(numbers[28]));
	FD1 asd5(.Q(done_buf3[5]), .D(done_buf2[5]), .CLK(clk), .RESET(rst_n), .number(numbers[29]));
	
	wire [5:0] done;
	FD2 asxd0(.Q(done[0]), .D(high), .CLK(done_buf3[0]), .RESET(rst_n), .number(numbers[30]));
	FD2 asxd1(.Q(done[1]), .D(high), .CLK(done_buf3[1]), .RESET(rst_n), .number(numbers[31]));
	FD2 asxd2(.Q(done[2]), .D(high), .CLK(done_buf3[2]), .RESET(rst_n), .number(numbers[32]));
	FD2 asxd3(.Q(done[3]), .D(high), .CLK(done_buf3[3]), .RESET(rst_n), .number(numbers[33]));
	FD2 asxd4(.Q(done[4]), .D(high), .CLK(done_buf3[4]), .RESET(rst_n), .number(numbers[34]));
	FD2 asxd5(.Q(done[5]), .D(high), .CLK(done_buf3[5]), .RESET(rst_n), .number(numbers[35]));
	
	// DIVBL fail

	// FD1 fdc(.Q(i_in_valid_prev), .D(i_in_valid), .CLK(clk), .RESET(rst_n), .number(numbers[67]));
	wire div_neg;
	DIVBL div5(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_n(i_n), .i_d(neg_729), 
	.o_out_valid(div_out_valid[5]), .o_is_factor(div_factor[5]), .o_remainder(div_remainder[5]), .number(numbers[36]));

	MUX11B mux0(.Z(div[4]), .A(i_n), .B(div_remainder[5]), .CTRL(geq[5]), .number(numbers[37]));
	DIVBL div4(.clk(clk), .rst_n(done[5]), .i_in_valid(i_in_valid), .i_n(div[4]), .i_d(neg_243), 
	.o_out_valid(div_out_valid[4]), .o_is_factor(div_factor[4]), .o_remainder(div_remainder[4]), .number(numbers[38]));

	MUX11B mux1(.Z(div[3]), .A(i_n), .B(div_remainder[4]), .CTRL(geq[4]), .number(numbers[39]));
	DIVBL div3(.clk(clk), .rst_n(done[4]), .i_in_valid(i_in_valid), .i_n(div[3]), .i_d(neg_81),  
	.o_out_valid(div_out_valid[3]), .o_is_factor(div_factor[3]), .o_remainder(div_remainder[3]), .number(numbers[40]));

	MUX11B mux2(.Z(div[2]), .A(i_n), .B(div_remainder[3]), .CTRL(geq[3]), .number(numbers[41]));
	DIVBL div2(.clk(clk), .rst_n(done[3]), .i_in_valid(i_in_valid), .i_n(div[2]), .i_d(neg_27),  
	.o_out_valid(div_out_valid[2]), .o_is_factor(div_factor[2]), .o_remainder(div_remainder[2]), .number(numbers[42]));

	MUX11B mux3(.Z(div[1]), .A(i_n), .B(div_remainder[2]), .CTRL(geq[2]), .number(numbers[43]));
	DIVBL div1(.clk(clk), .rst_n(done[2]), .i_in_valid(i_in_valid), .i_n(div[1]), .i_d(neg_9),   
	.o_out_valid(div_out_valid[1]), .o_is_factor(div_factor[1]), .o_remainder(div_remainder[1]), .number(numbers[44]));
	
	MUX11B mux4(.Z(div[0]), .A(i_n), .B(div_remainder[1]), .CTRL(geq[1]), .number(numbers[45]));
	DIVBL div0(.clk(clk), .rst_n(done[1]), .i_in_valid(i_in_valid), .i_n(div[0]), .i_d(neg_3),   
	.o_out_valid(div_out_valid[0]), .o_is_factor(div_factor[0]), .o_remainder(div_remainder[0]), .number(numbers[46]));

	wire [6 :0] factor_of_3_pow;
	NEQ   neq0(.i_a(i_n), .i_b(pos_2287), .o_neq(factor_of_3_pow[6]), .number(numbers[47]));

	wire [5:0] div_factor_n, buffer_divn;
	IV lic0(.Z(buffer_divn[0]), .A(div_factor[0]), .number(numbers[48]));
	IV lic1(.Z(buffer_divn[1]), .A(div_factor[1]), .number(numbers[49]));
	IV lic2(.Z(buffer_divn[2]), .A(div_factor[2]), .number(numbers[50]));
	IV lic3(.Z(buffer_divn[3]), .A(div_factor[3]), .number(numbers[51]));
	IV lic4(.Z(buffer_divn[4]), .A(div_factor[4]), .number(numbers[52]));
	IV lic5(.Z(buffer_divn[5]), .A(div_factor[5]), .number(numbers[53]));
	OR2 pco0(.Z(div_factor_n[0]), .A(geq_gated_n[0]), .B(buffer_divn[0]), .number(numbers[54]));
	OR2 pco1(.Z(div_factor_n[1]), .A(geq_gated_n[1]), .B(buffer_divn[1]), .number(numbers[55]));
	OR2 pco2(.Z(div_factor_n[2]), .A(geq_gated_n[2]), .B(buffer_divn[2]), .number(numbers[56]));
	OR2 pco3(.Z(div_factor_n[3]), .A(geq_gated_n[3]), .B(buffer_divn[3]), .number(numbers[57]));
	OR2 pco4(.Z(div_factor_n[4]), .A(geq_gated_n[4]), .B(buffer_divn[4]), .number(numbers[58]));
	OR2 pco5(.Z(div_factor_n[5]), .A(geq_gated_n[5]), .B(buffer_divn[5]), .number(numbers[59]));

	FD2 xoec0(.Q(factor_of_3_pow[0]), .D(div_factor_n[0]), .CLK(done[0]), .RESET(rst_n), .number(numbers[60]));
	FD2 xoec1(.Q(factor_of_3_pow[1]), .D(div_factor_n[1]), .CLK(done[1]), .RESET(rst_n), .number(numbers[61]));
	FD2 xoec2(.Q(factor_of_3_pow[2]), .D(div_factor_n[2]), .CLK(done[2]), .RESET(rst_n), .number(numbers[62]));
	FD2 xoec3(.Q(factor_of_3_pow[3]), .D(div_factor_n[3]), .CLK(done[3]), .RESET(rst_n), .number(numbers[63]));
	FD2 xoec4(.Q(factor_of_3_pow[4]), .D(div_factor_n[4]), .CLK(done[4]), .RESET(rst_n), .number(numbers[64]));
	FD2 xoec5(.Q(factor_of_3_pow[5]), .D(div_factor_n[5]), .CLK(done[5]), .RESET(rst_n), .number(numbers[65]));
	
	
	// determine 3 digits
	wire [9:0] buffers;
	IV  not6(.Z(buffers[0]), .A(factor_of_3_pow[3]), .number(numbers[66]));
	IV  not7(.Z(buffers[1]), .A(factor_of_3_pow[1]), .number(numbers[67]));
	ND2 nnd0(.Z(buffers[2]), .A(factor_of_3_pow[3]), .B(buffers[1]), .number(numbers[68])); 
	ND2 nnd1(.Z(buffers[3]), .A(factor_of_3_pow[5]), .B(buffers[2]), .number(numbers[69]));

	EO  xor0(.Z(buffers[4]), .A(factor_of_3_pow[1]), .B(factor_of_3_pow[2]), .number(numbers[70]));
	EO  xor1(.Z(buffers[5]), .A(factor_of_3_pow[3]), .B(factor_of_3_pow[4]), .number(numbers[71]));
	EO  xor2(.Z(buffers[6]), .A(factor_of_3_pow[5]), .B(factor_of_3_pow[6]), .number(numbers[72]));
	NR4 norasd(.Z(buffers[7]), .A(factor_of_3_pow[0]), .B(buffers[4]), .C(buffers[5]), .D(buffers[6]), .number(numbers[73]));

	// determine o_out_valid
	ND3 nnd2(.Z(buffers[8]), .A(done[0]), .B(done[1]), .C(done[2]), .number(numbers[74]));
	ND3 nnd3(.Z(buffers[9]), .A(done[3]), .B(done[4]), .C(done[5]), .number(numbers[75]));
	NR2 norqwer3(.Z(o_out_valid), .A(buffers[8]), .B(buffers[9]), .number(numbers[76]));

	// wire [2:0] test_o;
	// assign o_out = test_o;
	wire change_o_out;
	AN2 ds(.Z(change_o_out), .A(clk), .B(o_out_valid), .number(numbers[77]));
	FD2 dxi0(.Q(o_out[2]), .D(buffers[0]), .CLK(change_o_out), .RESET(rst_n), .number(numbers[78]));
	FD2 dxi1(.Q(o_out[1]), .D(buffers[3]), .CLK(change_o_out), .RESET(rst_n), .number(numbers[79]));
	FD2 dxi2(.Q(o_out[0]), .D(buffers[7]), .CLK(change_o_out), .RESET(rst_n), .number(numbers[80]));
endmodule

module FACT5(
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [11:0] i_n,
	output [2: 0] o_out,
	output o_out_valid,
	output [50:0] number
);
	// set up
	wire [50:0] numbers[84:0];
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10] + numbers[11] + numbers[12] + numbers[13] + numbers[14] +
	numbers[15] + numbers[16] + numbers[17] + numbers[18] + numbers[19] +
	numbers[20] + numbers[21] + numbers[22] + numbers[23] + numbers[24] +
	numbers[25] + numbers[26] + numbers[27] + numbers[28] + numbers[29] +
	numbers[30] + numbers[31] + numbers[32] + numbers[33] + numbers[34] +
	numbers[35] + numbers[36] + numbers[37] + numbers[38] + numbers[39] +
	numbers[40] + numbers[41] + numbers[42] + numbers[43] + numbers[44] +
	numbers[45] + numbers[46] + numbers[47] + numbers[48] + numbers[49] +
	numbers[50] + numbers[51] + numbers[52] + numbers[53] ;

	wire [11:0] neg_3    = 12'b1111_1111_1011;
	wire [11:0] neg_9    = 12'b1111_1110_0111;
	wire [11:0] neg_27   = 12'b1111_1000_0011;
	wire [11:0] neg_81   = 12'b1101_1000_1111;

	wire [11:0] pos_3    = 12'b0000_0000_0101;
	wire [11:0] pos_9    = 12'b0000_0001_1001;
	wire [11:0] pos_27   = 12'b0000_0111_1101;
	wire [11:0] pos_81   = 12'b0000_0111_0001;
	wire [11:0] pos_2287 = 12'b1100_0011_0101;

	wire high = 1'b1;
	wire low  = 1'b0;

	// determine if should do division
	// returns true if i_n is geq than divisor, that is, when division should be performed
	wire [5:0] geq;
	wire [5:0] geq_done;
	GEQ geq0(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_3), .o_geq(geq[0]), .o_out_valid(geq_done[0]), .number(numbers[0])); 
	GEQ geq1(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_9), .o_geq(geq[1]), .o_out_valid(geq_done[1]), .number(numbers[1])); 
	GEQ geq2(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_27), .o_geq(geq[2]), .o_out_valid(geq_done[2]), .number(numbers[2])); 
	GEQ geq3(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_a(i_n), .i_b(pos_81), .o_geq(geq[3]), .o_out_valid(geq_done[3]), .number(numbers[3])); 
	

	wire [5:0] geq_gated_n;
	IV not0(.Z(geq_gated_n[0]), .A(geq[0]), .number(numbers[4]));
	IV not1(.Z(geq_gated_n[1]), .A(geq[1]), .number(numbers[5]));
	IV not2(.Z(geq_gated_n[2]), .A(geq[2]), .number(numbers[6]));
	IV not3(.Z(geq_gated_n[3]), .A(geq[3]), .number(numbers[7]));

	// for calculating division
	wire [4 :0] div_rst_n;				// INPUT should be 1 except when previous divbl is done && is changed through calculation, change to zero for a moment
	wire [11:0] div [4:0];				// INPUT should be n1, but when previous divbl is done, change to previous divbl
	wire [5 :0] div_out_valid;			// OUTPUT 	
	wire [11:0] div_remainder [5:0];	// OUTPUT	 
	wire [5 :0] div_factor;
			
	wire [5 :0] done_buf; 					// is done_buf when 1) divbl done_buf OR 2) divisor is too large
	OR2 or0(.Z(done_buf[0]), .A(geq_gated_n[0]), .B(div_out_valid[0]), .number(numbers[8]));
	OR2 or1(.Z(done_buf[1]), .A(geq_gated_n[1]), .B(div_out_valid[1]), .number(numbers[9]));
	OR2 or2(.Z(done_buf[2]), .A(geq_gated_n[2]), .B(div_out_valid[2]), .number(numbers[10]));
	OR2 or3(.Z(done_buf[3]), .A(geq_gated_n[3]), .B(div_out_valid[3]), .number(numbers[11]));
	
	wire [5:0] done_buf2;
	AN2 dex0(.Z(done_buf2[0]), .A(geq_done[0]), .B(done_buf[0]), .number(numbers[12]));
	AN2 dex1(.Z(done_buf2[1]), .A(geq_done[1]), .B(done_buf[1]), .number(numbers[13]));
	AN2 dex2(.Z(done_buf2[2]), .A(geq_done[2]), .B(done_buf[2]), .number(numbers[14]));
	AN2 dex3(.Z(done_buf2[3]), .A(geq_done[3]), .B(done_buf[3]), .number(numbers[15]));
	
	wire [5:0] done_buf3;
	FD1 asd0(.Q(done_buf3[0]), .D(done_buf2[0]), .CLK(clk), .RESET(rst_n), .number(numbers[16]));
	FD1 asd1(.Q(done_buf3[1]), .D(done_buf2[1]), .CLK(clk), .RESET(rst_n), .number(numbers[17]));
	FD1 asd2(.Q(done_buf3[2]), .D(done_buf2[2]), .CLK(clk), .RESET(rst_n), .number(numbers[18]));
	FD1 asd3(.Q(done_buf3[3]), .D(done_buf2[3]), .CLK(clk), .RESET(rst_n), .number(numbers[19]));
	
	wire [5:0] done;
	FD2 asxd0(.Q(done[0]), .D(high), .CLK(done_buf3[0]), .RESET(rst_n), .number(numbers[20]));
	FD2 asxd1(.Q(done[1]), .D(high), .CLK(done_buf3[1]), .RESET(rst_n), .number(numbers[21]));
	FD2 asxd2(.Q(done[2]), .D(high), .CLK(done_buf3[2]), .RESET(rst_n), .number(numbers[22]));
	FD2 asxd3(.Q(done[3]), .D(high), .CLK(done_buf3[3]), .RESET(rst_n), .number(numbers[23]));
	
	// DIVBL fail
	wire div_neg;
	DIVBL div5(.clk(clk), .rst_n(rst_n), .i_in_valid(i_in_valid), .i_n(i_n), .i_d(neg_81), 
	.o_out_valid(div_out_valid[3]), .o_is_factor(div_factor[3]), .o_remainder(div_remainder[3]), .number(numbers[24]));

	MUX11B mux2(.Z(div[2]), .A(i_n), .B(div_remainder[3]), .CTRL(geq[3]), .number(numbers[25]));
	DIVBL div2(.clk(clk), .rst_n(done[3]), .i_in_valid(i_in_valid), .i_n(div[2]), .i_d(neg_27),  
	.o_out_valid(div_out_valid[2]), .o_is_factor(div_factor[2]), .o_remainder(div_remainder[2]), .number(numbers[26]));

	MUX11B mux3(.Z(div[1]), .A(i_n), .B(div_remainder[2]), .CTRL(geq[2]), .number(numbers[27]));
	DIVBL div1(.clk(clk), .rst_n(done[2]), .i_in_valid(i_in_valid), .i_n(div[1]), .i_d(neg_9),   
	.o_out_valid(div_out_valid[1]), .o_is_factor(div_factor[1]), .o_remainder(div_remainder[1]), .number(numbers[28]));
	
	MUX11B mux4(.Z(div[0]), .A(i_n), .B(div_remainder[1]), .CTRL(geq[1]), .number(numbers[29]));
	DIVBL div0(.clk(clk), .rst_n(done[1]), .i_in_valid(i_in_valid), .i_n(div[0]), .i_d(neg_3),   
	.o_out_valid(div_out_valid[0]), .o_is_factor(div_factor[0]), .o_remainder(div_remainder[0]), .number(numbers[30]));

	wire [6 :0] factor_of_3_pow;
	NEQ   neq0(.i_a(i_n), .i_b(pos_2287), .o_neq(factor_of_3_pow[4]), .number(numbers[31]));

	wire [5:0] div_factor_n, buffer_divn;
	IV lic0(.Z(buffer_divn[0]), .A(div_factor[0]), .number(numbers[32]));
	IV lic1(.Z(buffer_divn[1]), .A(div_factor[1]), .number(numbers[33]));
	IV lic2(.Z(buffer_divn[2]), .A(div_factor[2]), .number(numbers[34]));
	IV lic3(.Z(buffer_divn[3]), .A(div_factor[3]), .number(numbers[35]));

	OR2 pco0(.Z(div_factor_n[0]), .A(geq_gated_n[0]), .B(buffer_divn[0]), .number(numbers[36]));
	OR2 pco1(.Z(div_factor_n[1]), .A(geq_gated_n[1]), .B(buffer_divn[1]), .number(numbers[37]));
	OR2 pco2(.Z(div_factor_n[2]), .A(geq_gated_n[2]), .B(buffer_divn[2]), .number(numbers[38]));
	OR2 pco3(.Z(div_factor_n[3]), .A(geq_gated_n[3]), .B(buffer_divn[3]), .number(numbers[39]));

	FD2 xoec0(.Q(factor_of_3_pow[0]), .D(div_factor_n[0]), .CLK(done[0]), .RESET(rst_n), .number(numbers[40]));
	FD2 xoec1(.Q(factor_of_3_pow[1]), .D(div_factor_n[1]), .CLK(done[1]), .RESET(rst_n), .number(numbers[41]));
	FD2 xoec2(.Q(factor_of_3_pow[2]), .D(div_factor_n[2]), .CLK(done[2]), .RESET(rst_n), .number(numbers[42]));
	FD2 xoec3(.Q(factor_of_3_pow[3]), .D(div_factor_n[3]), .CLK(done[3]), .RESET(rst_n), .number(numbers[43]));

	// determine 5 digits
	wire [4:0] buffers;
	IV  notsd(.Z(buffers[0]), .A(factor_of_3_pow[3]), .number(numbers[44]));
	NR2 nor0(.Z(buffers[1]), .A(factor_of_3_pow[1]), .B(buffers[0]), .number(numbers[45]));

	EO  xor0(.Z(buffers[2]), .A(factor_of_3_pow[1]), .B(factor_of_3_pow[2]), .number(numbers[46]));
	EO  xor1(.Z(buffers[3]), .A(factor_of_3_pow[3]), .B(factor_of_3_pow[4]), .number(numbers[47]));
	NR3 nor1(.Z(buffers[4]), .A(factor_of_3_pow[0]), .B(buffers[2]), .C(buffers[3]), .number(numbers[48]));

	// determine o_out_valid
	AN4 and0(.Z(o_out_valid), .A(done[0]), .B(done[1]), .C(done[2]), .D(done[3]), .number(numbers[49]));

	wire change_o_out;
	AN2 ds(.Z(change_o_out), .A(clk), .B(o_out_valid), .number(numbers[50]));
	FD2 dxi0(.Q(o_out[2]), .D(buffers[0]), .CLK(change_o_out), .RESET(rst_n), .number(numbers[51]));
	FD2 dxi1(.Q(o_out[1]), .D(buffers[1]), .CLK(change_o_out), .RESET(rst_n), .number(numbers[52]));
	FD2 dxi2(.Q(o_out[0]), .D(buffers[4]), .CLK(change_o_out), .RESET(rst_n), .number(numbers[53]));
endmodule

module NEQ(
	input  [11:0] i_a,
	input  [11:0] i_b,
	output o_neq,
	output [50:0] number
);
	// set up numbers
	wire [50:0] numbers [16:0]; 
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10]+ numbers[11]+ numbers[12]+ numbers[13]+ numbers[14]+
	numbers[15]+ numbers[16];
	// assign numbers[12] = 0;

	// comparison by bit
	wire [11:0] exact_val;
	EO xor0(.Z(exact_val[0]),  .A(i_a[0]),  .B(i_b[0]),  .number(numbers[0]));
	EO xor1(.Z(exact_val[1]),  .A(i_a[1]),  .B(i_b[1]),  .number(numbers[1]));
	EO xor2(.Z(exact_val[2]),  .A(i_a[2]),  .B(i_b[2]),  .number(numbers[2]));
	EO xor3(.Z(exact_val[3]),  .A(i_a[3]),  .B(i_b[3]),  .number(numbers[3]));
	EO xor4(.Z(exact_val[4]),  .A(i_a[4]),  .B(i_b[4]),  .number(numbers[4]));
	EO xor5(.Z(exact_val[5]),  .A(i_a[5]),  .B(i_b[5]),  .number(numbers[5]));
	EO xor6(.Z(exact_val[6]),  .A(i_a[6]),  .B(i_b[6]),  .number(numbers[6]));
	EO xor7(.Z(exact_val[7]),  .A(i_a[7]),  .B(i_b[7]),  .number(numbers[7]));
	EO xor8(.Z(exact_val[8]),  .A(i_a[8]),  .B(i_b[8]),  .number(numbers[8]));
	EO xor9(.Z(exact_val[9]),  .A(i_a[9]),  .B(i_b[9]),  .number(numbers[9]));
	EO xora(.Z(exact_val[10]), .A(i_a[10]), .B(i_b[10]), .number(numbers[10]));
	EO xorb(.Z(exact_val[11]), .A(i_a[11]), .B(i_b[11]), .number(numbers[11]));

	// o_neq = all digits are same
	wire [3:0] buffers;
	NR3 nor0(.Z(buffers[0]), .A(exact_val[0]), .B(exact_val[1]),  .C(exact_val[2]),  .number(numbers[12]));
	NR3 nor1(.Z(buffers[1]), .A(exact_val[3]), .B(exact_val[4]),  .C(exact_val[5]),  .number(numbers[13]));
	NR3 nor2(.Z(buffers[2]), .A(exact_val[6]), .B(exact_val[7]),  .C(exact_val[8]),  .number(numbers[14]));
	NR3 nor3(.Z(buffers[3]), .A(exact_val[9]), .B(exact_val[10]), .C(exact_val[11]), .number(numbers[15]));
	ND4 nnd0(.Z(o_neq),      .A(buffers[0]),   .B(buffers[1]),    .C(buffers[2]),    .D(buffers[3]),    .number(numbers[16]));

endmodule

module DIVBL(
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [11:0] i_n,
	input  [11:0] i_d,
	output o_out_valid,
	output o_is_factor,
	output [11:0] o_remainder,
	output [50:0] number
);
	wire low  = 1'b0;
	wire high = 1'b1;

	wire [50:0] numbers [220:0];
	wire [11:0] div;
	wire [11:0] sum_low, sum_high, sum, sum_gated;
	wire [11:0] co_low, co_high, co, co_gated;
	wire [11:0] gen, prop;

	// assign o_remainder = sum_gated;
	assign number = 
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10] + numbers[11] + numbers[12] + numbers[13] + numbers[14] +
	numbers[15] + numbers[16] + numbers[17] + numbers[18] + numbers[19] +
	numbers[20] + numbers[21] + numbers[22] + numbers[23] + numbers[24] +
	numbers[25] + numbers[26] + numbers[27] + numbers[28] + numbers[29] +
	numbers[30] + numbers[31] + numbers[32] + numbers[33] + numbers[34] +
	numbers[35] + numbers[36] + numbers[37] + numbers[38] + numbers[39] +
	numbers[40] + numbers[41] + numbers[42] + numbers[43] + numbers[44] +
	numbers[45] + numbers[46] + numbers[47] + numbers[48] + numbers[49] +
	numbers[50] + numbers[51] + numbers[52] + numbers[53] + numbers[54] +
	numbers[55] + numbers[56] + numbers[57] + numbers[58] + numbers[59] +
	// numbers[60] + numbers[61] + numbers[62] + numbers[63] + numbers[64] +
	// numbers[65] + numbers[66] + numbers[67] + numbers[68] + numbers[69] +
	numbers[72] + numbers[73] + numbers[74] +
	numbers[75] + numbers[76] + numbers[77] + numbers[78] + numbers[79] +
	numbers[80] + numbers[81] + numbers[82] + numbers[83] + numbers[84] +
	numbers[85] + numbers[86] + numbers[87] + numbers[88] + numbers[89] +
	numbers[90] + numbers[91] + numbers[92] + numbers[93] + numbers[94] +
	numbers[95] + numbers[96] + numbers[97] + numbers[98] + numbers[99] +
	numbers[100] + numbers[101] + numbers[102] + numbers[103] + numbers[104] +
	numbers[105] + numbers[106] + numbers[107] + numbers[108] + numbers[109] +
	numbers[110] + numbers[111] + numbers[112] + numbers[113] + numbers[114] +
	numbers[115] + numbers[116] + numbers[117] + numbers[118] + numbers[119] +
	numbers[120] + numbers[121] + numbers[122] + numbers[123] + numbers[124] +
	numbers[125] + numbers[126] + numbers[127] + numbers[128] + numbers[129] +
	numbers[130] + numbers[131] + numbers[132] + numbers[133] + numbers[134] +
	numbers[135] + numbers[136] + numbers[137] + numbers[138] + numbers[139] +
	numbers[140] + numbers[141] + numbers[142] + numbers[143] + numbers[144] +
	numbers[145] + numbers[146] + numbers[147] + numbers[148] + numbers[149] +
	numbers[150] + numbers[151] + numbers[152] + numbers[153] + numbers[154] +
	numbers[155] + numbers[156] + numbers[157] + numbers[158] + numbers[159] +
	numbers[160] + numbers[161] + numbers[162] + numbers[163] + numbers[164] +
	numbers[165] + numbers[166] + numbers[167] + numbers[168] + numbers[169] +
	numbers[170] + numbers[171] + numbers[172] + numbers[173] + numbers[174] +
	numbers[175] + numbers[176] + numbers[177] + numbers[178] + numbers[179] +
	numbers[180] + numbers[181] + numbers[182] + numbers[183] + numbers[184] +
	numbers[185] + numbers[186] + numbers[187] + numbers[188] + numbers[189] +
	numbers[190] + numbers[191] + numbers[192] + numbers[193] + numbers[194] +
	numbers[195] + numbers[196] + numbers[197] + numbers[198] + numbers[199] +
	numbers[200] + numbers[201] + numbers[202] + numbers[203] + numbers[204] +
	numbers[205] + numbers[206] + numbers[207] + numbers[208] + numbers[209] +
	numbers[210] + numbers[211] + numbers[212] ;

	// generate
	AN2 and0(.Z(gen[0]), .A(div[0]), .B(i_d[0]), .number(numbers[0]));
	AN2 and1(.Z(gen[1]), .A(div[1]), .B(i_d[1]), .number(numbers[1]));
	AN2 and2(.Z(gen[2]), .A(div[2]), .B(i_d[2]), .number(numbers[2]));
	AN2 and3(.Z(gen[3]), .A(div[3]), .B(i_d[3]), .number(numbers[3]));
	AN2 and4(.Z(gen[4]), .A(div[4]), .B(i_d[4]), .number(numbers[4]));
	AN2 and5(.Z(gen[5]), .A(div[5]), .B(i_d[5]), .number(numbers[5]));
	AN2 and6(.Z(gen[6]), .A(div[6]), .B(i_d[6]), .number(numbers[6]));
	AN2 and7(.Z(gen[7]), .A(div[7]), .B(i_d[7]), .number(numbers[7]));
	AN2 and8(.Z(gen[8]), .A(div[8]), .B(i_d[8]), .number(numbers[8]));
	AN2 and9(.Z(gen[9]), .A(div[9]), .B(i_d[9]), .number(numbers[9]));
	AN2 anda(.Z(gen[10]), .A(div[10]), .B(i_d[10]), .number(numbers[10]));
	AN2 andb(.Z(gen[11]), .A(div[11]), .B(i_d[11]), .number(numbers[11]));

	// propagate
	EO xor0(.Z(prop[0]), .A(div[0]), .B(i_d[0]), .number(numbers[12]));
	EO xor1(.Z(prop[1]), .A(div[1]), .B(i_d[1]), .number(numbers[13]));
	EO xor2(.Z(prop[2]), .A(div[2]), .B(i_d[2]), .number(numbers[14]));
	EO xor3(.Z(prop[3]), .A(div[3]), .B(i_d[3]), .number(numbers[15]));
	EO xor4(.Z(prop[4]), .A(div[4]), .B(i_d[4]), .number(numbers[16]));
	EO xor5(.Z(prop[5]), .A(div[5]), .B(i_d[5]), .number(numbers[17]));
	EO xor6(.Z(prop[6]), .A(div[6]), .B(i_d[6]), .number(numbers[18]));
	EO xor7(.Z(prop[7]), .A(div[7]), .B(i_d[7]), .number(numbers[19]));
	EO xor8(.Z(prop[8]), .A(div[8]), .B(i_d[8]), .number(numbers[20]));
	EO xor9(.Z(prop[9]), .A(div[9]), .B(i_d[9]), .number(numbers[21]));
	EO xora(.Z(prop[10]), .A(div[10]), .B(i_d[10]), .number(numbers[22]));
	EO xorb(.Z(prop[11]), .A(div[11]), .B(i_d[11]), .number(numbers[23]));
	
	// assuming Cin low, in groups of 4
	wire [20:0] buffers_low;
	EO  xorc(.Z(sum_low[0]), .A(prop[0]), .B(low), .number(numbers[24]));
	AN2 andc(.Z(buffers_low[0]), .A(prop[0]), .B(low), .number(numbers[25]));
	OR2 or0 (.Z(co_low[0]), .A(gen[0]), .B(buffers_low[0]), .number(numbers[26]));
	EO  xord(.Z(sum_low[1]), .A(prop[1]), .B(co_low[0]), .number(numbers[27]));
	AN2 andd(.Z(buffers_low[1]), .A(prop[1]), .B(co_low[0]), .number(numbers[28]));
	OR2 or1 (.Z(co_low[1]), .A(gen[1]), .B(buffers_low[1]), .number(numbers[29]));
	EO  xore(.Z(sum_low[2]), .A(prop[2]), .B(co_low[1]), .number(numbers[30]));
	AN2 ande(.Z(buffers_low[2]), .A(prop[2]), .B(co_low[1]), .number(numbers[31]));
	OR2 or2 (.Z(co_low[2]), .A(gen[2]), .B(buffers_low[2]), .number(numbers[32]));
	EO  xorf(.Z(sum_low[3]), .A(prop[3]), .B(co_low[2]), .number(numbers[33]));
	AN2 andf(.Z(buffers_low[3]), .A(prop[3]), .B(co_low[2]), .number(numbers[34]));
	OR2 or3 (.Z(co_low[3]), .A(gen[3]), .B(buffers_low[3]), .number(numbers[35]));

	EO  xorg(.Z(sum_low[4]), .A(prop[4]), .B(low), .number(numbers[36]));
	AN2 andg(.Z(buffers_low[4]), .A(prop[4]), .B(low), .number(numbers[37]));
	OR2 or4 (.Z(co_low[4]), .A(gen[4]), .B(buffers_low[4]), .number(numbers[38]));
	EO  xorh(.Z(sum_low[5]), .A(prop[5]), .B(co_low[4]), .number(numbers[39]));
	AN2 andh(.Z(buffers_low[5]), .A(prop[5]), .B(co_low[4]), .number(numbers[40]));
	OR2 or5 (.Z(co_low[5]), .A(gen[5]), .B(buffers_low[5]), .number(numbers[41]));
	EO  xori(.Z(sum_low[6]), .A(prop[6]), .B(co_low[5]), .number(numbers[42]));
	AN2 andi(.Z(buffers_low[6]), .A(prop[6]), .B(co_low[5]), .number(numbers[43]));
	OR2 or6 (.Z(co_low[6]), .A(gen[6]), .B(buffers_low[6]), .number(numbers[44]));
	EO  xorj(.Z(sum_low[7]), .A(prop[7]), .B(co_low[6]), .number(numbers[45]));
	AN2 andj(.Z(buffers_low[7]), .A(prop[7]), .B(co_low[6]), .number(numbers[46]));
	OR2 or7 (.Z(co_low[7]), .A(gen[7]), .B(buffers_low[7]), .number(numbers[47]));

	EO  xork(.Z(sum_low[8]), .A(prop[8]), .B(low), .number(numbers[48]));
	AN2 andk(.Z(buffers_low[8]), .A(prop[8]), .B(low), .number(numbers[49]));
	OR2 or8 (.Z(co_low[8]), .A(gen[8]), .B(buffers_low[8]), .number(numbers[50]));
	EO  xorl(.Z(sum_low[9]), .A(prop[9]), .B(co_low[8]), .number(numbers[51]));
	AN2 andl(.Z(buffers_low[9]), .A(prop[9]), .B(co_low[8]), .number(numbers[52]));
	OR2 or9 (.Z(co_low[9]), .A(gen[9]), .B(buffers_low[9]), .number(numbers[53]));
	EO  xorm(.Z(sum_low[10]), .A(prop[10]), .B(co_low[9]), .number(numbers[54]));
	AN2 andm(.Z(buffers_low[10]), .A(prop[10]), .B(co_low[9]), .number(numbers[55]));
	OR2 ora (.Z(co_low[10]), .A(gen[10]), .B(buffers_low[10]), .number(numbers[56]));
	EO  xorn(.Z(sum_low[11]), .A(prop[11]), .B(co_low[10]), .number(numbers[57]));
	AN2 andn(.Z(buffers_low[11]), .A(prop[11]), .B(co_low[10]), .number(numbers[58]));
	OR2 orb (.Z(co_low[11]), .A(gen[11]), .B(buffers_low[11]), .number(numbers[59]));

	// assuming Cin high, in groups of 4
	wire [20:0] buffers_high;
	EO  xors(.Z(sum_high[4]), .A(prop[4]), .B(high), .number(numbers[72]));
	AN2 ands(.Z(buffers_high[4]), .A(prop[4]), .B(high), .number(numbers[73]));
	OR2 org (.Z(co_high[4]), .A(gen[4]), .B(buffers_high[4]), .number(numbers[74]));
	EO  xort(.Z(sum_high[5]), .A(prop[5]), .B(co_high[4]), .number(numbers[75]));
	AN2 andt(.Z(buffers_high[5]), .A(prop[5]), .B(co_high[4]), .number(numbers[76]));
	OR2 orh (.Z(co_high[5]), .A(gen[5]), .B(buffers_high[5]), .number(numbers[77]));
	EO  xoru(.Z(sum_high[6]), .A(prop[6]), .B(co_high[5]), .number(numbers[78]));
	AN2 andu(.Z(buffers_high[6]), .A(prop[6]), .B(co_high[5]), .number(numbers[79]));
	OR2 ori (.Z(co_high[6]), .A(gen[6]), .B(buffers_high[6]), .number(numbers[80]));
	EO  xorv(.Z(sum_high[7]), .A(prop[7]), .B(co_high[6]), .number(numbers[81]));
	AN2 andv(.Z(buffers_high[7]), .A(prop[7]), .B(co_high[6]), .number(numbers[82]));
	OR2 orj (.Z(co_high[7]), .A(gen[7]), .B(buffers_high[7]), .number(numbers[83]));

	EO  xorx(.Z(sum_high[8]), .A(prop[8]), .B(high), .number(numbers[84]));
	AN2 andx(.Z(buffers_high[8]), .A(prop[8]), .B(high), .number(numbers[85]));
	OR2 ork (.Z(co_high[8]), .A(gen[8]), .B(buffers_high[8]), .number(numbers[86]));
	EO  xory(.Z(sum_high[9]), .A(prop[9]), .B(co_high[8]), .number(numbers[87]));
	AN2 andy(.Z(buffers_high[9]), .A(prop[9]), .B(co_high[8]), .number(numbers[88]));
	OR2 orl (.Z(co_high[9]), .A(gen[9]), .B(buffers_high[9]), .number(numbers[89]));
	EO  xorz(.Z(sum_high[10]), .A(prop[10]), .B(co_high[9]), .number(numbers[90]));
	AN2 andz(.Z(buffers_high[10]), .A(prop[10]), .B(co_high[9]), .number(numbers[91]));
	OR2 orm (.Z(co_high[10]), .A(gen[10]), .B(buffers_high[10]), .number(numbers[92]));
	EO  xorA(.Z(sum_high[11]), .A(prop[11]), .B(co_high[10]), .number(numbers[93]));
	AN2 andA(.Z(buffers_high[11]), .A(prop[11]), .B(co_high[10]), .number(numbers[94]));
	OR2 orn (.Z(co_high[11]), .A(gen[11]), .B(buffers_high[11]), .number(numbers[95]));

	// selecting
	assign sum[0] = sum_low[0];
	assign sum[1] = sum_low[1];
	assign sum[2] = sum_low[2];
	assign sum[3] = sum_low[3];
	assign co[0] = co_low[0];
	assign co[1] = co_low[1];
	assign co[2] = co_low[2];
	assign co[3] = co_low[3];
	MUX21H mux0(.Z(sum[4]), .A(sum_low[4]), .B(sum_high[4]), .CTRL(co[3]), .number(numbers[96]));
	MUX21H mux1(.Z(sum[5]), .A(sum_low[5]), .B(sum_high[5]), .CTRL(co[3]), .number(numbers[97]));
	MUX21H mux2(.Z(sum[6]), .A(sum_low[6]), .B(sum_high[6]), .CTRL(co[3]), .number(numbers[98]));
	MUX21H mux3(.Z(sum[7]), .A(sum_low[7]), .B(sum_high[7]), .CTRL(co[3]), .number(numbers[99]));
	MUX21H mux4(.Z(sum[8]), .A(sum_low[8]), .B(sum_high[8]), .CTRL(co[7]), .number(numbers[100]));
	MUX21H mux5(.Z(sum[9]), .A(sum_low[9]), .B(sum_high[9]), .CTRL(co[7]), .number(numbers[101]));
	MUX21H mux6(.Z(sum[10]), .A(sum_low[10]), .B(sum_high[10]), .CTRL(co[7]), .number(numbers[102]));
	MUX21H mux7(.Z(sum[11]), .A(sum_low[11]), .B(sum_high[11]), .CTRL(co[7]), .number(numbers[103]));
	MUX21H mux8(.Z(co[4]), .A(co_low[4]), .B(co_high[4]), .CTRL(co[3]), .number(numbers[104]));
	MUX21H mux9(.Z(co[5]), .A(co_low[5]), .B(co_high[5]), .CTRL(co[3]), .number(numbers[105]));
	MUX21H muxa(.Z(co[6]), .A(co_low[6]), .B(co_high[6]), .CTRL(co[3]), .number(numbers[106]));
	MUX21H muxb(.Z(co[7]), .A(co_low[7]), .B(co_high[7]), .CTRL(co[3]), .number(numbers[107]));
	MUX21H muxc(.Z(co[8]), .A(co_low[8]), .B(co_high[8]), .CTRL(co[7]), .number(numbers[108]));
	MUX21H muxd(.Z(co[9]), .A(co_low[9]), .B(co_high[9]), .CTRL(co[7]), .number(numbers[109]));
	MUX21H muxe(.Z(co[10]), .A(co_low[10]), .B(co_high[10]), .CTRL(co[7]), .number(numbers[110]));
	MUX21H muxf(.Z(co[11]), .A(co_low[11]), .B(co_high[11]), .CTRL(co[7]), .number(numbers[111]));

	// gating
	FD2 fd0(.Q(sum_gated[0]), .D(sum[0]), .CLK(clk), .RESET(rst_n), .number(numbers[112]));
	FD2 fd1(.Q(sum_gated[1]), .D(sum[1]), .CLK(clk), .RESET(rst_n), .number(numbers[113]));
	FD2 fd2(.Q(sum_gated[2]), .D(sum[2]), .CLK(clk), .RESET(rst_n), .number(numbers[114]));
	FD2 fd3(.Q(sum_gated[3]), .D(sum[3]), .CLK(clk), .RESET(rst_n), .number(numbers[115]));
	FD2 fd4(.Q(sum_gated[4]), .D(sum[4]), .CLK(clk), .RESET(rst_n), .number(numbers[116]));
	FD2 fd5(.Q(sum_gated[5]), .D(sum[5]), .CLK(clk), .RESET(rst_n), .number(numbers[117]));
	FD2 fd6(.Q(sum_gated[6]), .D(sum[6]), .CLK(clk), .RESET(rst_n), .number(numbers[118]));
	FD2 fd7(.Q(sum_gated[7]), .D(sum[7]), .CLK(clk), .RESET(rst_n), .number(numbers[119]));
	FD2 fd8(.Q(sum_gated[8]), .D(sum[8]), .CLK(clk), .RESET(rst_n), .number(numbers[120]));
	FD2 fd9(.Q(sum_gated[9]), .D(sum[9]), .CLK(clk), .RESET(rst_n), .number(numbers[121]));
	FD2 fda(.Q(sum_gated[10]), .D(sum[10]), .CLK(clk), .RESET(rst_n), .number(numbers[122]));
	FD2 fdb(.Q(sum_gated[11]), .D(sum[11]), .CLK(clk), .RESET(rst_n), .number(numbers[123]));
	FD2 fdc(.Q(co_gated[0]), .D(co[0]), .CLK(clk), .RESET(rst_n), .number(numbers[124]));
	FD2 fdd(.Q(co_gated[1]), .D(co[1]), .CLK(clk), .RESET(rst_n), .number(numbers[125]));
	FD2 fde(.Q(co_gated[2]), .D(co[2]), .CLK(clk), .RESET(rst_n), .number(numbers[126]));
	FD2 fdf(.Q(co_gated[3]), .D(co[3]), .CLK(clk), .RESET(rst_n), .number(numbers[127]));
	FD2 fdg(.Q(co_gated[4]), .D(co[4]), .CLK(clk), .RESET(rst_n), .number(numbers[128]));
	FD2 fdh(.Q(co_gated[5]), .D(co[5]), .CLK(clk), .RESET(rst_n), .number(numbers[129]));
	FD2 fdi(.Q(co_gated[6]), .D(co[6]), .CLK(clk), .RESET(rst_n), .number(numbers[130]));
	FD2 fdj(.Q(co_gated[7]), .D(co[7]), .CLK(clk), .RESET(rst_n), .number(numbers[131]));
	FD2 fdk(.Q(co_gated[8]), .D(co[8]), .CLK(clk), .RESET(rst_n), .number(numbers[132]));
	FD2 fdl(.Q(co_gated[9]), .D(co[9]), .CLK(clk), .RESET(rst_n), .number(numbers[133]));
	FD2 fdm(.Q(co_gated[10]), .D(co[10]), .CLK(clk), .RESET(rst_n), .number(numbers[134]));
	FD2 fdn(.Q(co_gated[11]), .D(co[11]), .CLK(clk), .RESET(rst_n), .number(numbers[135]));

	wire i_in_valid_prev, i_in_valid_n_prev;
	FD2 archilles(.Q(i_in_valid_prev), .D(i_in_valid), .CLK(clk), .RESET(rst_n), .number(numbers[136]));
	IV nde(.Z(i_in_valid_n_prev), .A(i_in_valid_prev), .number(numbers[137]));
	wire i_in_valid_rise_edge;
	AN2 snd(.Z(i_in_valid_rise_edge), .A(i_in_valid_n_prev) ,.B(i_in_valid), .number(numbers[138]));

	MUX21H muxg(.Z(div[0]), .A(sum_gated[0]), .B(i_n[0]), .CTRL(i_in_valid_rise_edge), .number(numbers[139]));
	MUX21H muxh(.Z(div[1]), .A(sum_gated[1]), .B(i_n[1]), .CTRL(i_in_valid_rise_edge), .number(numbers[140]));
	MUX21H muxi(.Z(div[2]), .A(sum_gated[2]), .B(i_n[2]), .CTRL(i_in_valid_rise_edge), .number(numbers[141]));
	MUX21H muxj(.Z(div[3]), .A(sum_gated[3]), .B(i_n[3]), .CTRL(i_in_valid_rise_edge), .number(numbers[142]));
	MUX21H muxk(.Z(div[4]), .A(sum_gated[4]), .B(i_n[4]), .CTRL(i_in_valid_rise_edge), .number(numbers[143]));
	MUX21H muxl(.Z(div[5]), .A(sum_gated[5]), .B(i_n[5]), .CTRL(i_in_valid_rise_edge), .number(numbers[144]));
	MUX21H muxm(.Z(div[6]), .A(sum_gated[6]), .B(i_n[6]), .CTRL(i_in_valid_rise_edge), .number(numbers[145]));
	MUX21H muxn(.Z(div[7]), .A(sum_gated[7]), .B(i_n[7]), .CTRL(i_in_valid_rise_edge), .number(numbers[146]));
	MUX21H muxo(.Z(div[8]), .A(sum_gated[8]), .B(i_n[8]), .CTRL(i_in_valid_rise_edge), .number(numbers[147]));
	MUX21H muxp(.Z(div[9]), .A(sum_gated[9]), .B(i_n[9]), .CTRL(i_in_valid_rise_edge), .number(numbers[148]));
	MUX21H muxq(.Z(div[10]), .A(sum_gated[10]), .B(i_n[10]), .CTRL(i_in_valid_rise_edge), .number(numbers[149]));
	MUX21H muxr(.Z(div[11]), .A(sum_gated[11]), .B(i_n[11]), .CTRL(i_in_valid_rise_edge), .number(numbers[150]));

	// is zero?
	wire is_zero;
	wire [3:0] buffers_is0;
	NR4 nor0(.Z(buffers_is0[0]), .A(sum_gated[0]), .B(sum_gated[1]), .C(sum_gated[2]), .D(sum_gated[3]), .number(numbers[151]));
	NR4 nor1(.Z(buffers_is0[1]), .A(sum_gated[4]), .B(sum_gated[5]), .C(sum_gated[6]), .D(sum_gated[7]), .number(numbers[152]));
	NR4 nor2(.Z(buffers_is0[2]), .A(sum_gated[8]), .B(sum_gated[9]), .C(sum_gated[10]), .D(sum_gated[11]), .number(numbers[153]));
	AN3 andC(.Z(is_zero), .A(buffers_is0[0]), .B(buffers_is0[1]), .C(buffers_is0[2]), .number(numbers[154]));

	// should not be valid when i_d equate sum_gated
	wire sasd;
	NEQ jov(.i_a(i_d), .i_b(sum_gated), .o_neq(sasd), .number(numbers[155]));

	// is negative?
	wire hahha, hahha_buf;
	IV  nnt1(.Z(hahha), .A(co_gated[11]), .number(numbers[156]));
	wire i_in_valid_rise_edge_n;
	IV ndww(.Z(i_in_valid_rise_edge_n), .A(i_in_valid_rise_edge), .number(numbers[157]));

	// o_out_valid
	wire buffer1, buffer2;
	OR2 oro(.Z(buffer1), .A(hahha), .B(is_zero), .number(numbers[158]));	
	AN2 asdie(.Z(buffer2), .A(buffer1), .B(sasd), .number(numbers[159])); 
	FD1 fdis(.Q(o_out_valid), .D(buffer2), .CLK(clk), .RESET(rst_n), .number(numbers[160]));

	// o_is_factor
	FD2 fdq(.Q(o_is_factor), .D(is_zero), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[161]));

	wire [11:0] sum_gated_prev;
	FD2 fdD(.Q(sum_gated_prev[0]), .D(sum_gated[0]), .CLK(clk), .RESET(rst_n), .number(numbers[162]));
	FD2 fdE(.Q(sum_gated_prev[1]), .D(sum_gated[1]), .CLK(clk), .RESET(rst_n), .number(numbers[163]));
	FD2 fdF(.Q(sum_gated_prev[2]), .D(sum_gated[2]), .CLK(clk), .RESET(rst_n), .number(numbers[164]));
	FD2 fdG(.Q(sum_gated_prev[3]), .D(sum_gated[3]), .CLK(clk), .RESET(rst_n), .number(numbers[165]));
	FD2 fdH(.Q(sum_gated_prev[4]), .D(sum_gated[4]), .CLK(clk), .RESET(rst_n), .number(numbers[166]));
	FD2 fdI(.Q(sum_gated_prev[5]), .D(sum_gated[5]), .CLK(clk), .RESET(rst_n), .number(numbers[167]));
	FD2 fdJ(.Q(sum_gated_prev[6]), .D(sum_gated[6]), .CLK(clk), .RESET(rst_n), .number(numbers[168]));
	FD2 fdK(.Q(sum_gated_prev[7]), .D(sum_gated[7]), .CLK(clk), .RESET(rst_n), .number(numbers[169]));
	FD2 fdL(.Q(sum_gated_prev[8]), .D(sum_gated[8]), .CLK(clk), .RESET(rst_n), .number(numbers[170]));
	FD2 fdM(.Q(sum_gated_prev[9]), .D(sum_gated[9]), .CLK(clk), .RESET(rst_n), .number(numbers[171]));
	FD2 fdN(.Q(sum_gated_prev[10]), .D(sum_gated[10]), .CLK(clk), .RESET(rst_n), .number(numbers[172]));
	FD2 fdO(.Q(sum_gated_prev[11]), .D(sum_gated[11]), .CLK(clk), .RESET(rst_n), .number(numbers[173]));

	wire [11:0] remainder;
	// gating remainder
	FD2 fdC(.Q(remainder[0]), .D(sum_gated_prev[0]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[174]));
	FD2 fdr(.Q(remainder[1]), .D(sum_gated_prev[1]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[175]));
	FD2 fds(.Q(remainder[2]), .D(sum_gated_prev[2]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[176]));
	FD2 fdt(.Q(remainder[3]), .D(sum_gated_prev[3]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[177]));
	FD2 fdu(.Q(remainder[4]), .D(sum_gated_prev[4]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[178]));
	FD2 fdv(.Q(remainder[5]), .D(sum_gated_prev[5]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[179]));
	FD2 fdw(.Q(remainder[6]), .D(sum_gated_prev[6]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[180]));
	FD2 fdx(.Q(remainder[7]), .D(sum_gated_prev[7]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[181]));
	FD2 fdy(.Q(remainder[8]), .D(sum_gated_prev[8]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[182]));
	FD2 fdz(.Q(remainder[9]), .D(sum_gated_prev[9]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[183]));
	FD2 fdA(.Q(remainder[10]), .D(sum_gated_prev[10]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[184]));
	FD2 fdB(.Q(remainder[11]), .D(sum_gated_prev[11]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[185]));

	wire rem_zero_n, change_rem, bufz;
	wire [11:0] zero_12 = 12'b0;
	NEQ xd(.i_a(sum_gated_prev), .i_b(zero_12), .o_neq(rem_zero_n), .number(numbers[186]));
	NR2 xli(.Z(change_rem), .A(rem_zero_n), .B(o_is_factor), .number(numbers[187]));

	wire test_change_rem;
	FD2 fdic(.Q(test_change_rem), .D(change_rem), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[188]));

	wire [11:0] rem_buf, rem_buf2;
	MUX21H xev0(.Z(rem_buf2[0]), .A(remainder[0]), .B(i_n[0]), .CTRL(test_change_rem), .number(numbers[189]));
	MUX21H xev1(.Z(rem_buf2[1]), .A(remainder[1]), .B(i_n[1]), .CTRL(test_change_rem), .number(numbers[190]));
	MUX21H xev2(.Z(rem_buf2[2]), .A(remainder[2]), .B(i_n[2]), .CTRL(test_change_rem), .number(numbers[191]));
	MUX21H xev3(.Z(rem_buf2[3]), .A(remainder[3]), .B(i_n[3]), .CTRL(test_change_rem), .number(numbers[192]));
	MUX21H xev4(.Z(rem_buf2[4]), .A(remainder[4]), .B(i_n[4]), .CTRL(test_change_rem), .number(numbers[193]));
	MUX21H xev5(.Z(rem_buf2[5]), .A(remainder[5]), .B(i_n[5]), .CTRL(test_change_rem), .number(numbers[194]));
	MUX21H xev6(.Z(rem_buf2[6]), .A(remainder[6]), .B(i_n[6]), .CTRL(test_change_rem), .number(numbers[195]));
	MUX21H xev7(.Z(rem_buf2[7]), .A(remainder[7]), .B(i_n[7]), .CTRL(test_change_rem), .number(numbers[196]));
	MUX21H xev8(.Z(rem_buf2[8]), .A(remainder[8]), .B(i_n[8]), .CTRL(test_change_rem), .number(numbers[197]));
	MUX21H xev9(.Z(rem_buf2[9]), .A(remainder[9]), .B(i_n[9]), .CTRL(test_change_rem), .number(numbers[198]));
	MUX21H xeva(.Z(rem_buf2[10]), .A(remainder[10]), .B(i_n[10]), .CTRL(test_change_rem), .number(numbers[199]));
	MUX21H xevb(.Z(rem_buf2[11]), .A(remainder[11]), .B(i_n[11]), .CTRL(test_change_rem), .number(numbers[200]));

	FD1 oxi0(.Q(o_remainder[0]), .D(rem_buf2[0]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[201]));
	FD1 oxi1(.Q(o_remainder[1]), .D(rem_buf2[1]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[202]));
	FD1 oxi2(.Q(o_remainder[2]), .D(rem_buf2[2]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[203]));
	FD1 oxi3(.Q(o_remainder[3]), .D(rem_buf2[3]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[204]));
	FD1 oxi4(.Q(o_remainder[4]), .D(rem_buf2[4]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[205]));
	FD1 oxi5(.Q(o_remainder[5]), .D(rem_buf2[5]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[206]));
	FD1 oxi6(.Q(o_remainder[6]), .D(rem_buf2[6]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[207]));
	FD1 oxi7(.Q(o_remainder[7]), .D(rem_buf2[7]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[208]));
	FD1 oxi8(.Q(o_remainder[8]), .D(rem_buf2[8]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[209]));
	FD1 oxi9(.Q(o_remainder[9]), .D(rem_buf2[9]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[210]));
	FD1 oxia(.Q(o_remainder[10]), .D(rem_buf2[10]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[211]));
	FD1 oxib(.Q(o_remainder[11]), .D(rem_buf2[11]), .CLK(o_out_valid), .RESET(rst_n), .number(numbers[212]));
endmodule


module GEQ(
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [11:0] i_a,
	input  [11:0] i_b,
	output o_geq,
	output o_out_valid,
	output [50:0] number
);
	wire [50:0] numbers [30:0];
	wire [11:0] greater, less, eq, neq;
	wire [11:0] buffers_det;
	wire [11:0] buffers_geq;
	wire high = 1'b1;
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10] + numbers[11] + numbers[12] + numbers[13] + numbers[14] +
	numbers[15] + numbers[16] + numbers[17] + numbers[18] + numbers[19] +
	numbers[20] + numbers[21] + numbers[22] + numbers[23] + numbers[24] +
	numbers[25] + numbers[26];

	EO xor0(.Z(buffers_det[0]), .A(i_a[0]), .B(i_b[0]), .number(numbers[0]));	
	EO xor1(.Z(buffers_det[1]), .A(i_a[1]), .B(i_b[1]), .number(numbers[1]));	
	EO xor2(.Z(buffers_det[2]), .A(i_a[2]), .B(i_b[2]), .number(numbers[2]));	
	EO xor3(.Z(buffers_det[3]), .A(i_a[3]), .B(i_b[3]), .number(numbers[3]));	
	EO xor4(.Z(buffers_det[4]), .A(i_a[4]), .B(i_b[4]), .number(numbers[4]));	
	EO xor5(.Z(buffers_det[5]), .A(i_a[5]), .B(i_b[5]), .number(numbers[5]));	
	EO xor6(.Z(buffers_det[6]), .A(i_a[6]), .B(i_b[6]), .number(numbers[6]));	
	EO xor7(.Z(buffers_det[7]), .A(i_a[7]), .B(i_b[7]), .number(numbers[7]));	
	EO xor8(.Z(buffers_det[8]), .A(i_a[8]), .B(i_b[8]), .number(numbers[8]));	
	EO xor9(.Z(buffers_det[9]), .A(i_a[9]), .B(i_b[9]), .number(numbers[9]));	
	EO xora(.Z(buffers_det[10]), .A(i_a[10]), .B(i_b[10]), .number(numbers[10]));	
	EO xorb(.Z(buffers_det[11]), .A(i_a[11]), .B(i_b[11]), .number(numbers[11]));	

	MUX21H mux0(.Z(buffers_geq[0]), .A(high), .B(i_a[0]), .CTRL(buffers_det[0]), .number(numbers[12]));
	MUX21H mux1(.Z(buffers_geq[1]), .A(buffers_geq[0]), .B(i_a[1]), .CTRL(buffers_det[1]), .number(numbers[13]));
	MUX21H mux2(.Z(buffers_geq[2]), .A(buffers_geq[1]), .B(i_a[2]), .CTRL(buffers_det[2]), .number(numbers[14]));
	MUX21H mux3(.Z(buffers_geq[3]), .A(buffers_geq[2]), .B(i_a[3]), .CTRL(buffers_det[3]), .number(numbers[15]));
	MUX21H mux4(.Z(buffers_geq[4]), .A(buffers_geq[3]), .B(i_a[4]), .CTRL(buffers_det[4]), .number(numbers[16]));
	MUX21H mux5(.Z(buffers_geq[5]), .A(buffers_geq[4]), .B(i_a[5]), .CTRL(buffers_det[5]), .number(numbers[17]));
	MUX21H mux6(.Z(buffers_geq[6]), .A(buffers_geq[5]), .B(i_a[6]), .CTRL(buffers_det[6]), .number(numbers[18]));
	MUX21H mux7(.Z(buffers_geq[7]), .A(buffers_geq[6]), .B(i_a[7]), .CTRL(buffers_det[7]), .number(numbers[19]));
	MUX21H mux8(.Z(buffers_geq[8]), .A(buffers_geq[7]), .B(i_a[8]), .CTRL(buffers_det[8]), .number(numbers[20]));
	MUX21H mux9(.Z(buffers_geq[9]), .A(buffers_geq[8]), .B(i_a[9]), .CTRL(buffers_det[9]), .number(numbers[21]));
	MUX21H muxa(.Z(buffers_geq[10]), .A(buffers_geq[9]), .B(i_a[10]), .CTRL(buffers_det[10]), .number(numbers[22]));
	MUX21H muxb(.Z(buffers_geq[11]), .A(buffers_geq[10]), .B(i_a[11]), .CTRL(buffers_det[11]), .number(numbers[23]));

	wire valid_rise;
	AN2 and0(.Z(valid_rise), .A(clk), .B(i_in_valid), .number(numbers[24]));
	FD1 fd0(.Q(o_geq), .D(buffers_geq[11]), .CLK(valid_rise), .RESET(rst_n), .number(numbers[25]));
	FD1 fd1(.Q(o_out_valid), .D(high), .CLK(valid_rise), .RESET(rst_n), .number(numbers[26]));
endmodule

module MUX11B(
	input  [11:0] A,
	input  [11:0] B,
	input  CTRL,
	output [50:0] number,
	output [11:0] Z
);
	wire [50:0] numbers [11:0];
	assign number =
	numbers[0] + numbers[1] + numbers[2] + numbers[3] + numbers[4] +
	numbers[5] + numbers[6] + numbers[7] + numbers[8] + numbers[9] +
	numbers[10] + numbers[11];

	MUX21H mux0(.Z(Z[0]), .A(A[0]), .B(B[0]), .CTRL(CTRL), .number(numbers[0]));
	MUX21H mux1(.Z(Z[1]), .A(A[1]), .B(B[1]), .CTRL(CTRL), .number(numbers[1]));
	MUX21H mux2(.Z(Z[2]), .A(A[2]), .B(B[2]), .CTRL(CTRL), .number(numbers[2]));
	MUX21H mux3(.Z(Z[3]), .A(A[3]), .B(B[3]), .CTRL(CTRL), .number(numbers[3]));
	MUX21H mux4(.Z(Z[4]), .A(A[4]), .B(B[4]), .CTRL(CTRL), .number(numbers[4]));
	MUX21H mux5(.Z(Z[5]), .A(A[5]), .B(B[5]), .CTRL(CTRL), .number(numbers[5]));
	MUX21H mux6(.Z(Z[6]), .A(A[6]), .B(B[6]), .CTRL(CTRL), .number(numbers[6]));
	MUX21H mux7(.Z(Z[7]), .A(A[7]), .B(B[7]), .CTRL(CTRL), .number(numbers[7]));
	MUX21H mux8(.Z(Z[8]), .A(A[8]), .B(B[8]), .CTRL(CTRL), .number(numbers[8]));
	MUX21H mux9(.Z(Z[9]), .A(A[9]), .B(B[9]), .CTRL(CTRL), .number(numbers[9]));
	MUX21H muxa(.Z(Z[10]), .A(A[10]), .B(B[10]), .CTRL(CTRL), .number(numbers[10]));
	MUX21H muxb(.Z(Z[11]), .A(A[11]), .B(B[11]), .CTRL(CTRL), .number(numbers[11]));
endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input clk,
	input rst_n,
	output [BW-1:0] Q,
	input [BW-1:0] D,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule