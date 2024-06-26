%% Uart control center
%  Incharge of setup serial port and recive and send data
%  Asynchronous send/receive
%  @author:     Weili An
%  @email:      an107@purdue.edu
%  @date:       Oct. 20, 2021
%  @version:    v1.0.0

classdef UartChannel
    properties
        % Sender queue
        sendQueue

        % Receiver queue
        receiveQueue

        % UART Port
        port
    end
    properties (Constant)
        % Header used to sync bytes
        header = 0x92384233;
        headerBytes = [0x33, 0x42, 0x38, 0x92];
    end
    methods
        function obj = UartChannel(portName, baudRate)
            obj.port = serialport(portName, baudRate, "Parity","even");
        end

        function enqueue(obj, queueName)
            if queueName == "Receive"
            elseif queueName == "Send"
            else
                fprintf("[!] Unrecognized queue name: %s\n", queueName);
            end
        end

        function dequeue(obj, queueName)
            if queueName == "Receive"
            elseif queueName == "Send"
            else
                fprintf("[!] Unrecognized queue name: %s\n", queueName);
            end
        end

        % Read a packet from UART as specified with packet 
        function packet = read(obj, packet)
            % Sync header
            syncHeader(obj);
            
            % Read every field of the packet
            packet_size = length(packet.struct_map);
            buffer = zeros(1, packet_size);
            for i = 1:packet_size
                buffer(i) = read(obj.port, 1, packet.struct_map(i));
            end

            % Return packet
            packet = packet.fromArray(buffer);
        end
        
        % write a packet onto the uart port
        function write(obj, packet)
            % Send header
            sendHeader(obj);
            
            % Send every field of the packet
            packet_size = length(packet.struct_map);
            serialized = packet.toArray();
            for i = 1:packet_size
                write(obj.port, serialized(i),  packet.struct_map(i));
            end
        end

        % Sync UART Header
        function syncHeader(obj)
            index = 1;
            % TODO Better handling?
            % Read in batch?
            miss_count = 0;
            while index <= 4
                tmp = read(obj.port, 1, "uint8");
                if tmp == obj.headerBytes(index)
                    % Match current, check next
                    index = index + 1;
                    miss_count = miss_count + 1;
                elseif tmp == obj.headerBytes(1)
                    % Potential restart
                    index = 2;
%                     fprintf("[!] Reset header counter after %d misses, c = %c, %x\n", miss_count, tmp, tmp);
                    miss_count = 0;
                else
                    % Reset
                    index = 1;
%                     fprintf("[!] Reset header counter after %d misses, c = %c, %x\n", miss_count, tmp, tmp);
                    miss_count = 0;
                end
            end

%             buf = zeros(1, 4);
%             bufTmp = zeros(1, 3);
%             while true
%                 tmp = read(obj.port, 1, "uint8");
%                 if length(tmp) ~= 1
%                     continue;
%                 end
%                 buf = buf(2:end);
%                 buf(end + 1) = tmp;
%                 x = typecast(uint8(buf), "uint32");
%                 if x == obj.header
%                     break;
%                 end
%             end
        end
        
        % Send UART Synchronization header
        function sendHeader(obj)
            write(obj.port, obj.header, "uint32");
        end
    end
end