function bitstream = demapper(symbol_stream, modulation)

    % demapper aims to map symbol stream to bit stream
    
    % Input: modulation is "QPSK"
    % Output: bitstream is of String type
    
    % Check the modulation type
    if strcmp(modulation, 'QPSK')
        
        % Define the QPSK symbol reference points
        sym_ref = [1/sqrt(2) + 1i * 1/sqrt(2), ...
                   -1/sqrt(2) + 1i * 1/sqrt(2), ...
                   -1/sqrt(2) - 1i * 1/sqrt(2), ...
                   1/sqrt(2) - 1i * 1/sqrt(2)];
        
        % Define the corresponding bit pairs
        bit_ref = {'00', '01', '11', '10'};
        
        % Initialize the bitstream
        bitstream = '';
        
        % Iterate over the symbol stream
        for i = 1:length(symbol_stream)
            % Get the current symbol
            symbol = symbol_stream(i);
            
            % Find the closest reference symbol
            [~, idx] = min(abs(symbol - sym_ref));
            
            % Map the symbol to the corresponding bit pair
            bit_pair = bit_ref{idx};
            
            % Append the bit pair to the bitstream
            bitstream = [bitstream, bit_pair]; %#ok<AGROW>
        end
        
    else
        error('Unsupported modulation scheme');
    end

end