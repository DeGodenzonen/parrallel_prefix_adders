module top #(parameter size=16,parameter Gsize=4)(input [size:1] a, input [size:1] b, input cin,
                             output [size:1] sum ,output  cout);
wire [size:0] p;
wire [size:0] g;
wire [size:0] grp_p;
wire [size:0] grp;
wire [size:0] gn2o;



assign g[0]=cin;
assign p[0]=1'b0;
assign gn2o[0]=cin;
assign grp[1]=g[1];
assign grp_p[0]=cin;


genvar i;
generate
  for(i=1;i<=size;i=i+1)
    begin
     and(g[i],a[i],b[i]);
     xor(p[i],a[i],b[i]);
    end
endgenerate

genvar r,s,t,u;
generate
 for(r=1;r<=size;r=r+Gsize)
 begin
  for(s=r+1;s<=Gsize+r-1;s=s+1)
  begin
     grey dut1(grp[s],g[s],grp[s-1],p[s]);
  end   

  for(t=r;t<=Gsize+r-2;t=t+1)
  begin
     grey dut2(gn2o[t],g[t],gn2o[t-1],p[t]);
  end
  
  assign grp_p[r+Gsize-1]=p[r]&p[r+1]&p[r+2]&p[r+3];
  
  assign gn2o[Gsize+r-1]= grp_p[r+Gsize-1]?gn2o[r-1]:grp[Gsize+r-1];

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



