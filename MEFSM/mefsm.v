module mefsm(
    input      clk,
    input      rst,
    input      a,
    output reg b);

reg [2 : 0]    state;

localparam     STATE_0 = 3'b000;
localparam     STATE_1 = 3'b001;
localparam     STATE_2 = 3'b011;

always @(posedge clk)
begin
    if(rst)
    begin
        b     <= 1'b0;
        state <= STATE_0;
    end else begin
    case(state)
    STATE_0:
    begin
        if(a)
        begin
            state <= STATE_1;
            b     <= 1'b0;
        end else begin
            state <= STATE_2;
            b     <= 1'b0;
        end
    end

    STATE_1:
    begin
        if(a)
        begin
            state <= STATE_0;
            b     <= 1'b1;
        end else begin
            state <= STATE_2;
            b     <= 1'b0;
        end
    end

    STATE_2:
    begin
        if(a)
        begin
            state <= STATE_1;
            b     <= 1'b0;
        end else begin
            state <= STATE_0;
            b     <= 1'b1;
        end
    end

    default:
    begin
        state <= STATE_0;
        b     <= 1'b0;
    end
    endcase
    end
end
endmodule
