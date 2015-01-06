with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Exceptions; use Ada.Exceptions;

procedure main is
	
	targetURI : constant String := "";
	isSuccessful : boolean;

	procedure initiate_connection (botAddress: in String) is
		Address : sock_addr_type;
		Client: Socket_Type;
		Channel  : Stream_Access;

	begin
		GNAT.Sockets.Initialize;
		Create_Socket (Client);
		Address.Addr := Inet_Addr(botAddress);
		Address.Port := 2345;

		Connect_Socket (Client, Address);

		Channel := Stream (Client);
		write_message_to_socket(Channel, "Message");

		Close_Socket (Client);
	end initiate_connection;

	function check_bot_connection (botAddress: in String) return boolean is 
	begin
		initiate_connection(botAddress);
		return true;
		exception
			when SOCKET_ERROR =>
				return false;
	end check_bot_connection;

	procedure write_message_to_socket (Channel: in Stream_Access; Message: in String) is
	begin
		
		String'Write ( Channel, Message );

	end write_message_to_socket;

	-- procedure attack_order (botAddress, targetURI: in String) is
	-- begin


	-- end

begin
	isSuccessful := check_bot_connection("127.0.0.1");
	if(isSuccessful) then 
		put_line("connected!");
	else
		put_line("not connected");
	end if;


end main;