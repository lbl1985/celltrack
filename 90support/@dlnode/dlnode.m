classdef dlnode < handle
    %DLNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data
    end
    
    properties (SetAccess = private)
        Next
        Prev
    end
    
    methods
        function node = dlnode(Data)
           if nargin > 0
               node.Data = Data;
           end
        end
        
        function insertAfter(newNode, nodeBefore)
            disconnect(newNode);
            newNode.Prev = nodeBefore;
            newNode.Next = nodeBefore.Next;
            if ~isempty(nodeBefore.Next)
                nodeBefore.Next.Prev = newNode;
            end
            nodeBefore.Next = newNode;
        end
        
        function insertBefore(newNode, nodeAfter)
            disconnect(newNode);
            newNode.Prev = nodeAfter.Prev;
            newNode.Next = nodeAfter;
            if ~isempty(nodeAfter.Prev)
                nodeAfter.Prev.Next = newNode;
            end
            nodeAfter.Prev = newNode;
        end 
        
        function disconnect(node)
            if ~isscalar(node)
                error('Node must be scalar');
            end
            prevNode = node.Prev;
            nextNode = node.Next;
            if ~isempty(prevNode)
                prevNode.Next = nextNode;
            end
            if ~isempty(nextNode)
                nextNode.Prev = prevNode;
            end
            node.Prev = [];
            node.Next = [];
        end
        
        function disp(node)
            if (isscalar(node))
                disp('Doubly-linked list node with data: ');
                disp(node.Data);
            else
                dims = size(node);
                ndims = length(dims);
                for k = ndims -1 : -1 : 1
                    dimcell{k} = [num2str(dims(k)) 'x'];
                end
                dimstr = [dimcell{:} num2str(dims(ndims))];
                disp([dimstr ' array of double-linked list nodes']);
            end
        end
        
        function delete(node)
            disconnect(node);
        end
    end
    
end

