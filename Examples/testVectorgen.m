function [out] = testVectorgen(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 17;
    end
    
    tVec = [1, 3, 7, 8, 9];
    yVec = [2, 3, 2, 2, 1];
    debug = false;

    N1 = coordinator("N1");

    Vectorgen = devs(vectorgen("Vectorgen", tVec, yVec, debug));
    Terminator = devs(terminator("Terminator"));
    Genout = devs(toworkspace("Genout", "genOut", 0));

    N1.add_model(Vectorgen);
    N1.add_model(Terminator);
    N1.add_model(Genout);

    N1.add_coupling("Vectorgen","out","Terminator","in");
    N1.add_coupling("Vectorgen","out","Genout","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure;
    stairs(simout.genOut.t,simout.genOut.y);
    hold("on");plot(simout.genOut.t,simout.genOut.y, "*");hold("off");
    grid("on");
    xlim([0, tend])
    ylim([-0.1, 3.2])
    xlabel("simulation time");
    ylabel("out");
    title("VectorGen");

    out = simout;
end