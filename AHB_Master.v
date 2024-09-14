
module AHB_Master(input Hclk,Hresetn,Hreadyout,input [31:0] Hrdata, output reg [31:0] Haddr, Hwdata, output reg Hwrite, Hreadyin, output reg [1:0] Htrans);



reg [2:0] Hburst;
reg [2:0] Hsize;

/*always begin
       Hclk=1'b1;
       forever #10 Hclk=~Hclk;
       end*/

integer i,j;
   task single_write();
      begin
        @(posedge Hclk)
             #1;
      begin
      
        // Hresetn=1;
         Hwrite=1;
         Htrans=2'd2; //non sequential transfer
         Hsize=0;  //1 byte data
         Hburst=0; //single transfer
         Hreadyin=1;
         Haddr=32'h80000001;
     
     
       end

       @(posedge Hclk)
            #1;
      begin
         Htrans=2'd0; //as it is single transfer so next transfer should not happen
         Hwdata=8'h80;//in single write transfer in first cycle address need to be sent and in next cycle data,see from waveform
        // Hreadyin=0;
        // Hwrite=0;
       end
     end
   endtask

  task single_read();
     begin
     @(posedge Hclk)
        
       begin
         Hwrite=0;
         Htrans=2'd2;
         Hsize=0;
         Hburst=0;
         Hreadyin=1;
         Haddr=32'h80000001;
       end

      @(posedge Hclk)#1;
        begin
        Htrans=2'd0;
        end
     end
    endtask

   task burst_write();
     begin
       @(posedge Hclk)#1;
       begin
        Hwrite=1'b1;
        Htrans=2'd2;
        Hsize=0;
        Hburst=3'd3; //incr 4  type
        Hreadyin=1;
        Haddr=32'h80000001;
       end

      @(posedge Hclk)#1;
      begin
      Haddr=Haddr+1'b1;
      Hwdata=($random)%256;
      Htrans=2'd3; //after 1st cycle next transfers will be sequential
      end

for(i=0;i<2;i=i+1)
begin
@(posedge Hclk);#1;
Haddr=Haddr+1;
Hwdata=($random)%256;
Htrans=2'd3;
end

@(posedge Hclk);#1;
begin
Hwdata=($random)%256;
Htrans=2'd0; //for last transfer Htrans will be 0
end
end
endtask


task wrap_write();
begin
@(posedge Hclk)#1;
begin
Hwrite=1'b1;
Htrans=2'b10;
Hsize=1; //2 byte size
Hburst=2;//wrap 4
Hreadyin=1;
Haddr=32'h80000048;
end

@(posedge Hclk)#1;
begin
Htrans=2'b11;
Haddr={Haddr[31:3],Haddr[2:1]+1'b1,Haddr[0]};
Hwdata=($random)%256;
end

for(j=0;j<2;j=j+1)
begin
@(posedge Hclk)#1;
Htrans=2'b11;
Haddr={Haddr[31:3],Haddr[2:1]+1'b1,Haddr[0]};
Hwdata=($random)%256;
end

@(posedge Hclk)#1;
begin
Htrans=2'b00;
Hwdata=($random)%256;
end

end
endtask 

endmodule







