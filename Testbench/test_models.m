function tests = test_models
	tests = functiontests(localfunctions);
end

%Run the models in the Examplex directory and compare the results 
%with the saved results.
%
%run with: run(test_models)

function test_model1(testCase)
	act_out = model1(10);
	load('model1_out.mat');
	verifyEqual(testCase, act_out, model1_out)
	close all;
end

function test_model2(testCase)

	act_out = model2(10);
	load('model2_out.mat');
	verifyEqual(testCase, act_out, model2_out)
	close all;
end

function test_model3(testCase)

	act_out = model3(10);
	load('model3_out.mat');
	verifyEqual(testCase, act_out, model3_out)
	close all;
end

function test_model4(testCase)

	act_out = model4(10);
	load('model4_out.mat');
	verifyEqual(testCase, act_out, model4_out)
	close all;
end

function test_model4a(testCase)

	act_out = model4a(10);
	load('model4a_out.mat');
	verifyEqual(testCase, act_out, model4a_out)
	close all;
end

function test_model5(testCase)

	act_out = model5(10);
	load('model5_out.mat');
	verifyEqual(testCase, act_out, model5_out)
	close all;
end

function test_compswitch(testCase)

	act_out = compswitch(17.5);
	load('compswitch_out.mat');
	verifyEqual(testCase, act_out, compswitch_out)
	close all;
end

function test_compswitchCascade1(testCase)

	act_out = compswitchCascade1(17.5);
	load('compswitchCascade1_out.mat');
	verifyEqual(testCase, act_out, compswitchCascade1_out)
	close all;
end

function test_compswitchCascade1a(testCase)

	act_out = compswitchCascade1a(17.5);
	load('compswitchCascade1a_out.mat');
	verifyEqual(testCase, act_out, compswitchCascade1a_out)
	close all;
end

function test_compswitchCascade2(testCase)

	act_out = compswitchCascade2(17.5);
	load('compswitchCascade2_out.mat');
	verifyEqual(testCase, act_out, compswitchCascade2_out)
	close all;
end

function test_singleserver(testCase)
	%the simulator cannot handle algebraic loops yet 
	
	%act_out = singleserver(3);
	%load('compswitchCascade2_out.mat');
	verifyEqual(testCase, 1, 1)
	close all;
end

function test_testComparator(testCase)

	act_out = testComparator(17.5);
	load('testComparator_out.mat');
	verifyEqual(testCase, act_out, testComparator_out)
	close all;
end

function test_testGain(testCase)

	act_out = testGain(17.5);
	load('testGain_out.mat');
	verifyEqual(testCase, act_out, testGain_out)
	close all;
end

function test_testGenerator1(testCase)

	act_out = testGenerator1(17.5);
	load('testGenerator1_out.mat');
	verifyEqual(testCase, act_out, testGenerator1_out)
	close all;
end

function test_testOutputswitch(testCase)

	act_out = testOutputswitch(17.5);
	load('testOutputswitch_out.mat');
	verifyEqual(testCase, act_out, testOutputswitch_out)
	close all;
end

function test_testQueue(testCase)

	act_out = testQueue(12);
	load('testQueue_out.mat');
	verifyEqual(testCase, act_out, testQueue_out)
	close all;
end

function test_testServer(testCase)

	act_out = testServer(8);
	load('testServer_out.mat');
	verifyEqual(testCase, act_out, testServer_out)
	close all;
end

function test_testVectorgen(testCase)

	act_out = testVectorgen(17);
	load('testVectorgen_out.mat');
	verifyEqual(testCase, act_out, testVectorgen_out)
	close all;
end