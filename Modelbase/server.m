classdef server < handle
%% Description
%  processes one entity in time tS
%% Ports
%  inputs: 
%    in   incoming entities
%  outputs: 
%    out      outgoing entities
%    working  true/false
%    n        current number of entities in server
%% States
%  s:   idle|busy
%  E:   id of processed entity
%  sig: next switching time
%% System Parameters
%  name:  object name
%  tS:    service time
%  debug: model debug level
%  epsilon: assumed accuracy of time values
%
  properties
    s
    E
    sig
    name
    tS
    debug
    epsilon
  end
  
  methods
    function obj = server(name, tS, debug)
      obj.s = "idle";
      obj.E = [];
      obj.sig = inf;
      obj.name = name;
      obj.tS = tS;
      obj.debug = debug;
      obj.epsilon = get_epsilon();
     end
    
		function delta(obj,e,x)
      if obj.debug
        fprintf("%-8s entering delta, being in phase %s\n", obj.name, obj.s)
      end      

      if isempty(x)      % internal event
        obj.s = "idle";
        obj.E = [];
        obj.sig = inf;
      elseif (e < obj.sig - obj.epsilon)   % external event
        switch obj.s 
          case "idle"
            if ~isempty(x.in)
              obj.s = "busy";
              obj.E = x.in;
              obj.sig = obj.tS;
            end
          case "busy"
            if ~isempty(x.in)
              fprintf("dExt: in phase %s in %s - dropping input %2d\n", ...
                obj.s, obj.name, x.in)
              obj.sig = obj.sig - e;   % adjust waiting time
            end
          otherwise
            fprintf("delta: wrong phase %s in %s\n", obj.s, obj.name);
        end
      else   % confluent event
        if ~isempty(x.in)
         obj.s = "busy";     % unnecessary, is busy anyhow
         obj.E = x.in;
         obj.sig = obj.tS;
        end
      end

      if obj.debug
        fprintf("%-8s leaving delta, being in phase %s\n", obj.name, obj.s)
      end      
    end
    
    function y = lambda(obj,e,x)
      y = [];     % necessary dummy value for no-op
      if isempty(x)      % internal event
        y.out = obj.E;
        y.working = false;
        y.n = 0;
      elseif (e < obj.sig - obj.epsilon)   % external event
        if obj.s == "idle"
          y.working = true;
          y.n = 1;
        end
      else   % confluent event
        y.out = obj.E;
        y.working = true;
        y.n = 1;
      end
      
      if obj.debug
        fprintf("%-8s OUT, ", obj.name);
        if isfield(y, "out")
          fprintf("out=%2d ", y.out);
        end
        if isfield(y, "working")
          fprintf("working=%2d ", y.working);
        end
        if isfield(y, "n")
          fprintf("n=%2d", y.n);
        end
        fprintf("\n")
      end
    end
    
    function t = ta(obj)
      t = obj.sig;
    end
    
  end
end
