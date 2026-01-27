module traffic_light_top (
    input clk,
    input reset,
    input ped_NS,
    input ped_EW,
    output reg NS_red, NS_yellow, NS_green,
    output reg EW_red, EW_yellow, EW_green,
    output reg ped_NS_green,
    output reg ped_EW_green
);

    // State encoding
    parameter NS_GREEN  = 3'd0,
              NS_YELLOW = 3'd1,
              ALL_RED_1 = 3'd2,
              EW_GREEN  = 3'd3,
              EW_YELLOW = 3'd4,
              ALL_RED_2 = 3'd5,
              PED_GREEN = 3'd6;

    reg [2:0] state, next_state;
    reg [3:0] timer;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= NS_GREEN;
            timer <= 0;
        end else begin
            if (timer == 4'd9) begin
                state <= next_state;
                timer <= 0;
            end else
                timer <= timer + 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            NS_GREEN:   next_state = NS_YELLOW;
            NS_YELLOW:  next_state = ALL_RED_1;
            ALL_RED_1:  next_state = EW_GREEN;
            EW_GREEN:   next_state = EW_YELLOW;
            EW_YELLOW:  next_state = ALL_RED_2;
            ALL_RED_2:
                if (ped_NS || ped_EW)
                    next_state = PED_GREEN;
                else
                    next_state = NS_GREEN;
            PED_GREEN:  next_state = NS_GREEN;
            default:    next_state = NS_GREEN;
        endcase
    end

    // Output logic
    always @(*) begin
        // Defaults
        NS_red = 1; NS_yellow = 0; NS_green = 0;
        EW_red = 1; EW_yellow = 0; EW_green = 0;
        ped_NS_green = 0;
        ped_EW_green = 0;

        case (state)
            NS_GREEN: begin
                NS_red = 0; NS_green = 1; NS_yellow = 0;
                EW_red = 1; EW_yellow = 0; EW_green = 0;
            end

            NS_YELLOW: begin
                NS_red = 0; NS_yellow = 1; NS_green = 0;
                EW_red = 1; EW_yellow = 0; EW_green = 0;
            end

            ALL_RED_1: begin
                // Defaults already all red
            end

            EW_GREEN: begin
                NS_red = 1; NS_yellow = 0; NS_green = 0;
                EW_red = 0; EW_yellow = 0; EW_green = 1;
            end

            EW_YELLOW: begin
                NS_red = 1; NS_yellow = 0; NS_green = 0;
                EW_red = 0; EW_yellow = 1; EW_green = 0;
            end

            ALL_RED_2: begin
                // Defaults already all red
            end

            PED_GREEN: begin
                // Cars stop
                NS_red = 1; NS_yellow = 0; NS_green = 0;
                EW_red = 1; EW_yellow = 0; EW_green = 0;

                // Pedestrian crossing only if button pressed
                ped_NS_green = ped_NS;
                ped_EW_green = ped_EW;
            end
        endcase
    end

endmodule
