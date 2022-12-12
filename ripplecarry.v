`timescale 1ns / 1ps



module main #(parameter size=4) (input [size:1] a, input [size:1] b, input cin,
             output [size:1] sum ,output  cout);

wire [size:1] p;
wire [size:1] g;
wire [size:0] grg;
assign grg[0]=cin;

genvar i;
generate
  for(i=1;i<=size;i=i+1)
    begin
     and(g[i],a[i],b[i]);
     xor(p[i],a[i],b[i]);
    end
endgenerate


genvar k;
generate
  for(k=0;k<size;k=k+1)
   begin
     grey #(2) dut (grg[k+1],{g[k+1],grg[k]}, p[k+1]);
     
   end  
endgenerate
assign cout= grg[size];

genvar l;
generate
  for(l=1;l<=size;l=l+1)
  begin
   xor(sum[l],grg[l-1],p[l]);
   end
 endgenerate
endmodule


