function symbol_stream = ofdm_demodulator(waveform, subcarriers, cp_length, channel_response)
    % Hint: CP length could be different from the length of channel response
    
    % Input: channel_response is a vector, indicating the impulse response
    % Output: symbol_stream is a vector of symbols

    % Input: 
    % waveform: Received OFDM waveform,
    % subcarriers: the number of subcarriers,
    % cp_length: the length of CP,
    % channel_response: the impulse response of the channel.

    % Output: symbol_stream: Demodulated vector of symbols.

    % Calculate the total number of symbols in the received waveform
    N = length(channel_response);
    N_fft = 2 * subcarriers; % Double the number of subcarriers
    num_symbols = floor(length(waveform) / (N_fft + cp_length));

    % Initialize the symbol stream
    symbol_stream = [];

    % Precompute the Fourier transform of the channel response
    H = fft(channel_response, N_fft); % Frequency response of the channel

    % Ensure no division by zero or very small values
    H(abs(H) < eps) = eps;

    % Iterate over each OFDM symbol
    for i = 1:num_symbols
        % Extract the current OFDM symbol including the cyclic prefix
        start_idx = (i-1) * (N_fft + cp_length) + 1;
        end_idx = i * (N_fft + cp_length);
        if end_idx > length(waveform)
            break; % Ensure end_idx does not exceed the length of waveform
        end
        ofdm_symbol_with_cp = waveform(start_idx:end_idx);

        % Remove cyclic prefix
        ofdm_symbol = ofdm_symbol_with_cp(cp_length+1:end);

        % Perform N-point FFT (essentially a DFT)
        fft_output = fft(ofdm_symbol) / sqrt(N_fft); % Scaling factor sqrt(N_fft)

        % Equalization: compensate for the channel response
        equalized_symbol = fft_output ./ H;

        % Construct the complex-valued data points from the symmetric form
        % Reassemble the original complex-valued data points
        complex_symbol = zeros(subcarriers, 1); % Initialize
        complex_symbol(1) = equalized_symbol(1) + 1i * equalized_symbol(subcarriers + 1);
        for k = 2:subcarriers
            complex_symbol(k) = equalized_symbol(k);
        end

        % Append to the symbol stream
        symbol_stream = [symbol_stream; complex_symbol];
    end

    % Reshape the symbol stream to a column vector
    symbol_stream = transpose(reshape(symbol_stream, [], 1));

    % % Debugging output
    % disp('Symbol stream size:');
    % disp(size(symbol_stream));
    % disp('Symbol stream:');
    % disp(symbol_stream);

end