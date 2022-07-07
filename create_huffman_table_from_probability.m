function huffman_table=create_huffman_table_from_probability(par_probability_matrix)
sorted_probability_matrix=sortrows(par_probability_matrix);
nr_of_codewords=size(sorted_probability_matrix,1);
huffman_table=cell(nr_of_codewords,2);
huffman_tree=cell(nr_of_codewords,2);
for i=1:nr_of_codewords
huffman_table{i,2}=[sorted_probability_matrix(i,2:3)];
huffman_tree{i,1}=sorted_probability_matrix(i,1);
huffman_tree{i,2}=i;
end
%  show_huffman_table(huffman_table)
% show_huffman_tree(huffman_tree)

    
  while(size(huffman_tree,1)>1)
  
  for i=1:size(huffman_tree{1,2},2)
    huffman_table{huffman_tree{1,2}(1,i),1}=[1 huffman_table{huffman_tree{1,2}(1,i),1}];
  end
  for k=1:size(huffman_tree{2,2},2)
    huffman_table{huffman_tree{2,2}(1,k),1}=[0 huffman_table{huffman_tree{2,2}(1,k),1}];
  end
  
 
    new_huffman_tree=cell(size(huffman_tree,1)-1,2);
    new_huffman_tree{1,1}=huffman_tree{1,1}+huffman_tree{2,1};
    new_huffman_tree{1,2}=[huffman_tree{1,2} huffman_tree{2,2}];
    for j=3:size(huffman_tree,1)
        new_huffman_tree{j-1,1}=huffman_tree{j,1};
        new_huffman_tree{j-1,2}=huffman_tree{j,2};
    end
%     show_huffman_tree(huffman_tree);
%    show_new_huffman_tree(new_huffman_tree)
    huffman_tree=cell(size(new_huffman_tree));
    
    
   new_huffman_tree=sortrows(new_huffman_tree,1);
   
    
   huffman_tree=new_huffman_tree;
    
    
  

  end
 % show_huffman_tree(huffman_tree);
  save('huffman_table.mat');
  end
   
    





