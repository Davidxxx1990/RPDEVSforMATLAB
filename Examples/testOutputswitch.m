function [out] = testOutputswitch(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 17.5;
    end
    
    tG = 1;
    tVec = [1, 3, 7, 8, 9];
    yVec = [1, 0, 0, 1, 0];
    debug = false;

    N1 = coordinator("N1");

    Generator1 = devs(generator1("Generator1", tG, 1, 100, debug));
    Vectorgen = devs(vectorgen("Vectorgen", tVec, yVec, debug));
    Outputswitch = devs(outputswitch("Outputswitch", 1, debug));
    Terminator1 = devs(terminator("Terminator1"));
    Terminator2 = devs(terminator("Terminator2"));
    Genout = devs(toworkspace("Genout", "genOut", 0));
    VGenout = devs(toworkspace("VGenout", "vgenOut", 0));
    Switchout1 = devs(toworkspace("Switchout1", "sw1Out", 0));
    Switchout2 = devs(toworkspace("Switchout2", "sw2Out", 0));

    N1.add_model(Generator1);
    N1.add_model(Vectorgen);
    N1.add_model(Outputswitch);
    N1.add_model(Terminator1);
    N1.add_model(Terminator2);
    N1.add_model(Genout);
    N1.add_model(VGenout);
    N1.add_model(Switchout1);
    N1.add_model(Switchout2);

    N1.add_coupling("Generator1","out","Outputswitch","in");
    N1.add_coupling("Vectorgen","out","Outputswitch","sw");
    N1.add_coupling("Outputswitch","out1","Terminator1","in");
    N1.add_coupling("Outputswitch","out2","Terminator2","in");
    N1.add_coupling("Generator1","out","Genout","in");
    N1.add_coupling("Vectorgen","out","VGenout","in");
    N1.add_coupling("Outputswitch","out1","Switchout1","in");
    N1.add_coupling("Outputswitch","out2","Switchout2","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure("Position",[1 1 450 600]);
    subplot(4,1,1)
    stairs(simout.genOut.t,simout.genOut.y);
    hold("on");plot(simout.genOut.t,simout.genOut.y, "*");hold("off");
    grid("on");
    xlim([0, tend])
    ylim([0, 18])
    ylabel("out");
    title("Generator");

    subplot(4,1,2)
    stairs(simout.vgenOut.t,simout.vgenOut.y);
    hold("on");plot(simout.vgenOut.t,simout.vgenOut.y, "*");hold("off");
    grid("on");
    xlim([0, tend])
    ylim([-0.1, 1.1])
    ylabel("out");
    title("VectorGen");

    subplot(4,1,3)
    stairs(simout.sw1Out.t,simout.sw1Out.y);
    hold("on");plot(simout.sw1Out.t,simout.sw1Out.y, "*");hold("off");
    grid("on");
    xlim([0, tend])
    ylim([0, 18])
    ylabel("out1");
    title("Switch");

    subplot(4,1,4)
    stairs(simout.sw2Out.t,simout.sw2Out.y);
    hold("on");plot(simout.sw2Out.t,simout.sw2Out.y, "*");hold("off");
    grid("on");
    xlim([0, tend])
    ylim([0, 18])
    ylabel("out2");
    title("Switch");
    
    out = simout;
end
