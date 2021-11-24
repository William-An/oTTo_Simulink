%% Test ESP-NOW

% Send data to adapter
portName = "/dev/cu.usbserial-1440";
uart = UartChannel(portName, 115200);
commandData = CommandPacket.fromParams(1, 1, 0, 0, 100, 400);

t = 0;
while true
    commandData.omega_left = t;
    t = t + 1;
    pause(0.01);
    uart.write(commandData);
end

% Read ESP-NOW PC adapter Log
while true
    fprintf("%s\n", readline(uart.port));
end
