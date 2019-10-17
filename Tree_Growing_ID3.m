function dtree =  Tree_Growing_ID3(Examples, Target_Attribute, Attributes)
% Target_Attribute : 1 or -1
%     Create a root node for the tree
root_node = struct('attribute' , 'null' , 'left', 'null', 'right', 'null', 'class', 'null');
%     If all examples are positive, Return the single-node tree Root, with label = +.
if sum(Target_Attribute) == length(Target_Attribute) % all examples are +
    root_node.class = 'pos';
    dtree = root_node;
    return;
end
%     If all examples are negative, Return the single-node tree Root, with label = -.
if sum(Target_Attribute) == -length(Target_Attribute) % all examples are -
    root_node.class = 'neg';
    dtree = root_node;
    return;
end
%     If number of predicting attributes is empty, then Return the single node tree Root,
%     with label = most common value of the target attribute in the examples.
if sum(Attributes) == 0
    negs = length(find(Target_Attribute == -1));
    pos =  length(find(Target_Attribute == 1));
    if negs > pos
        root_node.class = 'neg';
    else
        root_node.class = 'pos';
    end
    dtree = root_node;
    return;   
end
%     Otherwise Begin
%         A ? The Attribute that best classifies examples.

%         Decision Tree attribute for Root = A.
%         For each possible value, vi, of A,
%             Add a new tree branch below Root, corresponding to the test A = vi.
%             Let Examples(vi) be the subset of examples that have the value vi for A
%             If Examples(vi) is empty
%                 Then below this new branch add a leaf node with label = most common target value in the examples
%             Else below this new branch add the subtree ID3 (Examples(vi), Target_Attribute, Attributes – {A})
%     End
%     Return Root