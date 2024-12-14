function symbol_stream = mapper(tx_bitstream, modulation)
% Bit-to-symbol mapping for QPSK
% 00 --- 1/sqrt(2) + j * 1/sqrt(2)
% 01 --- -1/sqrt(2) + j * 1/sqrt(2)
% 11 --- -1/sqrt(2) - j * 1/sqrt(2)
% 10 --- 1/sqrt(2) - j * 1/sqrt(2)

% You only need to implement "QPSK".

% Input: tx_bitstream is a string, modulation is "QPSK"
% Output: symbol_stream is a vector of symbols
    % tx_bitstream = '00011110';
    % modulation = 'QPSK';

    if strcmp(modulation, 'QPSK')
        
        % Check if the length of tx_bitstream is a multiple of 2
        if mod(length(tx_bitstream), 2) ~= 0
            error('The length of tx_bitstream must be a multiple of 2.');
        end

        % Initialize an empty array to store the symbols
        symbol_stream = [];
        
        % Define QPSK symbol mapping
       symbol_mapping = containers.Map({'00', '01', '11', '10'}, ...
           {1/sqrt(2) + 1i * 1/sqrt(2), ...
           -1/sqrt(2) + 1i * 1/sqrt(2), ...
           -1/sqrt(2) - 1i * 1/sqrt(2), ...
           1/sqrt(2) - 1i * 1/sqrt(2)});
        
        % Iterate over the bitstream in steps of 2 bits
        for i = 1:2:length(tx_bitstream)
            % Get the current pair of bits
            bit_pair = tx_bitstream(i:i+1);
            
            % Map the bit pair to a QPSK symbol
            symbol = symbol_mapping(bit_pair);
            
            % Append the symbol to the symbol stream
            symbol_stream = [symbol_stream, symbol];
        end
    else
        error('Unsupported modulation scheme');
    end

    %disp(symbol_stream)
end
