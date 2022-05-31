classdef devs < handle
    properties
        parent  %parent coordinator
        tl      %time of last event
        tn      %time of next event
        DEVS    %model
        y       %output message bag
        e
        debug_level = get_debug_level();
    end
    
    methods
%% constructor        
        function obj = devs(mdl)
            obj.DEVS = mdl;
            obj.e = 0;
        end
%% set methods
        function set_parent(obj,value)
            obj.parent = value;
        end
        
        function set_model(obj,value)
            obj.DEVS = value;
        end
%% get methods 
        
        function tn = get_tn(obj)
            tn = obj.tn;
        end
        
        function tl = get_tl(obj)
            tl = obj.tl;
        end
        
        function name = get_name(obj)
            name = obj.DEVS.name;
        end
        
        function state = get_state(obj)
            state = obj.DEVS.s;
        end
 %% message functions       
        function imessage(obj,t)
            
            obj.tl = t - obj.e;
            obj.tn = obj.tl + obj.DEVS.ta();
            if obj.debug_level == 1
                sequenceaddlink(sprintf('i-msg(t=%f)',t),obj.get_name);
                sequenceaddlink(sprintf('%f = tl + ta(s)',obj.tn),obj.get_name);
            end
        end       
        function smessage(obj,x,t)
            if obj.debug_level == 1
                disp(['simulator: ' obj.DEVS.name ' s-message x-value: ']);
                disp(x);
                if isempty(x)
                    sequenceaddlink(sprintf('*-msg([],t=%f)',t),obj.get_name);
                else
                    sequenceaddlink(sprintf('*-msg(x,t=%f)',t),obj.get_name);
                end
            end
			obj.e = t - obj.tl;
			
            if obj.debug_level == 1
                disp('call lambda');
                sequenceaddlink('\lambda (s)',obj.get_name);
            end
			obj.y = obj.DEVS.lambda(obj.e,x);
			obj.parent.ymessage(obj.y,obj.get_name,t);
            
            
        end 
        function xmessage(obj,x,t)
            if obj.debug_level == 1
                disp(['simulator: ' obj.DEVS.name ' x-message ' 'value:']);
                disp(x);
                disp('old state: ');
                disp(obj.DEVS.s);
                if isempty(x)
                    sequenceaddlink(sprintf('x-msg([],t=%f)',t),obj.get_name);
                else
                    sequenceaddlink(sprintf('x-msg(x,t=%f)',t),obj.get_name);
                end
            end
            
            
            if obj.debug_level == 1
                disp('call delta');
                sequenceaddlink('\delta (s)',obj.get_name);
            end
			obj.DEVS.delta(obj.e,x);
			
            if obj.debug_level == 1
                disp('new state: ');
                disp(obj.DEVS.s);
            end
            
            if obj.debug_level == 1
                disp('call ta()');
            end
            obj.tl = t;
            obj.tn = t + obj.DEVS.ta();
            if obj.debug_level == 1
                disp(['tnext: ' num2str(obj.tn)]);
                sequenceaddlink(sprintf('%f = tl + ta(s)',obj.tn),obj.get_name);
            end
        end 
        
    end
end