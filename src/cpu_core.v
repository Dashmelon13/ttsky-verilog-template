`default_nettype none

module cpu_core (

    input  wire       clk,
    input  wire       rst_n,

    input  wire [7:0] instruction,

    output wire [7:0] alu_out,

    output reg [3:0] pc


);


//Instruction Decoder

    wire [2:0] opcode = instruction[7:5];

    wire [1:0] rd_addr = instruction[4:3];

    wire [1:0] rs_addr = instruction[1:0];

    wire [7:0] imm_val = {5'b0,instruction[2:0]};
    
//Control Unit

    reg reg_write_en;

    reg alu_src_imm;

    reg [2:0] alu_op;
    
    always @(*) begin
        case (opcode)
            3'b000: begin // NOP
                reg_write_en = 1'b0;
                alu_src_imm  = 1'b0;
                alu_op       = 3'b000;
            end
            3'b001: begin // MOVI
                reg_write_en = 1'b1;
                alu_src_imm  = 1'b1;
                alu_op       = 3'b000;
            end
            3'b010: begin // ADD
                reg_write_en = 1'b1;
                alu_src_imm  = 1'b0;
                alu_op       = 3'b001;
            end
            3'b011: begin // SUB
                reg_write_en = 1'b1;
                alu_src_imm  = 1'b0;
                alu_op       = 3'b010;
            end
            3'b100: begin // AND
                reg_write_en = 1'b1;
                alu_src_imm  = 1'b0;
                alu_op       = 3'b011;
            end
            3'b101: begin // OR
                reg_write_en = 1'b1;
                alu_src_imm  = 1'b0;
                alu_op       = 3'b100;
            end
            default: begin // Default NOP
                reg_write_en = 1'b0;
                alu_src_imm  = 1'b0;
                alu_op       = 3'b000;
            end
        endcase
    end
    
    
// Program Counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 4'd0;
        end else begin
            pc <= pc + 1'b1; // Increments every clock cycle
        end
    end



// Register File

    reg [7:0] registers [0:3];
    wire [7:0] rd_data = registers[rd_addr];
    wire [7:0] rs_data = registers[rs_addr];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                registers[i] <= 8'h00;
            end
        end else if (reg_write_en) begin
            registers[rd_addr] <= alu_out;
        end
    end

// ALU

    wire [7:0] operand_b = (alu_src_imm) ? imm_val : rs_data;
    reg  [7:0] alu_result;

    always @(*) begin
        case (alu_op)
            3'b000:  alu_result = operand_b;           // MOVI
            3'b001:  alu_result = rd_data + operand_b; // ADD
            3'b010:  alu_result = rd_data - operand_b; // SUB
            3'b011:  alu_result = rd_data & operand_b; // AND
            3'b100:  alu_result = rd_data | operand_b; // OR
            default: alu_result = 8'h00;
        endcase
    end

    assign alu_out = alu_result;

endmodule

`default_nettype wire