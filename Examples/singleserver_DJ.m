%function singleserver()
clear all; close all;
global simout
global epsilon
global DEBUGLEVEL
simout = [];
DEBUGLEVEL = 1;           % simulator debug level
epsilon = 1e-6;

nG = 100;
tG = 1;
tS = 1.5;
tEnd = 10;
mdebug = false;

N1 = coordinator("N1");

Generator = devs(generator1("Generator", tG, 1, nG, mdebug));
Queue = devs(queue("Queue", mdebug));
Server = devs(server("Server", tS, mdebug));
Terminator = devs(terminator("Terminator"));
%GenOut = devs(toworkspace("GenOut", "genOut", 0));
%QueOut = devs(toworkspace("QueOut", "queOut", 0));
%QueNOut = devs(toworkspace("QueNOut", "quenOut", 0));
%SrvOut = devs(toworkspace("SrvOut", "srvOut", 0));

N1.add_model(Generator);
N1.add_model(Queue);
N1.add_model(Server);
N1.add_model(Terminator);
%N1.add_model(GenOut);
%N1.add_model(QueOut);
%N1.add_model(QueNOut);
%N1.add_model(SrvOut);

N1.add_coupling("Generator","out","Queue","in");
N1.add_coupling("Queue","out","Server","in");
N1.add_coupling("Server","out","Terminator","in");
N1.add_coupling("Server","working","Queue","bl");
%N1.add_coupling("Generator","out","GenOut","in");
%N1.add_coupling("Queue","out","QueOut","in");
%N1.add_coupling("Queue","nq","QueNOut","in");
%N1.add_coupling("Server","out","SrvOut","in");

root = rootcoordinator("root",0,tEnd,N1,0);
root.sim();

% plot results
% figure('Position',[1 1 550 350])
% subplot(2,2,1)
% stem(simout.genOut.t,simout.genOut.y); 
% grid("on");
% xlim([0 tEnd]);
% ylim([0, 10.5])
% ylabel("out");
% title("Generator");
% 
% subplot(2,2,2)
% stem(simout.queOut.t,simout.queOut.y);
% grid("on");
% xlim([0 tEnd]);
% ylim([0, 7.5])
% ylabel("out");
% title("Queue");
% 
% subplot(2,2,3)
% stairs(simout.quenOut.t,simout.quenOut.y);
% hold("on");plot(simout.quenOut.t,simout.quenOut.y, "*");hold("off");
% grid("on");
% xlim([0 tEnd]);
% %ylim([0, 4.5])
% ylabel("nq");
% title("Queue");
% 
% subplot(2,2,4)
% stem(simout.srvOut.t,simout.srvOut.y);
% grid("on");
% xlim([0 tEnd]);
% ylim([0, 6.5])
% ylabel("out");
% title("Server");
