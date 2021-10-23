%% otto serial self loop write/read test
%  Connect the USB-to-Serial chip's RX to TX for self loop testing
clear;

% Initialize UART Port
portName = "COM7";
uart = UartChannel(portName, 115200);

% Write data to UART
dataToSend = SensorPacket.fromParams(1, -3, 23, -35, -90.2323, ...
                                     45.32, 74.32, 400, 232);
uart.write(dataToSend);

receiveData = SensorPacket();
receiveData = uart.read(receiveData);

fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, YAW/PITCH/ROLL: %.4f/%.4f/%.4f Time: %ld, CRC: %u\n", ...
        receiveData.omega_left,receiveData.omega_right,... 
        receiveData.theta_left, receiveData.theta_right,...
        receiveData.yaw, receiveData.pitch, receiveData.roll,... 
        receiveData.time, receiveData.crc32);
    
% Send command packet
command = CommandPacket.fromParams(1, -1, 0, 1, 200, 32);
uart.write(command);
receiveCommand = CommandPacket();
receiveCommand = uart.read(receiveCommand);