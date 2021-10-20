%% otto serial write/read test

command_packet_struct = ["uint32",  % Header
                         "single",  % LeftAngularVelo
                         "single",	% RightAngularVelo
                         "single",  % angleRotatedLeftMotor
                         "single",  % angleRotatedRightMotor
                         "uint64",  % timestamp
                         "uint32"]; % CRC
                    
sensor_packet_struct = ["uint32",	% Header
                        "single",   % LeftAngularVelo
                        "single",	% RightAngularVelo
                        "single",   % angleRotatedLeftMotor
                        "single",   % angleRotatedRightMotor
                        "single",   % yaw
                        "single",   % pitch
                        "single",   % roll
                        "uint64",   % timestamp
                        "uint32"];  % CRC

portName = "COM4";

uart = UartChannel(portName, 115200);
sensorData = SensorPacket();
sensorData = uart.read(sensorData);

fprintf("LeftV: %.4f, RightV: %.4f, LeftAngle: %.4f, RightAngle: %.4f, Time: %ld, CRC: %u\n", ...
        sensorData.omega_left,sensorData.omega_right, sensorData.theta_left, sensorData.theta_right, sensorData.time, sensorData.crc32);