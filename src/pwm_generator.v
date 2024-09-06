module pwm_generator #(
    parameter WIDTH = 8, // 14-bit input
    parameter CLOCK_DIV = 192
)(
    input wire clk,       // 3.072 mHz Input clock
    input wire rst,       // Reset signal
    input wire [WIDTH-1:0] duty_cycle, // 14-bit input for PWM duty cycle
    output reg pwm_out    // PWM output signal
);

    // Counter to control the PWM duty cycle
    reg [WIDTH-1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            // Increment the counter
            counter <= counter + 1;
            if(counter == CLOCK_DIV-1) begin
                counter <= 0;
            end
            // Compare the counter to the duty cycle input
            if (counter < duty_cycle)
                pwm_out <= 1; // Output high if counter is less than duty cycle
            else
                pwm_out <= 0; // Output low otherwise
        end
    end

endmodule
 