classdef coordinator < handle
   properties
        parent  %parent coordinator
        name
        tl      %time of last event
        tn      %time of next event

        D       %children
        I       %couplings
        
        IC      %internal coupling
        EIC     %external to internal coupling
        IEC     %internal to external coupling
        
        eventlist
        IMM     %imminent children
		INF		%influenced children
		N_INF	%INF for next lambda-iteration
		DELTA	%children who needs a state transition
		CHECK
        mail    %output mail bag
        yparent %output message bag for parent
        y       %output message bags
		rec		%...
        
        lambda_iteration_flag
        debug_level = get_debug_level();
   end
    
   methods
%% constructor  
        function obj = coordinator(name)
            obj.name = name;
            obj.D = {};
            obj.eventlist = [];
            obj.y = [];
            obj.mail = [];
            obj.I = [];
            obj.IC = [];
            obj.EIC = [];
            obj.IEC = [];
            obj.lambda_iteration_flag = 0;
        end
%% set methods
        function set_parent(obj,value)
            obj.parent = value;
        end
%% add methods
        function add_model(obj,mdl)
            obj.D = {obj.D{:},mdl};
            mdl.set_parent(obj);
        end
        function add_coupling(obj,from_mdl,from_port,to_mdl,to_port)
            coupling.from_mdl = from_mdl;
            coupling.from_port = from_port;
            coupling.to_mdl = to_mdl;
            coupling.to_port = to_port;
            
            obj.I = [obj.I, coupling];
            
            if(strcmp(coupling.from_mdl,obj.name))
                %EIC
                obj.EIC = [obj.EIC,coupling];
            elseif(strcmp(coupling.to_mdl,obj.name))
                %IEC
                obj.IEC = [obj.IEC,coupling];
            else
                %IC
                obj.IC = [obj.IC,coupling];
            end
            
        end
%% get methods 
        function tn = get_tn(obj)
            tn = obj.tn;
        end
        
        function tl = get_tl(obj)
            tl = obj.tl;
        end
        
        function name = get_name(obj)
            name = obj.name;
		end
		
		function [INF,receivers] = get_inf_by_x(obj,x)
			INF={};
			receivers=[];
			if ~isempty(x)
                %EIC
                ports = fieldnames(x);
				receivers=[];
                for k=1:length(ports)
                    for d=1:length(obj.EIC)
                       
                        if(strcmp(ports(k),obj.EIC(d).from_port))
                            if(isempty(receivers))
                                    idx=[];
                            else
                                idx=find_mdl(receivers,obj.EIC(d).to_mdl);
                            end
                            
                            if(isempty(idx))
                                r.name =  obj.EIC(d).to_mdl;
                                r.x.(obj.EIC(d).to_port) = x.(obj.EIC(d).from_port);
                                receivers = [receivers,r];
                            else
                                r(idx).name =  obj.EIC(d).to_mdl;
                                r(idx).x.(obj.EIC(d).to_port) = x.(obj.EIC(d).from_port);
                            end
                            
                        end
                    end
				end
				for r=1:length(receivers)
					idx = find_mdl_in_cell(obj.D, receivers(r).name);
					if(~isempty(idx))
						
						INF = {INF{:}, obj.D{idx}};
					else
						disp('error coordinator get_inf_by_x');
						pause();
					end
				end
				
            end
		end
		
		function [INF,receivers] = get_inf_by_y(obj,y,name)
			
			    receivers=[];
				INF={};
				
				if ~isempty(y)
				
					ports=fieldnames(y);

					for l=1:length(ports)
						for k=1:length(obj.IC)

							if( strcmp(name,obj.IC(k).from_mdl) && strcmp(ports(l),obj.IC(k).from_port) )

								if(isempty(receivers))
									idx=[];
								else
									idx=find_mdl(receivers,obj.IC(k).to_mdl);
								end

								if(isempty(idx))
									r=[];
									r.name=obj.IC(k).to_mdl;
									r.x.(obj.IC(k).to_port) = y.(obj.IC(k).from_port);

									receivers = [receivers, r];
								else
									receivers(idx).x.(obj.IC(k).to_port) = y.(obj.IC(k).from_port);
								end

							end

						end
					end
					for r=1:length(receivers)
						idx = find_mdl_in_cell(obj.D, receivers(r).name);
						if(~isempty(idx))

							INF = {INF{:} obj.D{idx}};
						else
							disp('error coordinatror get_inf_by_y');
							pause();
						end
					end
				end
		end
		
		function update_yparent(obj,y,name)
			
			if ~isempty(y)		
				ports=fieldnames(y);

				for l=1:length(ports)
					for k=1:length(obj.IEC)
						if( strcmp(name,obj.IEC(k).from_mdl) && strcmp(ports(l),obj.IEC(k).from_port) )
							if(isempty(obj.yparent))
								obj.yparent.(obj.IEC(k).to_port) = y.(obj.IEC(k).from_port);
							else
								if any( arrayfun(@(x) strcmp(obj.IEC(k).to_port,x),fieldnames(obj.yparent) ) )
									obj.yparent.(obj.IEC(k).to_port) = y.(obj.IEC(k).from_port);%[obj.yparent.(obj.IEC(k).to_port) , y.(obj.IEC(k).from_port)];
								else
									obj.yparent.(obj.IEC(k).to_port) = y.(obj.IEC(k).from_port);
								end
							end
						end
					end
				end
			end
		end
		
