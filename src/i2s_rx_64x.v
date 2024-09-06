


module i2s_rx_64x #(
    parameter DATA_WIDTH = 16  // Number of bits per audio sample
)(
    input wire rst,             // Reset signal
    input wire bclk,            // Bit clock (3.072 MHz)
    input wire lrclk,           // Left/Right clock (48 kHz)
    input wire sdin,            // Serial data input
    output reg [DATA_WIDTH-1:0] left_data,   // Parallel output for left channel
    output reg [DATA_WIDTH-1:0] right_data,  // Parallel output for right channel
    output reg left_data_valid,                       // Left Data valid signal
    output reg right_data_valid                       // Right Data valid signal
);

    reg [DATA_WIDTH-1:0] shift_reg;  // Shift register for serial data
    reg [5:0] bit_count;             // Counter for bits (0 to 63)
    reg lrclk_prev;                  // Previous state of lrclk

    always @(posedge bclk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            bit_count <= 0;
            left_data <= 0;
            right_data <= 0;
            left_data_valid <= 0;
            right_data_valid <= 0;
            lrclk_prev <= 0;
        end else begin
            lrclk_prev <= lrclk;  // Capture previous state of lrclk

            if (lrclk_prev != lrclk) begin
                // Detect rising or falling edge of lrclk
                bit_count <= 0;  // Reset bit counter at LRCLK edge


                if (lrclk) begin
                    // Rising edge of LRCLK: end of right channel, start of left
                    right_data <= shift_reg;
                    right_data_valid <= 1; // Signal that right data is valid after the shift
                end else begin
                    // Falling edge of LRCLK: end of left channel, start of right
                    left_data <= shift_reg;
                    left_data_valid <= 1; // Signal that left data is valid after the shift
                end
            end else begin
                if (bit_count < DATA_WIDTH) begin
                    // Shift in serial data
                    shift_reg <= {shift_reg[DATA_WIDTH-2:0], sdin};
                end

                // Increment bit counter
                bit_count <= bit_count + 1;
                right_data_valid <= 0;  // Data is not valid during the bit shifting
                left_data_valid <= 0;  // Data is not valid during the bit shifting
            end
        end
    end

endmodule

