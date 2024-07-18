module image_convolution #(
    parameter int HEIGHT_OF_KERNEL = 3,
    parameter int WIDTH_OF_IMAGE = 4
) (
    input logic [7:0] data [HEIGHT_OF_KERNEL][WIDTH_OF_IMAGE],
    input logic unsigned [15:0] kernel [HEIGHT_OF_KERNEL][HEIGHT_OF_KERNEL],
    output logic unsigned [31:0] result [WIDTH_OF_IMAGE]
);
    // Calculated parameter for the half kernel size
    localparam int P = HEIGHT_OF_KERNEL / 2;

    // Internal variable
    int sum;

    always_comb begin
        // Iterate over each pixel in the image
        for (int i = 0; i < WIDTH_OF_IMAGE; i++) begin
            sum = 0;
            // Apply convolution
            for (int k = -P; k <= P; k++) begin
                for (int l = -P; l <= P; l++) begin
                    // Boundary check
                    if ((i+l) >= 0 && (i+l) < WIDTH_OF_IMAGE) begin
                        sum += data[P+k][i+l] * kernel[P+k][P+l];
                    end
                end
            end
            result[i] = sum;
        end
    end
endmodule