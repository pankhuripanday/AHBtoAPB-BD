module AHB_slave( Hclk, Hresetn, Hwrite, Hreadyin, Htrans,Haddr,Hwdata,Hresp,Hrdata, valid, Hwritereg,Haddr1,Haddr2,Hwdata1,Hwdata2, tempselx);
   
 input Hclk, Hresetn, Hwrite, Hreadyin;
 input [1:0]Htrans;
 input [31:0]Haddr;
 input  [31:0]Hwdata;
 output [1:0]Hresp;
 output [31:0]Hrdata;
 output reg valid;
 output reg Hwritereg;
 output reg [31:0]Haddr1;
 output reg [31:0]Haddr2;
 output reg[31:0]Hwdata1;
 output reg [31:0]Hwdata2;
 output reg [2:0] tempselx;
 
reg temp;  

//valid logic

always @(*)
begin
 valid =1'b0; //default
 if (Hreadyin==1 && (Htrans[1:0]==2'b10|Htrans[1:0]==2'b11) && (Haddr[31:0]>=32'h80000000 && Haddr[31:0]<32'h8C000000) )


 valid=1'b1;
 else
 valid=1'b0;
end

//tempselect logic for selecting slave

always @(Haddr)
begin
  //tempselx[2:0] = 3'b000;
  
 
     if(Haddr>=32'h80000000 && Haddr<32'h84000000)

       tempselx=3'b001;
     else if (Haddr>=32'h84000000 && Haddr<32'h88000000)

       tempselx=3'b010;
     else if (Haddr>=32'h88000000 && Haddr<32'h8C000000)
       tempselx=3'b100;
     else
       tempselx=3'b000;
     
end

//address and Data pipeline logic

always @(posedge Hclk or negedge Hresetn)
begin
 if(!Hresetn)
   begin
   //Address Pipeline
   Haddr1<=32'b0;
   Haddr2<=32'b0;

   //Data Pipeline
   Hwdata1<=32'b0;
   Hwdata2<=32'b0;

   Hwritereg<=0;
   end

 else
   begin
   //Address Pipeline
   Haddr1<=Haddr;
   Haddr2<=Haddr1;

   //Data Pipeline
   Hwdata1<=Hwdata;
   Hwdata2<=Hwdata1;

   temp<=Hwrite;
   Hwritereg<=temp;

   end

end

assign Hresp = 2'b00;
//assign Hwritereg = Hwrite;

endmodule

