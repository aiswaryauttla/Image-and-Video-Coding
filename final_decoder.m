function final_decoder(coded_file,decoded_sequence_yuv)


load(coded_file);
%decoded_file=[];
[bitstream, signal]=decode_signal_from_huffman_bitstream(bitstream,huffman_table);
[bitstream_motion_vectors, motion_vectors]=decode_signal_from_huffman_bitstream(bitstream_motion_vectors,huffman_table_motion_vectors);
k=1;

no_of_coded_blocks= height* width/ transform_blocksize^2;
no_of_motion_vectors=height*width/me_blocksize^2;
EOB= (find(signal(:,1)==-1))';
frame_end=EOB(no_of_coded_blocks:no_of_coded_blocks:end);
frame_start=[1 frame_end(1:end-1)+1];
no_of_runlevels= size(signal,1);
number_of_frames=size(EOB,2)/no_of_coded_blocks;
end_index_motion=no_of_motion_vectors:no_of_motion_vectors:no_of_motion_vectors*(number_of_frames-1);
start_index_motion=1:no_of_motion_vectors:no_of_motion_vectors*(number_of_frames-2)+1;
quantisation_matrix= get_quantisation_matrix(qp,transform_blocksize);
while(k <= length(frame_end))
    if k==1
      signal_frame= signal(frame_start(k):frame_end(k),:);
      block_runlevel=blockbased_decoding_from_runlevel_representation(signal_frame,transform_blocksize);
      block_runlevel=optional_dc_prediction_inverse(block_runlevel);
      decode_zigzag=blockbased_decoding_from_zigzag_scanned(block_runlevel,transform_blocksize,width,height);
      
      
      dequant_image=blockbased_deadzone_dequantizer_from_levels(decode_zigzag,quantisation_matrix);
      decoded_file=blockbased_idct_on_image(dequant_image,transform_blocksize);
      decoded_file(decoded_file<0)=0;
      decoded_file(decoded_file>1)=1;
      retval= yuv_write_one_frame(decoded_sequence_yuv,k,decoded_file);
     
     % figure(k);
     % imshow(decoded_file);
     
    else
      signal_frame= signal(frame_start(k):frame_end(k),:);
      motion=motion_vectors(start_index_motion(k-1):end_index_motion(k-1),:);
      predicted_frame = blockbased_motion_compensation(decoded_file,me_blocksize,me_searchrange,motion);
      
      block_runlevel=blockbased_decoding_from_runlevel_representation(signal_frame,transform_blocksize);
      block_runlevel=optional_dc_prediction_inverse(block_runlevel);
      decode_zigzag=blockbased_decoding_from_zigzag_scanned(block_runlevel,transform_blocksize,width,height);
      
      
      dequantized_image=blockbased_deadzone_dequantizer_from_levels(decode_zigzag,quantisation_matrix);
      residual_frame=blockbased_idct_on_image(dequantized_image,transform_blocksize);
      decoded_file=residual_frame+predicted_frame;
      decoded_file(decoded_file<0)=0;
      decoded_file(decoded_file>1)=1;
      retval=yuv_write_one_frame(decoded_sequence_yuv,k,decoded_file);
      %figure(k)
     % imshow(decoded_file);
      deco_size=size(decoded_file);
     
    end
    k=k+1;
end


end

