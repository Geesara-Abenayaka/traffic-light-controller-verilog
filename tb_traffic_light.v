`timescale 1ns/1ns

module tb_traffic_light;

    // Testbench signals
    reg clk, reset;
    reg ped_NS, ped_EW;

    wire NS_red, NS_yellow, NS_green;
    wire EW_red, EW_yellow, EW_green;
    wire ped_NS_green, ped_EW_green;

    // Instantiate the DUT
    traffic_light_top DUT (
        .clk(clk),
        .reset(reset),
        .ped_NS(ped_NS),
        .ped_EW(ped_EW),
        .NS_red(NS_red),
        .NS_yellow(NS_yellow),
        .NS_green(NS_green),
        .EW_red(EW_red),
        .EW_yellow(EW_yellow),
        .EW_green(EW_green),
        .ped_NS_green(ped_NS_green),
        .ped_EW_green(ped_EW_green)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;  // 5 ns half-period → 10 ns full period

    // Stimulus
    initial begin
        // Initialize
        reset = 1;
        ped_NS = 0;
        ped_EW = 0;

        #20 reset = 0;   // Release reset after 20 ns

        // Pedestrian NS presses button at 200 ns
        #180 ped_NS = 1;
        #20 ped_NS = 0;

        // Pedestrian EW presses button at 500 ns
        #280 ped_EW = 1;
        #20 ped_EW = 0;

        // Finish simulation after enough cycles
        #600 $finish;
    end

    // Monitor signals to console
    initial begin
        $monitor("TIME=%0t ns | NS[G,Y,R]=%b%b%b | EW[G,Y,R]=%b%b%b | PED_NS=%b PED_EW=%b",
                 $time,
                 NS_green, NS_yellow, NS_red,
                 EW_green, EW_yellow, EW_red,
                 ped_NS_green, ped_EW_green);
    end

endmodule
