classdef outputswitch < handle
    %% Description
    %  routes input to one of two outputs according to sw input
    %% Ports
    %  inputs:
    %    in        incoming value
    %    sw        output selector
    %  outputs:
    %    out1/2    outgoing entities
    %% States
    %  s:        running
    %  nextPort: output port of new in values
    %% System Parameters
    %  name:  object name
    %  port0: initial port
    %  debug: flag to enable debug information
    
    properties
	   s
	   nextPort
	   name
	   port0
	   debug
    end
    
    methods
	   function obj = outputswitch(name, port0, debug)
		  obj.s = "running";
		  obj.nextPort = port0;
		  obj.name = name;
		  obj.port0 = port0;
		  obj.debug = debug;
	   end
	   
	   function delta(obj,e,x)
		  if obj.debug
			 fprintf("%-8s entering delta, port=%2d\n", obj.name, obj.nextPort)
		  end
		  
		  if isfield(x, "sw")
			 obj.nextPort = x.sw + 1;
		  end
		  
		  if obj.debug
			 fprintf("%-8s  leaving delta, port=%2d\n", obj.name, obj.nextPort)
		  end
	   end
	   
	   function y = lambda(obj,e,x)
		  
		  y=[];
		  
		  if isfield(x, "in")
			 curPort = obj.nextPort;
			 if isfield(x, "sw")
				curPort = x.sw + 1;
			 end
			 
			 switch curPort
				case 1
				    y.out1 = x.in;
				    y.out2 = [];
				case 2
				    y.out1 = [];
				    y.out2 = x.in;
				otherwise
				    fprintf("la: wrong port %d in %s\n", curPort, obj.name);
			 end
			 
			 if obj.debug
				switch curPort
				    case 1
					   fprintf("%-8s OUT, out1=%2d\n", obj.name, y.out1);
				    case 2
					   fprintf("%-8s OUT, out2=%2d\n", obj.name, y.out2);
				end
			 end
		  end
	   end
	   
	   function t = ta(obj)
		  t = inf;
	   end
	   
    end
end
