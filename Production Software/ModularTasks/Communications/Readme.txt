Communications tasks are the tasks that connect a device to the network. They should be communicated to in a standardised way.
for example:
anytime a task is trying to send a message to the wider network, they should send it to the COMMS_OUT buffer.
anytime a task is trying to receive a message from the wider network, they should try to receive from the COMMS_IN buffer.

Any required hardware coordination should be handled by these tasks, like the RS485 in/out switching should be handled within these tasks. But it should call an externally defined function to toggle the output so it can be adapted to different boards easily.
Something like RS485TXSET/RS485RXSET, this task is defined somewhere in the main body of code or the device specific I/O (since it is device specific).

the wireless in/out is a bit simpler, not requiring the same level of coordination.

These tasks will also include any needed interrupts to function properly.

The communcations standard expects that USART0 will be used for everything related to communications.

The coordinator is a special case, and uses it's own custom defined communications tasks.

wired address is always the sender's address, the round robin ping message includes the target address.
Device type is always the sender's address
Wireless address is contextual (inbound = sender's address, outbound = target address (sender is on wired network and the sending address will be set at the coordinator))
message direction field on wired network can be used to designate a ping as well. (I = in, O = out, P = ping, R = ping response)
this way, a ping message could be made as short as 4 bytes.
([start delimiter], [length], [type], [target])
(0x7E, 0x02, 'P', Device_ID)
the round robin ping gives a device permission to transmit, the device then transmits any buffered messages, and finishes by transmitting the ping response and disabling the transmitter. (transmitter disabling happens only once, when finished sending all messages)
ping response could also be as short as 4 bytes using a special ping response message to indicate the end of messaging.
([start], [length], [Ping Response], [address])
(0x7E, 0x02, 'R', Device_ID)

Typically, an Input message will only come from the coordinator, and the primary effect is to ensure that the devices are paying attention to the wireless address when filtering against the device table.
the Output messages mainly only instruct the devices on the network to not pay attention to the wireless address when filtering against the device table.
the ping and ping response instruct the filtering code to shortcut anything to do with the device table and instead only compare against the device ID of the current device.

the output task is also capable of sending out a specific network join message. (index 255 reserved for join message?)

COMMs tasks are responsible for creating and managing the device table. 