module rxmodule (
    input wire signal,
    input wire clk,
    input wire read,
    output reg [7:0] outsignal
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg [31:0] address;
    reg [255:0] rxmem;
    reg receiving;

    initial begin
        address = 32'h00000000; // Correct initialization syntax
        receiving = 1'b0; // Initial state
        bit_count = 3'b0; // Initial count
    end

    always @(posedge clk) begin
        if (!read) begin
            if (signal == 0) begin  
                receiving <= 1'b1;  
                bit_count <= 3'b0;  
                shift_reg <= 8'b0;   
            end else if (receiving) begin
                if (bit_count < 8) begin
                    shift_reg[bit_count] <= signal; 
                    bit_count <= bit_count + 1;      
                end else if (signal == 1 && bit_count == 8) begin
                    rxmem[address * 8 +: 8] <= shift_reg; // Store received byte
                    address <= address + 1;
                    receiving <= 1'b0;                
                end
            end
        end
    end

    always @(posedge clk) begin
        if (read && address != 0) begin
            outsignal <= rxmem[7:0];
            address <= address - 1;
            // Shift memory contents
            for (integer i = 0; i < address; i = i + 1) begin
                rxmem[i * 8 +: 8] <= rxmem[(i + 1) * 8 +: 8];
            end
        end
    end
endmodule

module txmodule (
    input wire [7:0] signal,
    input wire clk,
    input wire read,
    output reg signal_out // Renamed to avoid confusion
);
    reg [255:0] txmem;
    reg [31:0] address;

    initial begin
        address = 32'h00000000; // Correct initialization syntax
    end

    always @(posedge clk) begin
        if (!read) begin
            txmem[address * 8 +: 8] <= signal;
            address <= address + 1;
        end
    end

    always @(posedge clk) begin
        if (read && address != 0) begin
            signal_out <= txmem[0]; // Transmit the first byte
            // Shift memory contents
            for (integer i = 0; i < address - 1; i = i + 1) begin
                txmem[i * 8 +: 8] <= txmem[(i + 1) * 8 +: 8];
            end
            address <= address - 1;
        end else begin
            signal_out <= 1; // Idle signal
        end
    end
endmodule

module control_unit (
    input wire clk,
    input wire read,
    input wire signal,
    output reg tx_signal,
    output reg rx_start,
    output reg tx_start
);

    reg [1:0] current_state, next_state;

    always @(posedge clk) begin
        current_state <= next_state;
    end

    always @(*) begin
        rx_start = 0;
        tx_start = 0;
        tx_signal = 1; // Idle state

        case (current_state)
            2'b00: begin
                if (!signal) begin
                    next_state = 2'b01;
                end else if (read) begin
                    next_state = 2'b10;
                end else begin
                    next_state = 2'b00;
                end
            end
            2'b01: begin
                rx_start = 1; 
                next_state = 2'b00; 
            end
            2'b10: begin
                tx_start = 1; 
                tx_signal = 0; 
                next_state = 2'b00; 
            end
            default: next_state = 2'b00;
        endcase
    end
endmodule

module uart_system (
    input wire signal,
    input wire clk,
    input wire read,
    output reg tx_signal,
    output reg [7:0] outsignal
);
    wire rx_start;
    wire tx_start;
    wire [7:0] rx_data;

    rxmodule receiver (
        .signal(signal),
        .clk(clk),
        .read(read),
        .outsignal(rx_data)
    );

    txmodule transmitter (
        .signal(rx_data),
        .clk(clk),
        .read(tx_start),
        .signal_out(tx_signal)
    );

    control_unit ctrl (
        .clk(clk),
        .read(read),
        .signal(signal),
        .tx_signal(tx_signal),
        .rx_start(rx_start),
        .tx_start(tx_start)
    );

    always @(posedge clk) begin
        if (tx_start) begin
            outsignal <= tx_signal;//without start stop bit.
        end
    end
endmodule

