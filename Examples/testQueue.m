function [out] = testQueue(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 12;
    end
    
    tVec = [0.1 4.5 7.5 9.0 11.0 100];
    yVec = [1 0 1 0 1 1];
    tG = 1.0;
    n0 = 1.0;
    nG = 100;
    mdebug = false;               % model debug level

    N1 = coordinator("N1");

    Generator = devs(generator1("Generator", tG, n0, nG, mdebug));
    Vectorgen = devs(vectorgen("Vectorgen", tVec, yVec, mdebug));
    Queue = devs(queue("Queue", mdebug));
    Terminator = devs(terminator("Terminator"));
    GenOut = devs(toworkspace("GenOut", "genOut", 0));
    VgenOut = devs(toworkspace("VgenOut", "vgenOut", 0));
    queOut = devs(toworkspace("QueOut", "queOut", 0));
    queNOut = devs(toworkspace("QueNOut", "queNOut", 0));

    N1.add_model(Generator);
    N1.add_model(Vectorgen);
    N1.add_model(Queue);
    N1.add_model(Terminator);
    N1.add_model(GenOut);
    N1.add_model(VgenOut);
    N1.add_model(queOut);
    N1.add_model(queNOut);

    N1.add_coupling("Generator","out","Queue","in");
    N1.add_coupling("Vectorgen","out","Queue","bl");
    N1.add_coupling("Queue","out","Terminator","in");
    N1.add_coupling("Generator","out","GenOut","in");
    N1.add_coupling("Vectorgen","out","VgenOut","in");
    N1.add_coupling("Queue","out","QueOut","in");
    N1.add_coupling("Queue","nq","QueNOut","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    % plot results
    figure
    subplot(2,2,1)
    stem(simout.genOut.t,simout.genOut.y); grid on;
    xlim([0 tend]);
    xlabel("simulation time");
    ylabel("out");
    title("Generator");

    subplot(2,2,2)
    stairs(simout.vgenOut.t,simout.vgenOut.y); grid on;
    hold("on");plot(simout.vgenOut.t,simout.vgenOut.y, "*");hold("off");
    xlim([0 tend]);
    ylim([-0.1, 1.1])
    xlabel("simulation time");
    ylabel("in");
    title("Blocking");

    subplot(2,2,3)
    stem(simout.queOut.t,simout.queOut.y); grid on;
    xlim([0 tend]);
    xlabel("simulation time");
    ylabel("out");
    title("Queue");

    subplot(2,2,4)
    stairs(simout.queNOut.t,simout.queNOut.y); grid on;
    hold("on");plot(simout.queNOut.t,simout.queNOut.y, "*");hold("off");
    xlim([0 tend]);
    xlabel("simulation time");
    ylabel("nq");
    title("Queue");
    
    out = simout;
end