%%
        function create_eventlist(obj)
            obj.eventlist=[];
            for d=1:length(obj.D)
                obj.eventlist = [obj.eventlist;d,obj.D{d}.get_tn,obj.D{d}.get_tl];
            end
            obj.eventlist = sortrows(obj.eventlist,2);
		end
		
		function check_INF(obj)
			
			INF = {};
			
			for i=1:length(obj.INF)
				if ~any(cellfun(@(x) strcmp(x.get_name(),obj.INF{i}.get_name()), INF))
					INF = {INF{:},obj.INF{i}};
				end
			end
			
			obj.INF = INF;
			
		end
		function check_DELTA(obj)
			
			DELTA = {};
			
			for i=1:length(obj.DELTA)
				if ~any(cellfun(@(x) strcmp(x.get_name(),obj.DELTA{i}.get_name()), DELTA))
					DELTA = {DELTA{:},obj.DELTA{i}};
				end
			end
			
			obj.DELTA = DELTA;
			
        end
        function [receivers] = get_recivers_from_mail(obj)
			receivers=[];
			for j=1:length(obj.mail)
                    name=obj.mail(j).name;
                    ports=fieldnames(obj.mail(j).y);
                    for l=1:length(ports)
                        for k=1:length(obj.IC)
                       
                            if( strcmp(name,obj.IC(k).from_mdl) && strcmp(ports(l),obj.IC(k).from_port) )
                               
                                if(isempty(receivers))
                                    idx=[];
                                else
                                    idx=find_mdl(receivers,obj.IC(k).to_mdl);
                                end
                                
                                if(isempty(idx))
                                    r=[];
                                   r.name=obj.IC(k).to_mdl;
                                   r.x.(obj.IC(k).to_port) = obj.mail(j).y.(obj.IC(k).from_port);
                                   
                                   receivers = [receivers, r];
                                else
                                    receivers(idx).x.(obj.IC(k).to_port) = obj.mail(j).y.(obj.IC(k).from_port);
                                end
                                
                            end
                            
                        end
                    end
                end
        end
        function merge_receivers(obj,receivers)
			
			for i=1:length(receivers)
				
				if(isempty(obj.rec))
					idx=[];
				else
					idx=find_mdl(obj.rec,receivers(i).name);
				end

				if(isempty(idx))
					obj.rec = [obj.rec, receivers(i)];
				else
					names=fieldnames(receivers(i).x);
					for k=1:length(names)
						if(any(arrayfun(@(x)strcmp(x,names(k)),fieldnames(obj.rec(idx).x))))
							obj.rec(idx).x.(char(names(k))) = receivers(i).x.(char(names(k))); %[obj.rec(idx).x.(char(names(k))) receivers(i).x.(char(names(k)))];
						else
							obj.rec(idx).x.(char(names(k))) = receivers(i).x.(char(names(k)));
						end
					end
				end
			end
			
        end		
		function remove_d_from_INF(obj,d)

			INF={};
			for i=1:length(obj.INF)
				if i~=d
					INF={ INF{:}, obj.INF{i} };
				end
			end
			obj.INF = INF;
		end
