function gm = gradient_m(x, m, W,  lbl)
% ?_(?i,j: l?_i=l_j=k)2a_1 (2sig(m_k )^2 (1-sig(m_k ))-2sig(m_k ) (sig(m_k )-1)^2)||W(?x_i-?x_j)||_2^2
% +2?_(l_i !=l_j) 4a_2 (sig(m_k )-sig(?m_(l_j )))sig(m_k)(1-sig(m_k ))?_ ||W(?x_i-?x_j)||_2^2 Sgn(t_1-||a_2 W(?x_i-?x_j)||_2^2)
% +2t_3 (?_(l=1:nclass)sig(m_l )-nclass/2)sig(m_k )(1-sig(m_k ))
t1 = 10; % What is appropriate value?
t3 = 10; % What is appropriate value?
G = findgroups(lbl);
sum_l_i = 0;
sum_l_j = 0;

for k = 1 : max(G)
   [~, l_k] = find(G == k);
   for j = 1 : length(l_k)
       rep_W(D_1*(j-1)+1:D_1*(j-1)+D_1 , D_2*(j-1)+1 : D_2*(j-1)+D_2) = W;
   end
   
   a_1 = sigmoid_me(repmat(m(G == k), length(m(l_k)), 1)).*sigmoid_me(m(l_k)) + (1 - sigmoid_me(repmat(m(G == k), length(m(l_k)), 1))).*(1 - sigmoid_me(m(l_k)));
   
   tmp = rep_W*(repmat(x(:, G == k),1 , length(l_k)) - x(:, l_k));
   norm_W_xi_xj = sum(tmp.^2);
   
   % First term :?_(i,j:l_i=l_j)2a_1 (2sig(m_k )^2 (1-sig(m_k ))-2sig(m_k ) (sig(m_k )-1)^2)||W(x_i-x_j)||_2^2
   sum_l_i = sum_l_i + sum(2*a_1.*(2*sigmoid_me(m(G == k)).^2 .* (1 - signoid_me(m(G == k))))- 2*signoid_me(m(G == k)).*(1 - signoid_me(m(G == k)))).*norm_W_xi_xj;%((x(:,G == i) - x(:, l_i))*(x(:,G == i) - x(:, l_i))'*rep_W'));
   
   
   
   [~,l_i_l_j] = find(G ~= k);
   for j = 1 : length(l_i_l_j)
       rep_W2(D_1*(j-1)+1:D_1*(j-1)+D_1 , D_2*(j-1)+1 : D_2*(j-1)+D_2) = W;
   end
   
   a_2 = (sigmoid_me(repmat(m(G == k), length(m(l_i_l_j)), 1)) - sigmoid_me(m(l_i_l_j))).^2;
   
   tmp = a_2*rep_W2*(repmat(x(:, G == k),1 , length(l_i_l_j)) - x(:, l_i_l_j));
   norm_a2_W_xi_xj = sum(tmp.^2);
   tmp = rep_W2*(repmat(x(:, G == k),1 , length(l_i_l_j)) - x(:, l_i_l_j));
   norm_W_xi_xj = sum(tmp.^2);
   
   
   %Second term: +2?_(l_i !=l_j) 4a_2 (sig(m_k )-sig(m_(l_j )))sig(m_k)(1-sig(m_k )) ||W(?x_i-?x_j)||_2^2 Sgn(t_1-||a_2 W(?x_i-?x_j)||_2^2)
   sum_l_j = sum_l_j + 2*sum(4*a_2.*(sigmoid_me(m(G == k))-sigmoid_me(m(l_i_l_j))).*sigmoid_me(m(G == k)).*(1-sigmoid_me(m(G == k))).*norm_W_xi_xj.*sign(t1-norm_a2_W_xi_xj));%2*a_2.^2*(0.5 + 0.5*sign(t1 - norm_a2_W_xi_xj)).*(x(:,G == k) - x(:, l_i_l_j))*(x(:,G == k) - x(:, l_i_l_j))'*rep_W2');
end
         % Thrid term: + (2t_3 (?_(l=1:nclass)sig(m_l )-nclass/2)sig(m_k )(1-sig(m_k ))
gm = sum_l_i + sum_l_j - (2*t3*sum((sigmoid_me(m) - max(G)/2)))*(sigmoid_me(m).*(1-sigmoid_me(m)));
