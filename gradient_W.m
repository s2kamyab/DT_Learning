function gw = gradient_W(x, m, W,  lbl)
%?_(i,j:l_i=l_j)2a_1^2 (x_i-x_j ) (x_i-x_j )^T W^T 
%-?_(l_i !=l_j)2a_2^2?(0.5+0.5 Sgn(t_1-?|a_2 W(x_i-x_j )||_2^2 ))(x_i-x_j ) (x_i-x_j )^T W^T
% -t_2 W(I-W^T W)

%a_1 (scalar)=(sig(m_(l_i ) )^2+(1-sig(m_(l_i ) ))^2 )
% a_2 (scalar)=(sig(m_(l_i ))-sig(m_(l_j )))^2


t1 = 10; % What is appropriate value?
t2 = 10; % What is appropriate value?
G = findgroups(lbl);
sum_l_i = 0;
sum_l_j = 0;

for i = 1 : max(G)
   [~, l_i] = find(G == i);
   for j = 1 : length(l_i)
       rep_W(D_1*(j-1)+1:D_1*(j-1)+D_1 , D_2*(j-1)+1 : D_2*(j-1)+D_2) = W;
   end
   
   a_1 = sigmoid_me(repmat(m(G == i), length(m(l_i)), 1)).*sigmoid_me(m(l_i)) + (1 - sigmoid_me(repmat(m(G == i), length(m(l_i)), 1))).*(1 - sigmoid_me(m(l_i)));
   
   % First term :?_(i,j:l_i=l_j)2a_1^2 (x_i-x_j ) (x_i-x_j )^T W^T 
   sum_l_i = sum_l_i + sum(2*a_1.^2.*((x(:,G == i) - x(:, l_i))*(x(:,G == i) - x(:, l_i))'*rep_W'));
   
   
   
   [~,l_i_l_j] = find(G ~= i);
   for j = 1 : length(l_i_l_j)
       rep_W2(D_1*(j-1)+1:D_1*(j-1)+D_1 , D_2*(j-1)+1 : D_2*(j-1)+D_2) = W;
   end
   
   a_2 = (sigmoid_me(repmat(m(G == i), length(m(l_i_l_j)), 1)) - sigmoid_me(m(l_i_l_j))).^2;
   
   tmp = a_2*W*(repmat(x(:, G == i),1 , length(l_i_l_j)) - x(:, l_i_l_j));
   norm_a2_W_xi_xj = sum(tmp.^2);
   
   %Second term: -?_(l_i !=l_j)2a_2^2?(0.5+0.5 Sgn(t_1-?|a_2 W(x_i-x_j )||_2^2 ))(x_i-x_j ) (x_i-x_j )^T W^T
   sum_l_j = sum_l_j + sum(2*a_2.^2*(0.5 + 0.5*sign(t1 - norm_a2_W_xi_xj)).*(x(:,G == i) - x(:, l_i_l_j))*(x(:,G == i) - x(:, l_i_l_j))'*rep_W2');
end
         % Thrid term: -t_2 W(I-W^T W) 
gw = sum_l_i + sum_l_j - t2*W*(eye(size(W)) - W'*W);