%% message functions 
        function imessage(obj,t)
            obj.IMM = {};
			obj.INF = {};
			obj.DELTA = {};
			obj.N_INF = {};
			obj.mail =[];
			obj.rec = [];
			obj.yparent = [];
            
            if obj.debug_level == 1
                sequenceaddlink(sprintf('i-msg(t=%f)',t),obj.get_name);
            end
            for d=1:length(obj.D)
                obj.D{d}.imessage(t);
                if obj.debug_level == 1
                    sequenceaddlink(sprintf('done',t),obj.get_name);
                end
            end
            
            obj.create_eventlist();
            
            obj.tl = max(obj.eventlist(:,3)); 
            obj.tn = min(obj.eventlist(:,2));
        end

        function smessage(obj,x,t)
            if obj.debug_level == 1
                disp(['coordinator: ' obj.name ' s-message x-value:']);
                disp(x);
                if isempty(x)
                    sequenceaddlink(sprintf('*-msg([],t=%f)',t),obj.get_name);
                else
                    sequenceaddlink(sprintf('*-msg(x,t=%f)',t),obj.get_name);
                end
            end
			
            id = find(obj.eventlist(:,2) == t);
            while ~isempty(id)
                %obj.IMM = {obj.IMM{:},obj.D{ obj.eventlist(id(1),1) } };
				obj.INF = {obj.INF{:},obj.D{ obj.eventlist(id(1),1) } };
				obj.DELTA = {obj.DELTA{:},obj.D{ obj.eventlist(id(1),1) } };
                obj.eventlist(id(1),:) = [];
                id = find(obj.eventlist(:,2) == t);
			end
            
			[INF,receivers] = get_inf_by_x(obj,x);
			obj.INF = {obj.INF{:}, INF{:}};
			obj.DELTA = {obj.DELTA{:}, INF{:}};
			check_INF(obj);
			check_DELTA(obj);
			obj.merge_receivers(receivers);
			
            obj.N_INF = {};
            
            while ~isempty(obj.INF)
				idx = find_mdl(obj.rec, obj.INF{1}.get_name);
				
				if(isempty(idx))
					obj.INF{1}.smessage([],t);
				else
					obj.INF{1}.smessage(obj.rec(idx).x,t); 
				end
            end
            
		end
		

		
		
		function ymessage(obj,y,name,t)
            if obj.debug_level == 1
                disp(['coordinator: ' obj.name ' y-message from: ' name ' value:']);
                disp(y);
                if isempty(y)
                    sequenceaddlink(sprintf('y-msg([],%s,%f)',name,t),obj.get_name);
                else
                    sequenceaddlink(sprintf('y-msg(y,%s,%f)',name,t),obj.get_name);
                end
            end
            
			if ~isempty(y)
				mail_d =[];
				mail_d.name = name;
				mail_d.y = y;
				mail_d.t = t;

				obj.mail = [obj.mail, mail_d];
			end
			
			d = find_mdl_in_cell(obj.INF, name);
			obj.remove_d_from_INF(d);

			[INF,receivers] = get_inf_by_y(obj,y,name);


			obj.N_INF = {obj.N_INF{:} INF{:}};
			obj.DELTA = {obj.DELTA{:} INF{:}};
			check_DELTA(obj);
			
			update_yparent(obj,y,name);
			

            if ~obj.lambda_iteration_flag && isempty(obj.INF)
                obj.lambda_iteration_flag = 1;

                while ~(isempty(obj.INF) && isempty(obj.N_INF)) 
                    obj.INF = obj.N_INF;
                    obj.N_INF = {};
                    check_INF(obj);

                    receivers = get_recivers_from_mail(obj);
                    obj.merge_receivers(receivers);
                    obj.mail = [];

                    while ~isempty(obj.INF)
                        idx = find_mdl(obj.rec, obj.INF{1}.get_name);

                        if(isempty(idx))
                            obj.INF{1}.smessage([],t);
                        else
                            obj.INF{1}.smessage(obj.rec(idx).x,t); 
                        end
                    end



                end
                if isempty(obj.N_INF)
                    obj.lambda_iteration_flag = 0;
                    obj.parent.ymessage(obj.yparent,obj.name,t);

                end

            end


		end
	

	
	

		function xmessage(obj,x,t)
            if obj.debug_level == 1
                disp(['coordinator: ' obj.name ' x-message' ' value:']);
                disp(x);
                if isempty(x)
                    sequenceaddlink(sprintf('x-msg([],%f)',t),obj.get_name);
                else
                    sequenceaddlink(sprintf('x-msg(x,%f)',t),obj.get_name);
                end
            end
			
			for r=1:length(obj.DELTA)
				idx = find_mdl(obj.rec, obj.DELTA{r}.get_name);

				if(isempty(idx))
					obj.DELTA{r}.xmessage([],t);
				else
					obj.DELTA{r}.xmessage(obj.rec(idx).x,t); 
				end
				if obj.debug_level == 1
					sequenceaddlink('done',obj.get_name);
				end
            end
            obj.DELTA = {};
            obj.rec = [];
			obj.create_eventlist();             
			obj.tl = t;
            obj.tn = min(obj.eventlist(:,2));
            
            
            
            
            obj.IMM = {};
			obj.INF = {};
			
			obj.N_INF = {};
			obj.mail =[];
			obj.yparent = [];
			
		end
		


		

    end
 
end







