`timescale 1ns / 1ps

module Smart_Clock(
    input clk,
    input reset,
    input button,

    output reg [3:0] d1,d2,d3,d4,d5,d6, // DISPLAY DIGITS
    output reg [5:0] date,
    output reg [3:0] month,
    output reg [11:0] year,
    output reg [2:0] day,
    output reg am_pm
);
// Clock divider

reg [25:0] count;
reg clk_1s;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        count <= 0;
        clk_1s <= 0;
    end
    else
    begin
        if(count == 49)
        begin
            count <= 0;
            clk_1s <= ~clk_1s;
        end
        else
            count <= count + 1;
    end
end

//button for display mode change
reg [1:0] mode;
reg button_prev;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        mode <= 0;
        button_prev <= 0;
    end
    else
    begin
        button_prev <= button;

        if(button && !button_prev)
        begin
            if(mode == 2) // as only 3 display required
                mode <= 0;
            else
                mode <= mode + 1;
        end
    end
end

//leap year check

reg leap_year;

always @(*)
begin
    if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
        leap_year = 1;
    else
        leap_year = 0;
end

//max days in a month

reg [5:0] max_day;

always @(*)
begin
    case(month)
        1,3,5,7,8,10,12: max_day = 31;
        4,6,9,11: max_day = 30;
        2: max_day = (leap_year) ? 29 : 28;
        default: max_day = 31;
    endcase
end


reg [3:0] h1,h2,m1,m2,s1,s2;

// TIME COUNTER (12H FORMAT)
always @(posedge clk_1s or posedge reset)
begin
    if(reset)
    begin
        h1<=1; h2<=2;   // 12:00:00 AM
        m1<=0; m2<=0;
        s1<=0; s2<=0;

        am_pm <= 0;

        date <= 1;
        month <= 1;
        year <= 2025;
        day <= 0;
    end
    else
    begin
        if(s2==9)
        begin
            s2<=0;

            if(s1==5)
            begin
                s1<=0;

                if(m2==9)
                begin
                    m2<=0;

                    if(m1==5)
                    begin
                        m1<=0;

                        // 11 → 12
                        if(h1==1 && h2==1)
                        begin
                            h1<=1; h2<=2;
                            am_pm <= ~am_pm;
                        end

                        // 12 → 01
                        else if(h1==1 && h2==2)
                        begin
                            h1<=0; h2<=1;

                            // midnight update
                            if(am_pm == 1)
                            begin
                                if(date == max_day)
                                begin
                                    date <= 1;

                                    if(month == 12)
                                    begin
                                        month <= 1;
                                        year <= year + 1;
                                    end
                                    else
                                        month <= month + 1;
                                end
                                else
                                    date <= date + 1;

                                if(day == 6)
                                    day <= 0;
                                else
                                    day <= day + 1;
                            end
                        end

                        else if(h2==9)
                        begin
                            h2<=0;
                            h1<=h1+1;
                        end
                        else
                            h2<=h2+1;

                    end
                    else
                        m1<=m1+1;
                end
                else
                    m2<=m2+1;
            end
            else
                s1<=s1+1;
        end
        else
            s2<=s2+1;
    end
end

// DISPLAY CONTROL

always @(*)
begin
    case(mode)

        // MODE 0 → TIME
        2'd0:
        begin
            d1 = h1;
            d2 = h2;
            d3 = m1;
            d4 = m2;
            d5 = s1;
            d6 = s2;
        end

        // MODE 1 → DATE (DD-MM-YY)
        2'd1:
        begin
            d1 = date / 10;
            d2 = date % 10;

            d3 = month / 10;
            d4 = month % 10;

            d5 = (year % 100) / 10;
            d6 = (year % 100) % 10;
        end

        // MODE 2 → DAY
        2'd2:
        begin
            d1 = 0;
            d2 = day;

            d3 = 0;
            d4 = 0;
            d5 = 0;
            d6 = 0;
        end

        default:
        begin
            d1=0; d2=0; d3=0; d4=0; d5=0; d6=0;
        end

    endcase
end

endmodule
