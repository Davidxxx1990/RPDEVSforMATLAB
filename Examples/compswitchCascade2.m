function [out] = compswitchCascade2(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 17.5;
    end
    
    tVec = [1, 3, 7, 8, 9];
    yVec = [2, -3, -2, 1, -1];
    g = 2;
    debug = false;

    N1 = coordinator("N1");

    Vectorgen = devs(vectorgen("Vectorgen", tVec, yVec, debug));
    Comparator = devs(comparator("Comparator", debug));
    Gain1 = devs(gain("Gain1", g, debug));
    Gain2 = devs(gain("Gain2", g, debug));
    Outputswitch = devs(outputswitch("Outputswitch", 1, debug));
    Terminator1 = devs(terminator("Terminator1"));
    Terminator2 = devs(terminator("Terminator2"));
    VGenout = devs(toworkspace("VGenout", "vgenOut", 0));
    Compout = devs(toworkspace("Compout", "compOut", 0));
    Switchout1 = devs(toworkspace("Switchout1", "sw1Out", 0));
    Switchout2 = devs(toworkspace("Switchout2", "sw2Out", 0));

    N1.add_model(Vectorgen);
    N1.add_model(Comparator);
    N1.add_model(Gain1);
    N1.add_model(Gain2);
    N1.add_model(Outputswitch);
    N1.add_model(Terminator1);
    N1.add_model(Terminator2);
    N1.add_model(VGenout);
    N1.add_model(Compout);
    N1.add_model(Switchout1);
    N1.add_model(Switchout2);

    N1.add_coupling("Vectorgen","out","Outputswitch","in");
    N1.add_coupling("Vectorgen","out","Gain1","in");
    N1.add_coupling("Gain1","out","Gain2","in");
    N1.add_coupling("Gain2","out","Comparator","in");
    N1.add_coupling("Comparator","out","Outputswitch","sw");
    N1.add_coupling("Outputswitch","out1","Terminator1","in");
    N1.add_coupling("Outputswitch","out2","Terminator2","in");
    N1.add_coupling("Vectorgen","out","VGenout","in");
    N1.add_coupling("Comparator","out","Compout","in");
    N1.add_coupling("Outputswitch","out1","Switchout1","in");
    N1.add_coupling("Outputswitch","out2","Switchout2","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure("Position",[1 1 450 600]);
    subplot(4,1,1)
    stem(simout.vgenOut.t,simout.vgenOut.y);
    grid("on");
    xlim([0, tend])
    ylim([-3.2, 2.2])
    ylabel("out");
    title("VectorGen");

    subplot(4,1,2)
    stairs(simout.compOut.t,simout.compOut.y);
    hold("on");plot(simout.compOut.t,simout.compOut.y, "*");hold("off");
    grid("on");
    xlim([0, tend])
    ylim([-0.1, 1.1])
    ylabel("out");
    title("Comparator");

    subplot(4,1,3)
    stem(simout.sw1Out.t,simout.sw1Out.y);
    grid("on");
    xlim([0, tend])
    ylim([-3.2, 2.2])
    ylabel("out1");
    title("Switch");

    subplot(4,1,4)
    stem(simout.sw2Out.t,simout.sw2Out.y);
    grid("on");
    xlim([0, tend])
    ylim([-3.2, 2.2])
    ylabel("out2");
    title("Switch");

    out = simout;
end
