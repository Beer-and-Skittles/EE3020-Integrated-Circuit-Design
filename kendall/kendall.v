`timescale 1ns/1ps

module kendall_rank(kendall, i0_x, i0_y, i1_x, i1_y, i2_x, i2_y, i3_x, i3_y);
//DO NOT CHANGE!
    input  [3:0] i0_x, i0_y, i1_x, i1_y, i2_x, i2_y, i3_x, i3_y;
    output [3:0] kendall;
//---------------------------------------------------

    wire x01, x02, x03, x12, x13, x23;
    b_greater_a comp0(.is_c(x01), .a(i1_x), .b(i0_x));
    b_greater_a comp1(.is_c(x02), .a(i2_x), .b(i0_x));
    b_greater_a comp2(.is_c(x03), .a(i3_x), .b(i0_x));
    b_greater_a comp3(.is_c(x12), .a(i2_x), .b(i1_x));
    b_greater_a comp4(.is_c(x13), .a(i3_x), .b(i1_x));
    b_greater_a comp5(.is_c(x23), .a(i3_x), .b(i2_x));

    wire y01, y02, y03, y12, y13, y23; 
    b_greater_a comp6(.is_c(y01), .a(i1_y), .b(i0_y));
    b_greater_a comp7(.is_c(y02), .a(i2_y), .b(i0_y));
    b_greater_a comp8(.is_c(y03), .a(i3_y), .b(i0_y));
    b_greater_a comp9(.is_c(y12), .a(i2_y), .b(i1_y));
    b_greater_a compa(.is_c(y13), .a(i3_y), .b(i1_y));
    b_greater_a compb(.is_c(y23), .a(i3_y), .b(i2_y));

    wire set01_not, set02_not, set03_not, set12_not, set13_not, set23_not;
    EO exor0(.Z(set01_not),.A(x01),.B(y01));
    EO exor1(.Z(set02_not),.A(x02),.B(y02));
    EO exor2(.Z(set03_not),.A(x03),.B(y03));
    EO exor3(.Z(set12_not),.A(x12),.B(y12));
    EO exor4(.Z(set13_not),.A(x13),.B(y13));
    EO exor5(.Z(set23_not),.A(x23),.B(y23));

    count counter(.o(kendall),.n_i0(set01_not),.n_i1(set02_not),.n_i2(set03_not),.n_i3(set12_not),.n_i4(set13_not),.n_i5(set23_not));

endmodule

module count(o, n_i0, n_i1, n_i2, n_i3, n_i4, n_i5);
    input  n_i0, n_i1, n_i2, n_i3, n_i4, n_i5;
    output [3:0]o;

    // find how many zeros and ones there are in the first and second half
    wire zero012, one012, two012, three012;
    wire zero345, one345, two345, three345;
    zero1  check0(.o(zero012 ),.a(n_i0),.b(n_i1),.c(n_i2));
    zero1  check1(.o(zero345 ),.a(n_i3),.b(n_i4),.c(n_i5));
    three1 check6(.o(three012),.a(n_i0),.b(n_i1),.c(n_i2));
    three1 check7(.o(three345),.a(n_i3),.b(n_i4),.c(n_i5));
    one1   check2(.o(one012  ),.a(n_i0),.b(n_i1),.c(n_i2));
    one1   check3(.o(one345  ),.a(n_i3),.b(n_i4),.c(n_i5));
    two1   check4(.o(two012  ),.a(n_i0),.b(n_i1),.c(n_i2));
    two1   check5(.o(two345  ),.a(n_i3),.b(n_i4),.c(n_i5));
    

    // find combinations of first and second half
    wire _00, _01, _02, _03, _10, _11, _12, _20, _21, _30, _33;
    AN2 and0(.Z(_00), .A(zero012),  .B(zero345));
    AN2 and1(.Z(_33), .A(three012),  .B(three345));
    AN2 and2(.Z(_01), .A(zero012),  .B(one345));
    AN2 and3(.Z(_02), .A(zero012),  .B(two345));
    AN2 and4(.Z(_03), .A(zero012),  .B(three345));
    AN2 and5(.Z(_10), .A(one012),   .B(zero345));
    AN2 and6(.Z(_11), .A(one012),   .B(one345));
    AN2 and7(.Z(_12), .A(one012),   .B(two345));
    AN2 and8(.Z(_20), .A(two012),   .B(zero345));
    AN2 and9(.Z(_21), .A(two012),   .B(one345));
    AN2 anda(.Z(_23), .A(two012),   .B(three345));
    AN2 andb(.Z(_30), .A(three012), .B(zero345));
    AN2 andc(.Z(_32), .A(three012), .B(two345));

    // calculating 0,1,2,3,5,6     
    wire n_zero, n_one, n_two, n_three, n_five, n_six;
    IV not0(.Z(n_zero),.A(_00));
    IV not1(.Z(n_six),.A(_33));
    NR2 nor0(.Z(n_one), .A(_01), .B(_10));                  
    NR3 nor1(.Z(n_two), .A(_02), .B(_11), .C(_20));          
    NR4 nor2(.Z(n_three),.A(_03),.B(_12),.C(_21),.D(_30));     
    NR2 nor3(.Z(n_five), .A(_23), .B(_32));                  

    // determining output
    wire n_zero_one_two, n_zero_one_two_six , n_two_five, one_two_four_five;
    assign o[3] = n_zero_one_two;
    assign o[2] = n_zero_one_two_six;
    assign o[1] = n_two_five;
    assign o[0] = one_two_four_five;
    ND3 nand0(.Z(n_zero_one_two),.A(n_zero),.B(n_one), .C(n_two));
    ND4 nand1(.Z(n_zero_one_two_six),.A(n_zero),.B(n_one),.C(n_two),.D(n_six));
    ND2 nand2(.Z(n_two_five),.A(n_two),.B(n_five));
    AN3 andd(.Z(one_two_four_five),.A(n_zero),.B(n_three),.C(n_six));


endmodule

module zero1(o,a,b,c);
    input a,b,c;
    output o;
    AN3 and0(.Z(o),.A(a),.B(b),.C(c));
endmodule

module one1(o,a,b,c);
    input  a,b,c;
    output o;
    wire buf0, buf1, buf2, buf3;
    NR2 nor0(.Z(buf0),.A(a),.B(b));
    NR2 nor1(.Z(buf1),.A(a),.B(c));
    NR2 nor2(.Z(buf2),.A(c),.B(b));
    AN3 and0(.Z(buf3),.A(a),.B(b),.C(c));
    NR4 nor3(.Z(o),.A(buf0),.B(buf1),.C(buf2),.D(buf3));
endmodule

module two1(o,a,b,c);
    input  a,b,c;
    output o;
    wire buf0, buf1, buf2, buf3;
    AN2 and0(.Z(buf0),.A(a),.B(b));
    AN2 and1(.Z(buf1),.A(a),.B(c));
    AN2 and2(.Z(buf2),.A(c),.B(b));
    NR3 nor0(.Z(buf3),.A(a),.B(b),.C(c));
    NR4 nor1(.Z(o),.A(buf0),.B(buf1),.C(buf2),.D(buf3));
endmodule

module three1(o,a,b,c);
    input  a,b,c;
    output o;
    NR3 nor0(.Z(o),.A(a),.B(b),.C(c));
endmodule

module b_greater_a(is_c, a, b);

    input  [3:0] a,b;
    output is_c;

    wire n_a0b0_01, n_a1b1_01, n_a2b2_01, n_a3b3_01;
    n_01 eq01_0(.o(n_a0b0_01), .a(a[0]), .b(b[0]));
    n_01 eq01_1(.o(n_a1b1_01), .a(a[1]), .b(b[1]));
    n_01 eq01_2(.o(n_a2b2_01), .a(a[2]), .b(b[2]));
    n_01 eq01_3(.o(n_a3b3_01), .a(a[3]), .b(b[3]));
    
    wire a1b1_10, a2b2_10, a3b3_10;
    is10 eq10_1(.o(a1b1_10), .a(a[1]), .b(b[1]));
    is10 eq10_2(.o(a2b2_10), .a(a[2]), .b(b[2]));
    is10 eq10_3(.o(a3b3_10), .a(a[3]), .b(b[3]));

    wire n_b3_lose, n_b2_lose, n_b1_lose;
    wire n_b3_win, n_b2_win, n_b1_win, n_b0_win;
    wire buffer;
    assign b3_lose = a3b3_10;                                       // (a3, b3) = (0,1)
    OR2 or0(.Z(b2_lose), .A(b3_lose), .B(a2b2_10));                 // b3 lose OR (a2, b2) = (1,0)
    OR2 or1(.Z(buffer),.A(a1b1_10), .B(b3_lose));                   // b2 loos OR (a1, b1) = (1,0)
    OR2 or2(.Z(b1_lose),.A(b2_lose),.B(buffer));

    assign n_b3_win  = n_a3b3_01;                                    // (a3, b3) = (1,0)
    OR2 or3(.Z(n_b2_win), .A(b3_lose), .B(n_a2b2_01));              // b3 did not lose AND (a2,b2) = (0,1)
    OR2 or4(.Z(n_b1_win), .A(b2_lose), .B(n_a1b1_01));              // b2 did not lose AND (a1,b1) = (0,1)
    OR2 or5(.Z(n_b0_win), .A(b1_lose), .B(n_a0b0_01));              // b1 did not lose AND (a0,b0) = (0,1)
    ND4 nand0(.Z(is_c),.A(n_b3_win),.B(n_b2_win),.C(n_b1_win),.D(n_b0_win));

endmodule

module n_01(o,a,b);
    input  a,b;
    output o;
    wire n_a;
    IV not0(.Z(n_a),.A(a));
    ND2 and0(.Z(o),.A(n_a),.B(b));
endmodule

module n_10(o,a,b);
    input a,b;
    output o;
    wire n_b;
    IV not0(.Z(n_b),.A(b));
    ND2 and0(.Z(o),.A(a),.B(n_b));
endmodule

module is01(o,a,b);
    input a,b;
    output o;
    wire n_a;
    IV not0(.Z(n_a),.A(a));
    AN2 and0(.Z(o),.A(n_a),.B(b));
endmodule

module is10(o,a,b);
    input a,b;
    output o;
    wire n_b;
    IV not0(.Z(n_b),.A(b));
    AN2 and0(.Z(o),.A(a),.B(n_b));
endmodule
