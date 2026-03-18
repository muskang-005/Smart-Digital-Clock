`timescale 1ns / 1ps

module Smart_Clock_tb;

reg clk;
reg reset;
reg button;

wire [3:0] d1,d2,d3,d4,d5,d6;
wire [5:0] date;
wire [3:0] month;
wire [11:0] year;
wire [2:0] day;
wire am_pm;

// DUT
Smart_Clock uut (
    .clk(clk),
    .reset(reset),
    .button(button),
    .d1(d1), .d2(d2), .d3(d3),
    .d4(d4), .d5(d5), .d6(d6),
    .date(date),
    .month(month),
    .year(year),
    .day(day),
    .am_pm(am_pm)
);

//clock
always #5 clk = ~clk;

//Monitor
initial
begin
    $monitor("Time=%0t | Display=%0d%0d:%0d%0d:%0d%0d | AM_PM=%0d",
        $time,
        d1,d2,d3,d4,d5,d6,
        am_pm
    );
end


// TEST
initial
begin
    clk = 0;
    reset = 1;
    button = 0;

    #20 reset = 0;

    // let time run
    #200;

    // press button → DATE
    button = 1; 
    #10;
    button = 0;

    #200;

    // press button → DAY
    button = 1; 
    #10; 
    button = 0;

    #200;

    // press button → TIME
    button = 1; 
    #10; 
    button = 0;

    #200;

    $stop;
end

endmodule
