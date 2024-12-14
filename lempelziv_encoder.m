function [tx_bitstream, codeword_len] = lempelziv_encoder(tx_data)
    % Hint: Codeword_len = ceil(log2(number of phrases in dictionary)) + 1
    % Input: tx_data is a character vector
    % Output: tx_bistream is a string and codeword_len is an integer 
    % This line of code is for the program to run. Please remove after you finish implmenting the module.
    % tx_bitstream = "";
    % codeword_len = 0;
    
    % Initialize the dictionary with empty string
    index_dictionary = containers.Map('KeyType', 'char', 'ValueType', 'char');
    % dictionary('');
    tx_bitstream = '';

    % Initialize the buffer
    buffer = '';
    code_left = '';

    % Initialize the list of encoded outputs
    encoded_dictionary = containers.Map('KeyType', 'char', 'ValueType', 'char');

    % Initialize the sequences of codewords
    buffer_sequence = {};
    sequence = 1;
    
    if isempty(tx_data)
        error('The length of tx_data should NOT be zero.');
    end

    % Iterate over each character in the input data
    for i = 1:length(tx_data)
        % Append the current character to the buffer
        buffer = [buffer, tx_data(i)];
        % Check if the buffer is in the dictionary
        if ~isKey(index_dictionary, buffer)
            % Add the buffer to the dictionary
            index_dictionary(buffer) = dec2bin(length(index_dictionary)+1);
            % disp(buffer)
            % disp(index_dictionary(buffer))
            
            % Encode the buffer without the last character
            if length(buffer) == 1
                % If buffer has only one character, encode as 0 + character
                encoded_dictionary(buffer) = buffer;
            else
            
            % Find the position of the buffer without the last character
            phrase = buffer(1:end-1);
            pos = index_dictionary(phrase);

            % Encode as the position in the dictionary and the last character
            encoded_dictionary(buffer) = [pos, buffer(end)];
            end
            % disp(encoded_dictionary(buffer))
            % disp(" ")
            buffer_sequence{sequence} = buffer;
            sequence = sequence+1;
            % Reset the buffer
            buffer = '';
        end
    end

    % If buffer is not empty, encode it as well
    if ~isempty(buffer)
        buffer_sequence{sequence} = buffer;
        sequence = sequence+1;
    end
    
    % disp(buffer_sequence)

    % Add Zeros to encoded codewords

    % Find the codeword length
    num_phrases = length(index_dictionary);
    codeword_len = ceil(log2(num_phrases)) + 1;
    keys = encoded_dictionary.keys;

    % Pad the values in encoded_dictionary to the maximum length
    for i = 1:length(keys)
        current_value = encoded_dictionary(keys{i});
        padded_value = pad(current_value, codeword_len, 'left', '0');
        encoded_dictionary(keys{i}) = padded_value;
        % disp(keys{i})
        % disp(encoded_dictionary(keys{i}))
        % disp(" ")
    end

    % Build the tx_bitstream from buffer_sequence
    tx_bitstream = '';
    for i = 1:length(buffer_sequence)
        buffer = buffer_sequence{i};
        if isKey(encoded_dictionary, buffer)
            tx_bitstream = [tx_bitstream, encoded_dictionary(buffer)];
        end
    end
    
    % disp(tx_bitstream);
    % disp(codeword_len);
end
