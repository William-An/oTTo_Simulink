%% Sensor packet class
classdef SensorPacket < Packet
    properties
        omega_left  {mustBeNumeric, mustBeFloat}
        omega_right {mustBeNumeric, mustBeFloat}
        theta_left  {mustBeNumeric, mustBeFloat}
        theta_right {mustBeNumeric, mustBeFloat}
        yaw         {mustBeNumeric, mustBeFloat}
        pitch       {mustBeNumeric, mustBeFloat}
        roll        {mustBeNumeric, mustBeFloat}
        time        {mustBeNumeric, mustBeFloat}
        crc32
        struct_map  = [ "single",   % LeftAngularVelo
                        "single",	% RightAngularVelo
                        "single",   % angleRotatedLeftMotor
                        "single",   % angleRotatedRightMotor
                        "single",   % yaw
                        "single",   % pitch
                        "single",   % roll
                        "uint32",   % timestamp
                        "uint32"];  % CRC
    end
    
    methods (Static)
        % Static constructor
        function obj = fromParams(omega_left, omega_right, ...
                                  theta_left, theta_right, yaw, ... 
                                  pitch, roll, time, crc32)
            obj = SensorPacket();
            obj.omega_left  = omega_left;
            obj.omega_right = omega_right;
            obj.theta_left  = theta_left;
            obj.theta_right = theta_right;
            obj.yaw         = yaw;
            obj.pitch       = pitch;
            obj.roll        = roll;
            obj.time        = time;
            obj.crc32       = crc32;
        end

        function obj = fromArray(array)
            obj = SensorPacket();
            obj.omega_left  = array(1);
            obj.omega_right = array(2);
            obj.theta_left  = array(3);
            obj.theta_right = array(4);
            obj.yaw         = array(5);
            obj.pitch       = array(6);
            obj.roll        = array(7);
            obj.time        = array(8);
            obj.crc32       = array(9);
        end
    end
    
    methods
        function obj = SensorPacket()
            % TODO Calculate CRC32?
            obj.omega_left  = 0;
            obj.omega_right = 0;
            obj.theta_left  = 0;
            obj.theta_right = 0;
            obj.yaw         = 0;
            obj.pitch       = 0;
            obj.roll        = 0;
            obj.time        = 0;
            obj.crc32       = 0;
        end
        
        function calculateCRC(obj)
            % TODO add CRC algo here and check for match?
        end
        
        function serialized = toArray(obj)
            serialized = zeros(1, length(obj.struct_map));
            serialized(1) = obj.omega_left;
            serialized(2) = obj.omega_right;
            serialized(3) = obj.theta_left;
            serialized(4) = obj.theta_right;
            serialized(5) = obj.yaw;
            serialized(6) = obj.pitch;
            serialized(7) = obj.roll;
            serialized(8) = obj.time;
            serialized(9) = obj.crc32;
        end
    end
end