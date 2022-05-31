
classdef generator < handle
    
    properties
		s
        name
        ts
        id
        epsilon = get_epsilon;
    end
    methods
        function obj = generator(name,ts)
            obj.name = name;
            obj.s = 'prod';
            obj.ts = ts;
            obj.id = 0;
        end
        function delta(obj,e,x)
           
        	if abs(e - obj.ts) <= obj.epsilon
            	obj.s = 'prod';
				obj.id = obj.id + 1;
			end
		end
        function y=lambda(obj,e,x) 
            
        	if abs(e - obj.ts) <= obj.epsilon
				y.out = obj.id;
			else
				y=[];
			end	
        end
        function t = ta(obj)
			t = obj.ts;
        end
    end
   
end
