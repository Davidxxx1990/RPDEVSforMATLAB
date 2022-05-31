classdef gain < handle
%% Description
%  multiplies its input with a parameter
%% Ports
%  inputs: 
%    in       incoming value
%  outputs: 
%    out      
%% States
%  s:   running
%% System Parameters
%  g:     gain factor
%  name:  object name
%  debug: flag to enable debug information
    
  properties
    s
    g
    name
    debug
  end
  
  methods
    function obj = gain(name, g, debug)
      obj.s ="running"; 
      obj.name = name;
      obj.g = g;
      obj.debug = debug;
    end
          
    function delta(obj,e,x)
      if obj.debug
        fprintf("%-8s entering int, being in phase %s\n", obj.name, obj.s)
      end      
    end
                  
    function y = lambda(obj,e,x)
      y.out = obj.g*x.in;
        
      if obj.debug
        fprintf("%-8s OUT, out=%2d\n", obj.name, y.out)
      end
    end
    
    function t = ta(obj)
      t = inf;
    end
   
  end
end
