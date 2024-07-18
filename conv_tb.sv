module image_convolution_tb;

    // Параметры для размеров изображения и ядра
    localparam int HEIGHT_OF_KERNEL = 3;
    localparam int WIDTH_OF_IMAGE = 4;

    // Определение фиксированной точки
    localparam int FIXED_POINT_FRACTIONAL_BITS = 8;
    localparam int FIXED_POINT_SCALING_FACTOR = 2**FIXED_POINT_FRACTIONAL_BITS;

    // Объявление сигналов, соответствующих портам модуля image_condensation
    logic [7:0] data_tb [HEIGHT_OF_KERNEL][WIDTH_OF_IMAGE];
    logic [7:0] data_test [5][WIDTH_OF_IMAGE];
    logic unsigned [15:0] kernel_tb [HEIGHT_OF_KERNEL][HEIGHT_OF_KERNEL];
    logic unsigned [31:0] result_tb [WIDTH_OF_IMAGE];
    real fixed_point_value;

    // Создание экземпляра модуля image_condensation
    image_convolution #(
        .HEIGHT_OF_KERNEL(HEIGHT_OF_KERNEL),
        .WIDTH_OF_IMAGE(WIDTH_OF_IMAGE)
    ) dut (
        .data(data_tb),
        .kernel(kernel_tb),
        .result(result_tb)
    );

    // Начальный блок для инициализации и вывода результатов
    initial begin
        // Инициализация входных данных (пример)
        data_test = '{
            '{0, 0, 0, 0},
            '{1, 2, 3, 4},
            '{5, 6, 7, 8},
            '{9, 10, 11, 255},
            '{0, 0, 0, 0}
        };

        // Инициализация ядра (пример, фиксированная точка)
        kernel_tb = '{
            '{16'h0000, 16'h0000, 16'h0000},
            '{16'h0000, 16'h0000, 16'h0000},
            '{16'h0000, 16'h0000, 16'hFFFF}
        };

        for (int p = 0; p < 3; p++) begin
            for (int w = 0; w < WIDTH_OF_IMAGE; w++) begin
                data_tb[0][w] = data_test[p][w];
                data_tb[1][w] = data_test[p+1][w];
                data_tb[2][w] = data_test[p+2][w];
            end
            // Небольшая задержка для вывода результатов после применения свертки
            #10;
            // Вывод результатов на экран
            $display("Input data:");
            for (int i = 0; i < HEIGHT_OF_KERNEL; i++) begin
                for (int j = 0; j < WIDTH_OF_IMAGE; j++) begin
                    $display("data[%d][%d] = %d", i, j, data_tb[i][j]);
                end
            end
            $display("\nKernel:");
            for (int i = 0; i < HEIGHT_OF_KERNEL; i++) begin
                for (int j = 0; j < HEIGHT_OF_KERNEL; j++) begin
                    // Конвертация фиксированного числа в десятичное значение
                    fixed_point_value = kernel_tb[i][j];
                    fixed_point_value = fixed_point_value / FIXED_POINT_SCALING_FACTOR;
                    $display("kernel[%d][%d] = %0.9f", i, j, fixed_point_value);
                end
            end
            $display("\nResult:");
            for (int i = 0; i < WIDTH_OF_IMAGE; i++) begin
                // Конвертация фиксированного числа в десятичное значение
                fixed_point_value = result_tb[i];
                fixed_point_value = fixed_point_value / FIXED_POINT_SCALING_FACTOR;
                $display("result[%d] = %0.9f", i, fixed_point_value);
            end

        end
        $finish;
    end
endmodule