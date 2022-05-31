classdef toworkspace < handle
    properties
        s
        name
        varname
        t
        epsilon = get_epsilon;
    end
    methods
        function obj = toworkspace(name,varname,t0)
            obj.name = name;
            obj.s = 'prod';
            obj.varname = varname;
            obj.t = t0;
        end
        
        function delta(obj,e,x)
            global simout
            fun = @(x) strcmp(x,obj.varname);
            
            obj.t = obj.t + e;
            
            if ~isempty(x) && isfield(x,"in")
                if ~isempty(x.in)
                    
                    if(isempty(simout))
                        simout.(obj.varname).y=x.in(end);
                        simout.(obj.varname).t=obj.t;
                    elseif ( ~any(fun(fieldnames(simout))) )
                        simout.(obj.varname).y=x.in(end);
                        simout.(obj.varname).t=obj.t;
                    else
                        simout.(obj.varname).y=[simout.(obj.varname).y,x.in(end)];
                        simout.(obj.varname).t=[simout.(obj.varname).t,obj.t];
                    end
                end
			end
        end
       
        function y=lambda(obj,e,x)
            y=[];
        end
        function t = ta(obj)
           t = Inf;
        end
    end
   
end
