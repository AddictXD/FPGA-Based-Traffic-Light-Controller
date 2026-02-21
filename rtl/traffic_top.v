`timescale 1ns / 1ps

module traffic_top #(
    parameter CLOCK_FREQ = 100_000_000,
    parameter ALL_RED_SEC = 1,
    parameter N_GREEN = 10,
    parameter N_YELLOW = 3,
    parameter E_GREEN = 8,
    parameter E_YELLOW = 3,
    parameter S_GREEN = 10,
    parameter S_YELLOW = 3,
    parameter W_GREEN = 8,
    parameter W_YELLOW = 3,
    parameter BLINK_LEDS = 3
)(
    input  wire clk,
    input  wire rst_n,
    input  wire ped_req,

    output wire north_green, north_yellow, north_red,
    output wire east_green,  east_yellow,  east_red,
    output wire south_green, south_yellow, south_red,
    output wire west_green,  west_yellow,  west_red,

    output wire [2:0] north_green_group,
    output wire [2:0] east_green_group,
    output wire [2:0] south_green_group,
    output wire [2:0] west_green_group,

    output wire [6:0] seg,
    output wire dp,
    output wire [7:0] anode
);

    wire ng, ny, nr, eg, ey, er, sg, sy, sr, wg, wy, wr;
    wire [2:0] ng_grp, eg_grp, sg_grp, wg_grp;
    wire [7:0] rem_n, rem_e, rem_s, rem_w;
    wire [1:0] current_phase;

    traffic_fsm #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .ALL_RED_SEC(ALL_RED_SEC),
        .N_GREEN(N_GREEN),
        .N_YELLOW(N_YELLOW),
        .E_GREEN(E_GREEN),
        .E_YELLOW(E_YELLOW),
        .S_GREEN(S_GREEN),
        .S_YELLOW(S_YELLOW),
        .W_GREEN(W_GREEN),
        .W_YELLOW(W_YELLOW),
        .BLINK_LEDS(BLINK_LEDS)
    ) fsm_i (
        .clk(clk),
        .rst_n(rst_n),
        .ped_req(ped_req),

        .north_g(ng), .north_y(ny), .north_r(nr),
        .east_g(eg),  .east_y(ey),  .east_r(er),
        .south_g(sg), .south_y(sy), .south_r(sr),
        .west_g(wg),  .west_y(wy),  .west_r(wr),

        .north_green_group(ng_grp),
        .east_green_group(eg_grp),
        .south_green_group(sg_grp),
        .west_green_group(wg_grp),

        .current_dir(current_phase),
        .remaining_n(rem_n),
        .remaining_e(rem_e),
        .remaining_s(rem_s),
        .remaining_w(rem_w)
    );

    assign north_green = ng;
    assign north_yellow = ny;
    assign north_red = nr;

    assign east_green = eg;
    assign east_yellow = ey;
    assign east_red = er;

    assign south_green = sg;
    assign south_yellow = sy;
    assign south_red = sr;

    assign west_green = wg;
    assign west_yellow = wy;
    assign west_red = wr;

    assign north_green_group = ng_grp;
    assign east_green_group  = eg_grp;
    assign south_green_group = sg_grp;
    assign west_green_group  = wg_grp;

    ssd_driver_8digits ssd_i (
        .clk(clk),
        .rst_n(rst_n),

        .digit0(rem_n / 10),
        .digit1(rem_n % 10),
        .digit2(rem_e / 10),
        .digit3(rem_e % 10),
        .digit4(rem_s / 10),
        .digit5(rem_s % 10),
        .digit6(rem_w / 10),
        .digit7(rem_w % 10),

        .seg(seg),
        .dp(dp),
        .anode(anode)
    );

endmodule
