function rx_data = lempelziv_decoder(rx_bitstream, codeword_len)
    % Input: rx_bitstream is a string and codeword_len is an integer
    % Output: rx_data is of String type
    % rx_data = "";

    % rx_bitstream = '000000000010000001000101000100001011000110001100001010001000010010001111010011010110000111000011011100011110000000';
    % codeword_len = 6;

    % Initialize variables
    rx_data = '';
    index_dictionary = containers.Map('KeyType', 'int32', 'ValueType', 'char');
    
    decoded_words = {};

    buffer = '';  % Initialize buffer for decoding

    % Iterate through the bitstream in chunks of codeword_len
    num_codewords = length(rx_bitstream) / codeword_len;
    for i = 1: num_codewords
        codeword = rx_bitstream((i-1)*codeword_len + 1:i*codeword_len);
        % disp(codeword)

        % Decode the codeword
        if length(codeword) == 1  % Single character
            decoded_sequence = codeword;
        else
            position = bin2dec(codeword(1:end-1));  
            % Convert position from binary to decimal
            % disp(position)
            character = codeword(end);  % Get the last character
            if position == 0
                decoded_word = character;
                decoded_words{i} = decoded_word; 
                index_dictionary(i) = decoded_word;
            else
                previous_word = index_dictionary(position);
                decoded_word = [previous_word, character];
                decoded_words{i} = decoded_word;
                index_dictionary(i) = decoded_word;
            end
        end
    end

    % Build the tx_bitstream from buffer_sequence
    rx_data = '';
    for i = 1:length(decoded_words)
        buffer = decoded_words{i};
        rx_data = [rx_data, buffer];
    end
    
    % disp(rx_data)
    % 
    % data_correct = '000100100000011000010000000100000010100001000000110100000001100';
    % % Verify if the decoded data matches the expected data
    % if strcmp(rx_data, data_correct)
    %     disp('Test passed.');
    % else
    %     disp('Test failed.');
    % end
    
end
