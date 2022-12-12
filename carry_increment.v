`timescale 1ns / 1ps
module top#(parameter size=16,parameter Gsize=4)(input [size:1] a, input [size:1] b, input cin,
                             output [size:1] sum ,output  cout);
wire [size:0] p;
wire [size:0] g;
wire [size:0] gn2o;
wire [size:0] b_g;
wire [size:0] b_p;


assign g[0]=cin;
assign gn2o[0]=cin;

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
for(k=1;k<Gsize;k=k+1)
begin
  grey #(2) dut(gn2o[k],{g[k],gn2o[k-1]},p[k]);
end
endgenerate


genvar m,n,q;
generate
for(m=Gsize+1;m<=size;m=m+Gsize)
begin
  assign b_g[m-1] = g[m-1];
  assign b_p[m-1] = p[m-1];
 
  for(n=m;n<=m+Gsize-2;n=n+1)
  begin
    black #(2) dut2(b_g[n],b_p[n],{g[n],b_g[n-1]},{p[n],b_p[n-1]}); 
  end
  
  for(q=m-1;q<=m+Gsize-2;q=q+1)
  begin
     grey #(2) dut3(gn2o[q],{b_g[q],b_p[q]},gn2o[m-2]);
  end
  end
endgenerate

assign gn2o[size]=g[size]+(p[size]&gn2o[size-1]);
 
genvar x;
  generate
  for(x=1;x<=size;x=x+1)
   begin
   xor(sum[x],gn2o[x-1],p[x]);
   end
   assign cout= gn2o[size] ;
endgenerate
endmodule
