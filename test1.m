tx_data = '10101101001001110101000011001110101100011011';
% disp(tx_data)

num_subcarriers = 8;

sysconfig = struct("modulation", "QPSK", ...
                             "subcarriers", num_subcarriers, ...
                             "cp_length", ceil(2 * num_subcarriers * 0.15), ...
                             "channel_response", [0.2, 0.1]);

test = simulator(tx_data, sysconfig);

disp("------------------------ Test 1 -------------------------------")
load test1.mat 
sol = res;

disp("1. Checking bit stream and codeword length after Lempel Ziv encoding")
if sol.tx_bitstream == test.tx_bitstream && sol.codeword_len == test.codeword_len
    disp("Passed")
else
    disp("Failed")
end

disp("2. Checking symbol stream after mapping")
if sol.tx_bitstream == test.tx_bitstream
    disp("Passed")
else
    disp("Failed")
end

disp("3. Checking transmitted ofdm waveform")
if max(abs(sol.ofdm_waveform - test.ofdm_waveform)) < 1e-3
    disp("Passed")
else
    disp("Failed")
end

disp("4. Checking received symbol stream")
if length(sol.rx_symbol_stream) == length(test.rx_symbol_stream) && ...
        max(abs(sol.rx_symbol_stream - test.rx_symbol_stream)) < 1e-3
    disp("Passed")
else
    disp("Failed")
end

disp("5. Checking received bit stream")
if sol.rx_bitstream == test.rx_bitstream
    disp("Passed")
else
    disp("Failed")
end

disp("6. Checking received data")
if sol.rx_data == test.rx_data
    disp("Passed")
else
    disp("Failed")
end