function huffman_table=create_huffman_table_from_signal(input_signal)
[x,y,z]=unique(input_signal,'rows');

symbol_count=zeros(size(x,1),1);
symbol_count = zeros(size(x,1),1);
    for i = 1:size(symbol_count)
        for j = 1:size(input_signal,1)
            if(x(i,:) == input_signal(j,:))
                symbol_count(i) = symbol_count(i) + 1;
            end
        end
    end
    probability_matrix = zeros(size(x,1),size(x,2)+1);
    probability_matrix(:,1) = symbol_count./(size(input_signal,1));
    probability_matrix(:,2:end) = x;
    sorted_probability_matrix = sortrows(probability_matrix,1);

huffman_table=create_huffman_table_from_probability(probability_matrix);
end