function oTTo_api(block)
%MSFUNTMPL A Template for a MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl' with the name
%   of your S-function.  

%   Copyright 2003-2018 The MathWorks, Inc.
  
%
% The setup method is used to setup the basic attributes of the
% S-function such as ports, parameters, etc. Do not add any other
% calls to the main body of the function.  
%   
setup(block);
  
%endfunction

% Function: setup ===================================================
% Abstract:
%   Set up the S-function block's basic characteristics such as:
%   - Input ports
%   - Output ports
%   - Dialog parameters
%   - Options
% 
%   Required         : Yes
%   C MEX counterpart: mdlInitializeSizes
%
function setup(block)
  % Register the parameters.
  % portName and Baudrate
  block.NumDialogPrms = 3;
  block.DialogPrmsTunable = {'Tunable','Tunable','Tunable'};
  
  % Register the number of ports.
  % left_omega, right_omega
  block.NumInputPorts  = 2;
  % Pitch, roll, yaw
  block.NumOutputPorts = 3;
  
  % Set up the port properties to be inherited or dynamic.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;

  % Set up the continuous states.
  block.NumContStates = 0;

  % Register the sample times.
  %  [0 offset]            : Continuous sample time
  %  [positive_num offset] : Discrete sample time
  %
  %  [-1, 0]               : Inherited sample time
  %  [-2, 0]               : Variable sample time
  block.SampleTimes = [0 0];
  
  % -----------------------------------------------------------------
  % Options
  % -----------------------------------------------------------------
  % Specify if Accelerator should use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  
  % Specify the block's operating point compliance. The block operating 
  % point is used during the containing model's operating point save/restore)
  % The allowed values are:
  %   'Default' : Same the block's operating point as of a built-in block
  %   'UseEmpty': No data to save/restore in the block operating point
  %   'Custom'  : Has custom methods for operating point save/restore
  %                 (see GetOperatingPoint/SetOperatingPoint below)
  %   'Disallow': Error out when saving or restoring the block operating point.
  block.OperatingPointCompliance = 'Default';
  
  % -----------------------------------------------------------------
  % Register the methods called during update diagram/compilation.
  % -----------------------------------------------------------------
  block.RegBlockMethod('CheckParameters', @CheckPrms);
  block.RegBlockMethod('SetInputPortSamplingMode', @SetInpPortFrameData);

  % -----------------------------------------------------------------
  % Register methods called at run-time
  % -----------------------------------------------------------------
  block.RegBlockMethod('ProcessParameters', @ProcessPrms);
  block.RegBlockMethod('Start', @Start);
  block.RegBlockMethod('Outputs', @Outputs);
%endfunction

% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------

function CheckPrms(block)
  %% COM Port name
  % TODO Do type check for COM?
  %a = block.DialogPrm(1).Data;
  %if ~isa(a, 'String')
  %  me = MSLException(block.BlockHandle, message('Simulink:blocks:invalidParameter'));
  %  throw(me);
  %end
  
  %% Baudrate
  % TODO Check for valid baudrate?
  a = block.DialogPrm(2).Data;
  if ~isa(a, 'double')
    me = MSLException(block.BlockHandle, message('Simulink:blocks:invalidParameter'));
    throw(me);
  end
  
  % Uart
  % TODO Create UART in block
  portName = block.DialogPrm(1).Data;
  baudrate = block.DialogPrm(2).Data;
  % uart = UartChannel(portName, baudrate);
  % block.DialogPrm(3).Data = uart;
  
%endfunction

function SetInpPortFrameData(block, idx, fd)
  
  block.InputPort(idx).SamplingMode = fd;
  block.OutputPort(1).SamplingMode  = fd;
  block.OutputPort(2).SamplingMode  = fd;
  block.OutputPort(3).SamplingMode  = fd;
  
%endfunction

function ProcessPrms(block)

  block.AutoUpdateRuntimePrms;
 
%endfunction

function Start(block)
  % Uart
  % TODO Create UART in block
  portName = block.DialogPrm(1).Data;
  baudrate = block.DialogPrm(2).Data;
  % uart = UartChannel(portName, baudrate);
  % block.ContStates.Data = uart;
%endfunction

function Outputs(block)

uart = block.DialogPrm(3).Data;
omega_left = block.InputPort(1).Data;
omega_right = block.InputPort(2).Data;

commandData = CommandPacket.fromParams(omega_left, omega_right, 0, 0, 100, 400);
uart.write(commandData);

receiveData = SensorPacket();
receiveData = uart.read(receiveData);
flush(uart.port);

block.OutputPort(1).Data = receiveData.yaw;
block.OutputPort(2).Data = receiveData.pitch;
block.OutputPort(3).Data = receiveData.roll;

%end Outputs function

