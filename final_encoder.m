function final_encoder(input_sequence_yuv,coded_file,width,height,nr_of_frames,qp)
% 6.1 Encoder basic intra 
    transform_blocksize=8;
    me_blocksize=16;
    me_searchrange=8;
    runlevel_rep=[];
    mse_per_frame=[];
    motion_vectors=[];
    predicted_frame=zeros(height,width);
    motion_vectors_current=[];
    size_motion_vectors=[];
    quantisation_matrix=get_quantisation_matrix(qp,transform_blocksize);
    for i=1:nr_of_frames
        if i==1
        % 6.2 dequantization and idct 
        [output_image_Y, output_image_U, output_image_V]= yuv_read_one_frame(input_sequence_yuv,i,width,height);
        dct_image=blockbased_dct_on_image(output_image_Y,transform_blocksize);
        
        quantized_image=blockbased_deadzone_quantizer_to_levels(dct_image,quantisation_matrix);
        
        dequant_image=blockbased_deadzone_dequantizer_from_levels(quantized_image,quantisation_matrix);
        reconstructed_image=blockbased_idct_on_image(dequant_image,transform_blocksize);
        reconstructed_image(reconstructed_image<0)=0;  %6.3
        reconstructed_image(reconstructed_image>1)=1;
        %figure(i)
        %imshow(reconstructed_image);
        mse_per_frame_current=mse_of_frame(output_image_Y,reconstructed_image);
        mse_per_frame=[mse_per_frame mse_per_frame_current];
        zigzag_scanned= blockbased_encoding_to_zigzag_scanned(quantized_image, transform_blocksize); % resorted first frame
        zigzag_scanned=optional_dc_prediction(zigzag_scanned);
        runlevel_rep_current= blockbased_encoding_to_runlevel_representation(zigzag_scanned);  
        runlevel_rep=[runlevel_rep; runlevel_rep_current];
        frame_buffer= reconstructed_image;
        else
        current_frame=yuv_read_one_frame(input_sequence_yuv,i,width,height);
        motion_vectors_current=blockbased_motion_search(current_frame,frame_buffer,me_blocksize,me_searchrange);
        motion_vectors=[motion_vectors;motion_vectors_current];
        predicted_frame = blockbased_motion_compensation(frame_buffer,me_blocksize,me_searchrange,motion_vectors_current);
        residual_image=current_frame-predicted_frame;
        
        size_motion_vectors=[size_motion_vectors size(motion_vectors,1)];
        
        output_image=blockbased_dct_on_image(residual_image,transform_blocksize);
        
        quantized_image=blockbased_deadzone_quantizer_to_levels(output_image,quantisation_matrix);
        
        dequantized_image=blockbased_deadzone_dequantizer_from_levels(quantized_image,quantisation_matrix);
        reconstructed_image=blockbased_idct_on_image(dequantized_image,transform_blocksize);
        
        frame_buffer=reconstructed_image+predicted_frame;
        frame_buffer(frame_buffer<0)=0;
        frame_buffer(frame_buffer>1)=1;
        
        %figure(i)
        %imshow(frame_buffer);
        mse_per_frame=[mse_per_frame mse_of_frame(current_frame,frame_buffer)];
        zigzag_scanned=blockbased_encoding_to_zigzag_scanned(quantized_image,transform_blocksize);
        zigzag_scanned=optional_dc_prediction(zigzag_scanned);
        runlevel_rep=[runlevel_rep;blockbased_encoding_to_runlevel_representation(zigzag_scanned)];
        
        end
    end
    
    huffman_table=create_huffman_table_from_signal(runlevel_rep);
    bitstream=bitstream_init();
    bitstream=encode_signal_to_huffman_bitstream(bitstream,huffman_table,runlevel_rep);
    huffman_table_motion_vectors=create_huffman_table_from_signal(motion_vectors);
    bitstream_motion_vectors=bitstream_init();
    bitstream_motion_vectors=encode_signal_to_huffman_bitstream(bitstream_motion_vectors,huffman_table_motion_vectors,motion_vectors);
    save(coded_file,'bitstream','bitstream_motion_vectors','huffman_table_motion_vectors','huffman_table','width','height','transform_blocksize','qp','motion_vectors','me_blocksize','me_searchrange');
    
    % 6.1
    coded_bits=bitstream_get_length(bitstream);
    
    end
    