function res = simulator(tx_data, sysconfig)

    % source coding
    [tx_bitstream, codeword_len] = lempelziv_encoder(tx_data);
    
    tx_symbol_stream = mapper(tx_bitstream, sysconfig.modulation);
    
    % modulator
    ofdm_waveform = ofdm_modulator(tx_symbol_stream, sysconfig.subcarriers, sysconfig.cp_length);
    
    % experience channel fading
    h = sysconfig.channel_response;
    rx_waveform = conv(h, ofdm_waveform);
    rx_waveform = rx_waveform(1:length(ofdm_waveform));
    
    % demodulator
    rx_symbol_stream = ofdm_demodulator(rx_waveform, sysconfig.subcarriers, sysconfig.cp_length, sysconfig.channel_response);
    
    % channel decoder
    rx_bitstream = demapper(rx_symbol_stream, sysconfig.modulation);
    
    % source decoder
    rx_data = lempelziv_decoder(rx_bitstream, codeword_len);

    % collector simulation results
    res = struct();
    res.tx_bitstream = tx_bitstream;
    res.codeword_len = codeword_len;
    res.tx_symbol_stream = tx_symbol_stream;
    res.ofdm_waveform = ofdm_waveform;
    res.rx_symbol_stream = rx_symbol_stream;
    res.rx_bitstream = rx_bitstream;
    res.rx_data = rx_data;

end

