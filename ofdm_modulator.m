function ofdm_waveform = ofdm_modulator(symbol_stream, subcarriers, cp_length)
    % You may assume the number of symbols is a multiple of the number of
    % subcarriers. Please implement an OFDM modulator based on IDFT, as
    % detailed in Section 11.2-5 in Digital Communications 5th edition.

    % Input: 
    % Symbol_stream: N complex-valued symbols, 
    % subcarriers: the number of subcarriers,
    % cp_length: the length of CP

    % Output: ofdm_waveform is of length equal to 2 * N real-valued symbols + CP * N / #subcarriers

    % This line of code is for the program to run. Please remove after you finish implmenting the module.
    % ofdm_waveform = [complex(rand, rand)];
    
    % Ensure that the length of symbol_stream is a multiple of subcarriers
    % disp(symbol_stream)

    if mod(length(symbol_stream), subcarriers) ~= 0
        error('The length of symbol_stream must be a multiple of the number of subcarriers.');
    end

    % Calculate the number of OFDM symbols
    num_symbols = length(symbol_stream) / subcarriers;
    
    % Initialize N = 2 * subcarriers, i.e., double the number of subcarriers 
    N = 2 * subcarriers;
    
    % Pre-allocate the result
    total_length = num_symbols * (N + cp_length);
    % disp(total_length)
    % disp(num_symbols)
    ofdm_waveform = zeros(total_length, 1);

    % Reshape the symbol stream into a matrix of subcarriers by num_symbols
    symbol_matrix = reshape(symbol_stream, subcarriers, num_symbols);

    for i = 1:num_symbols
        % Construct the symmetric symbol matrix
        X = zeros(N, 1);
        X(1:subcarriers) = symbol_matrix(:, i);
        X(N:-1:N-subcarriers+2) = conj(symbol_matrix(2:subcarriers, i));
        
        % Special handling of the X(0) term
        X(1) = real(symbol_matrix(1, i));
        % Special case: set the subcarriers entry to imag(X_0)
        X(subcarriers + 1) = imag(symbol_matrix(1, i));

        % Perform N-point IDFT
        ifft_output = ifft(X) * sqrt(N);  % Use scaling factor sqrt(N)
        
        % Add cyclic prefix
        cp = ifft_output(end-cp_length+1:end);
        ofdm_symbol_with_cp = [cp; ifft_output];

        % Calculate indices and fill the result array
        start_idx = (i-1) * (N + cp_length) + 1;
        end_idx = i * (N + cp_length);
        ofdm_waveform(start_idx:end_idx) = real(ofdm_symbol_with_cp);
    end
    ofdm_waveform = transpose(ofdm_waveform);
    % Debugging output
    % disp('OFDM waveform size:');
    % disp(size(ofdm_waveform));
    % disp('OFDM waveform:');
    % disp(ofdm_waveform);
end