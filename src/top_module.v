// Needs: 
module top_module(
    input wire bit_clk,
    input wire lr_clk,
    input wire rst,
    input wire sdin,
    output wire left_channel,
    output wire right_channel
);


wire [15:0] i2s_data_L;
wire [15:0] i2s_data_R;
wire i2s_data_L_valid;
wire i2s_data_R_valid;

    i2s_rx_64x u_i2s_rx_64x(
    .rst(rst),             
    .bclk(bit_clk),            
    .lrclk(lr_clk),          
    .sdin(sdin),           
    .left_data(i2s_data_L),   
    .right_data(i2s_data_R),  
    .left_data_valid(i2s_data_L_valid),                       
    .right_data_valid(i2s_data_R_valid)    

    );
 
    pwm_generator u_pwm_generator_L(
        .clk(bit_clk),
        .rst(rst),
        .duty_cycle(i2s_data_L[15:8]),
        .pwm_out(left_channel)
    );
    pwm_generator u_pwm_generator_R(
        .clk(bit_clk),
        .rst(rst),
        .duty_cycle(i2s_data_R[15:8]),
        .pwm_out(right_channel)
    );


endmodule


