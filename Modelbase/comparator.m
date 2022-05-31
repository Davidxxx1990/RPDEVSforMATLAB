classdef comparator < handle
%% Description
%  returns 1 if in >= 0, else 0
%% Ports
%  inputs: 
%    in       incoming value
%  outputs: 
%    out      1 if in >= 0, else 0 
%% States
%  s:   running
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information
    
  properties
    s
    name
    debug
  end
  
  methods
    function obj = comparator(name, debug)
      obj.s ="running"; 
      obj.name = name;
      obj.debug = debug;
    end
          
    function delta(obj,e,x)
      if obj.debug
        fprintf("%-8s entering int, being in phase %s\n", obj.name, obj.s)
      end      
    end
                  
    function y = lambda(obj,e,x)
      if x.in >= 0
        y.out = 1;
      else
        y.out = 0;
      end
      if obj.debug
        fprintf("%-8s OUT, out=%2d\n", obj.name, y.out)
      end
    end
    
    function t = ta(obj)
      t = inf;
    end
   
  end
end
