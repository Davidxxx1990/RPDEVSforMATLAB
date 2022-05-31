classdef terminator < handle
    properties
        s
        name
        E
        epsilon = get_epsilon;
    end
    methods
        function obj = terminator(name)
            obj.name = name;
            obj.s = 'idle';
		end
        function delta(obj,e,x)
            obj.E = x.in;
			obj.s = 'idle';  
        end
        
        function y=lambda(obj,e,x)
            y=[];
        end
        function t = ta(obj)
            t = Inf; 
        end
    end
   
end
