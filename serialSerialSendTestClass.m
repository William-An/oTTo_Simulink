%% otto serial send write/read test
%  Only test sending to ESP32
clear;

% Initialize UART Port
portName = "COM4";
uart = UartChannel(portName, 460800);

fprintf("Connecting to %s\n", portName);
speed = 0;
% TODO Uart receiver Only heard the first few packets after uart object
% created, causing issue
kp = 20;
while true
    % Create packet instance
    speed = mod(speed + 10, 720);
    receiveData = SensorPacket();
    receiveData = uart.read(receiveData);
    flush(uart.port);

    speed = -kp * receiveData.pitch;
    commandData = CommandPacket.fromParams(speed, speed, 0, 0, 100, 400);
    uart.write(commandData);

    fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, YAW/PITCH/ROLL: %.4f/%.4f/%.4f Time: %ld, CRC: %u\n", ...
            receiveData.omega_left,receiveData.omega_right,... 
            receiveData.theta_left, receiveData.theta_right,...
            receiveData.yaw, receiveData.pitch, receiveData.roll,... 
            receiveData.time, receiveData.crc32);

    %fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, Time: %ld, CRC: %u\n", ...
    %        commandData.omega_left,commandData.omega_right,... 
    %        commandData.theta_left, commandData.theta_right,...
    %        commandData.time, commandData.crc32);
    
end