`timescale 1ns / 1ps

module cla#(parameter size=16,parameter Gsize=4)(input [size:1] a, input [size:1] b, input cin,
                             output [size:1] sum ,output  cout);
wire [size:0] p;
wire [size:0] g;
wire [size:0] pn2;
wire [size:0] gn2;
wire [size:0] gn2o;

assign g[0]=cin;
assign p[0]=1'b0;
assign gn2o[0]=cin;


genvar i;
generate
  for(i=1;i<=size;i=i+1)
    begin
     and(g[i],a[i],b[i]);
     xor(p[i],a[i],b[i]);
    end
endgenerate

genvar j,k,m;
generate
  for(j=1;j<=size;j=j+Gsize)
    begin
      
      black #(4) dut1(gn2[j+Gsize-1],pn2[j+Gsize-1],{g[j+Gsize-1],g[j+Gsize-2],g[j+Gsize-3],g[j+Gsize-4]}
                      ,{p[j+Gsize-1],p[j+Gsize-2],p[j+Gsize-3],p[j+Gsize-4]}); // black cell from 1 to 4 and so on for group p
              
     grey #(2) dut3(gn2o[j+Gsize-1],{gn2[j+Gsize-1],gn2o[j-1]},pn2[j+Gsize-1]);
               
     for(k=j;k<=Gsize+j-2;k=k+1) // 1 to 3 and so on
     begin
       grey #(2) dut2(gn2o[k],{g[k],gn2o[k-1]},p[k]);
     end
   end
 endgenerate

genvar x;
  generate
  for(x=1;x<=size;x=x+1)
   begin
   xor(sum[x],gn2o[x-1],p[x]);
   end
   assign cout=gn2o[size];
endgenerate
endmodule



