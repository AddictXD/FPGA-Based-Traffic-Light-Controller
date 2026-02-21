module traffic_fsm #(
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
    input clk,
    input rst_n,
    input ped_req,

    output reg north_g, north_y, north_r,
    output reg east_g, east_y, east_r,
    output reg south_g, south_y, south_r,
    output reg west_g, west_y, west_r,

    output reg [2:0] north_green_group,
    output reg [2:0] east_green_group,
    output reg [2:0] south_green_group,
    output reg [2:0] west_green_group,

    output reg [1:0] current_dir,
    output reg [7:0] remaining_n,
    output reg [7:0] remaining_e,
    output reg [7:0] remaining_s,
    output reg [7:0] remaining_w
);

    localparam ONE_HZ = CLOCK_FREQ;

    reg [31:0] counter;
    reg sec_tick;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 0;
            sec_tick <= 0;
        end else begin
            if(counter >= ONE_HZ-1) begin
                counter <= 0;
                sec_tick <= 1;
            end else begin
                counter <= counter + 1;
                sec_tick <= 0;
            end
        end
    end

    reg [3:0] state;
    localparam N_G=0, N_Y=1, E_G=2, E_Y=3,
               S_G=4, S_Y=5, W_G=6, W_Y=7;

    reg [7:0] timer;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= N_G;
            timer <= N_GREEN;
        end else if(sec_tick) begin
            if(timer>0) timer <= timer-1;
            else begin
                case(state)
                    N_G: begin state<=N_Y; timer<=N_YELLOW; end
                    N_Y: begin state<=E_G; timer<=E_GREEN; end
                    E_G: begin state<=E_Y; timer<=E_YELLOW; end
                    E_Y: begin state<=S_G; timer<=S_GREEN; end
                    S_G: begin state<=S_Y; timer<=S_YELLOW; end
                    S_Y: begin state<=W_G; timer<=W_GREEN; end
                    W_G: begin state<=W_Y; timer<=W_YELLOW; end
                    W_Y: begin state<=N_G; timer<=N_GREEN; end
                endcase
            end
        end
    end

    always @(*) begin
        north_g=0; north_y=0; north_r=1;
        east_g=0; east_y=0; east_r=1;
        south_g=0; south_y=0; south_r=1;
        west_g=0; west_y=0; west_r=1;

        case(state)
            N_G: begin north_g=1; north_r=0; end
            N_Y: begin north_y=1; north_r=0; end
            E_G: begin east_g=1; east_r=0; end
            E_Y: begin east_y=1; east_r=0; end
            S_G: begin south_g=1; south_r=0; end
            S_Y: begin south_y=1; south_r=0; end
            W_G: begin west_g=1; west_r=0; end
            W_Y: begin west_y=1; west_r=0; end
        endcase
    end

endmodule
